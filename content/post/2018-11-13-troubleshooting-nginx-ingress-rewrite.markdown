---
layout: post
title: Troubleshooting NGINX Ingress Rewrites in Kubernetes
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://upload.wikimedia.org/wikipedia/en/0/00/Kubernetes_%28container_engine%29.png
date: "2018-11-13"
slug: up-running-kubernetes-tungsten-fabric
tags: ['kubernetes']
---

When deploying an application to Kubernetes, you almost certainly will want to create a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) to represent that application. Rather than relying on direct connectivity to Pods, which may be ephemeral, Services by contrast are long-living resources that sit on top of one or more Pods. They are also the bare minimum for allowing those pods to communicate outside the cluster.

While Services are a nice abstraction so we don't have to worry about individual Pods, they are also fairly dumb. They don't look at the application layer or allow us to make decisions.
Considering this, there are two main options for directing traffic to the appropriate application within your cluster:

1. Expose services directly outside the cluster using the [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport) declaration, and manually configure an external load balancer to point traffic to the appropriate port based on application-level rules.
2. Use [Ingresses](https://kubernetes.io/docs/concepts/services-networking/ingress/) (and some kind of controller to enforce your Ingress rules) and provide the application routing rules directly to Kubernetes.

The latter option is increasingly popular, for a few reasons. First, it allows us to store our application routing rules "as code", alongside all our other Kubernetes manifests - rather than relying on an external load balancer to be configured correctly. It also provides a high level of automation. Whatever ingress controller we're using will watch for new Ingresses to be created, and will automatically configure the appropriate load balancer.

[NRE Labs](https://labs.networkreliability.engineering) uses this model with the [nginx-ingress controller](https://github.com/kubernetes/ingress-nginx) for two main use cases:

1. `syringe` and `antidote-web` are deployed with their own Ingress rules so that users can access each from the web.
2. Lessons that wish to embed web resources will have ingress rules created dynamically for each resource, so that the client-side of `antidote-web` can access them.

What this means is that whenever an Ingress resource is created, regardless of the purpose, the NGINX ingress controller will pick it up and modify its configuration dynamically.

# The Wrench in the Gears

When building out the functionality to use Ingresses to dynamically create embeddable web resources for lessons, I ran into an issue. When a user loads a lesson that contains a web resource, `syringe` will not only create the appropriate Pod(s) and Service(s) but will also create an Ingress to make sure it's externally available.

To make sure all users can access their respective web resources without stepping on each other, these Ingress rules are designed to present a unique path externally, and rewrite it to the appropriate path per the lesson definition. For instance, if the web resource is a jupyter notebook, the Pod might be expecting something like this:

```
/notebooks/lesson-13/stage1/notebook.ipynb
```

However, that will be the same for all users trying to access this lesson. So, when we create the Ingress, we add a rewrite rule so that externally, the URL is a combination of the underlying Kubernetes namespace, and the name of the web resource:

```
/13-abcdefabcdef-ns-jupyter
```

This path is guaranteed to be unique per-user, per-resource.

The Ingress resource that's created to accomplish this is fairly straightforward. The appropriate NGINX controller annotations specify the rewrite that's to take place:

```yaml
~$ kubectl get ing -n=13-abcdefabcdef-ns -oyaml

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
    annotations:
        ingress.kubernetes.io/ingress.class: nginx
        ingress.kubernetes.io/rewrite-target: /notebooks/lesson-13/stage1/notebook.ipynb
    labels:
        endpointType: IFRAME
        syringeManaged: "yes"
    name: jupyter
    namespace: 13-abcdefabcdef-ns
spec:
    rules:
    - host: labs.networkreliability.engineering
        http:
        paths:
        - backend:
            serviceName: jupyter
            servicePort: 8888
            path: /13-abcdefabcdef-ns-jupyter
tls:
- hosts:
    - labs.networkreliability.engineering
    secretName: tls-certificate
```

And now, the problem. When I was testing this resource, I was getting 404s.

<div style="text-align:center;"><a href="/assets/2018/11/nrelabs_404.png"><img src="/assets/2018/11/nrelabs_404.png" width="700" ></a></div>

However, these were coming from the Jupyter Notebook application, so the actual application routing wasn't the problem - there was
something else going on here. Time to look at the Jupyter logs to see what the incoming requests look like:

```
~$ kubectl logs -n=13-abcdefabcdef-ns jupyter -f

Container must be run with group "root" to update passwd file
Executing the command: jupyter notebook
[I 10:35:44.699 NotebookApp] Writing notebook server cookie secret to /home/jovyan/.local/share/jupyter/runtime/notebook_cookie_secret
[W 10:35:45.083 NotebookApp] All authentication is disabled.  Anyone who can connect to this server will be able to run code.
[I 10:35:45.133 NotebookApp] JupyterLab extension loaded from /opt/conda/lib/python3.6/site-packages/jupyterlab
[I 10:35:45.133 NotebookApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 10:35:45.140 NotebookApp] Serving notebooks from local directory: /antidote/lessons
[I 10:35:45.140 NotebookApp] The Jupyter Notebook is running at:
[I 10:35:45.141 NotebookApp] http://(jupyter or 127.0.0.1):8888/
[I 10:35:45.141 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 10:37:42.191 NotebookApp] 404 GET /13-abcdefabcdef-ns-jupyter (10.44.28.4) 509.43ms referer=None
```

Right there in the Jupyter logs, we can see the rewrite isn't working. But why? In this case, it's best to dive behind the abstraction and look at the actual NGINX configuration that the controller rendered for us from our Ingress definition:

```
kubectl exec -n=prod nginx-ingress-controller-789f6df756-6dbsb grep "jupyter" /etc/nginx/nginx.conf
    upstream 13-abcdefabcdef-ns-jupyter-8888 {
        location ~* ^/13-abcdefabcdef-ns-jupyter\/?(?<baseuri>.*) {
            set $proxy_upstream_name "13-abcdefabcdef-ns-jupyter-8888";
	rewrite /13-abcdefabcdef-ns-jupyter/(.*) /notebooks/lesson-13/stage1/notebook.ipynb/$1 break;
	proxy_pass http://13-abcdefabcdef-ns-jupyter-8888;
```

And there lies the culprit - it appears that the NGINX ingress controller appended a trailing slash to the path we provided in the Ingress definition. Take a look at the two important directives:

- The `location` directive contains the trailing backslash, but uses the `?` regex token to indicate that it's optional. This means that we get routed correctly regardless of the presence of the backslash in the request.
- The `rewrite` directive is not so flexible. The regex used here strictly matches a path that ends in a backslash. If that backslash doesn't exist, the rewrite doesn't happen.

So the net behavior is that our traffic gets routed to the appropriate place, but without the rewrite we asked for. We can see this behavior in action in the shell:

```
curl -i https://labs.networkreliability.engineering/13-abcdefabcdef-ns-jupyter
HTTP/1.1 404 Not Found
Server: nginx/1.11.12
Date: Tue, 13 Nov 2018 10:52:35 GMT
Content-Type: text/html
```

Easy fix, right? Just append a backslash, right? Well here's where it gets wonky:

```
curl -L -i https://labs.networkreliability.engineering/13-abcdefabcdef-ns-jupyter/
HTTP/1.1 302 Found
Server: nginx/1.11.12
Date: Tue, 13 Nov 2018 10:41:30 GMT
Content-Type: text/html; charset=UTF-8
Location: /notebooks/lesson-13/stage1/notebook.ipynb

HTTP/1.1 404 Not Found
Server: nginx/1.11.12
Date: Tue, 13 Nov 2018 10:41:30 GMT
Content-Type: text/html;charset=utf-8
```

We're still getting a 404 with the trailing slash, but before that, we're being redirected to `/notebooks/lesson-13/stage1/notebook.ipynb`. The idea with the rewrite is that the user shouldn't ever see this path, so this is strange. Back to the Jupyter server:

```
kubectl logs -n=13-abcdefabcdef-ns jupyter -f
Container must be run with group "root" to update passwd file
Executing the command: jupyter notebook
[I 10:35:44.699 NotebookApp] Writing notebook server cookie secret to /home/jovyan/.local/share/jupyter/runtime/notebook_cookie_secret
[W 10:35:45.083 NotebookApp] All authentication is disabled.  Anyone who can connect to this server will be able to run code.
[I 10:35:45.133 NotebookApp] JupyterLab extension loaded from /opt/conda/lib/python3.6/site-packages/jupyterlab
[I 10:35:45.133 NotebookApp] JupyterLab application directory is /opt/conda/share/jupyter/lab
[I 10:35:45.140 NotebookApp] Serving notebooks from local directory: /antidote/lessons
[I 10:35:45.140 NotebookApp] The Jupyter Notebook is running at:
[I 10:35:45.141 NotebookApp] http://(jupyter or 127.0.0.1):8888/
[I 10:35:45.141 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 10:37:42.191 NotebookApp] 404 GET /13-abcdefabcdef-ns-jupyter (10.44.28.4) 509.43ms referer=https://labs.networkreliability.engineering/labs/?lessonId=13&lessonStage=1
[W 10:37:57.849 NotebookApp] 404 GET /13-abcdefabcdef-ns-jupyter (10.44.28.4) 3.39ms referer=None
[I 10:39:03.793 NotebookApp] 302 GET /notebooks/lesson-13/stage1/notebook.ipynb/ (10.44.28.4) 1.26ms
[I 10:41:30.675 NotebookApp] 302 GET /notebooks/lesson-13/stage1/notebook.ipynb/ (10.44.28.4) 1.15ms
```

It appears as though Jupyter is exactly as particular about backslashes but in the opposite direction - it is redirecting to a new URL without it.

We can see the fresh 302s, but the 404s we saw on the client side are nowhere to be found. Because we're erroneously redirecting to `/notebooks/lesson-13/stage1/notebook.ipynb`, our browser is sending the second request through the NGINX load balancer, which doesn't have that path in its incoming configuration. The reason we're not seeing the 404s from the redirection on our Jupyter pod is because it's our NGINX load balancer that's reponding with the 404.

# Solution

Fortunately the solution was very easy. I was using a pretty old verison of the NGINX ingress controller, and [a recent PR](https://github.com/kubernetes/ingress-nginx/pull/2899) fixed rewrites for paths not ending in a backslash. Using a newer version of the controller resolved this issue. 

In my research I also came across [a Github issue](https://github.com/kubernetes/ingress-nginx/issues/3148) that recommends using the `configuration-snippet` annotation in lieu of a rewrite annotation, to directly affect the NGINX configuration:

```
nginx.ingress.kubernetes.io/configuration-snippet: |
    rewrite (?i)/ping/service/foo$ /ping break;
```

In my case I preferred to stick with the rewrite annotation and let the controller do its thing, but I think I'll hide this away in the back of my mind for later, it's a useful way of inserting your own custom logic.

Anyways, despite the overwhelming simplicity of the solution, the point of this post was to document my troubleshooting, in the hope that it might be useful to you in your similar endeavors.
