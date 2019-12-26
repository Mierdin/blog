---
layout: post
title: 'Kubernetes: Basic Concepts'
author: Matt Oswalt
comments: true
categories: ['Containers']
date: "2015-11-09"
slug: kubernetes-basic-concepts
tags: ['kubernetes']
---


I have been diving into Kubernetes lately, for both personal and $dayjob reasons. With the combined effect of my attendance at a recent Kubernetes workshop by Kelsey Hightower ([on his very last day at CoreOS](https://twitter.com/kelseyhightower/status/649214103878131712) no less!) and also having the amazing opportunity to attend the inaugural and sold-out [Kubecon](https://kubecon.io/) that starts today, I figured it's high time I tackle a "basics of Kubernetes" post.

<div style="height: 200px;">
   <img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo.png" style="height: 100%;display:block;margin:auto;">
</div>

> This blog post is meant to serve as a very high-level introduction to Kubernetes concepts and components. If you are looking to stand up your own cluster, I encourage you to read the **exceptional** [Kubernetes documentation](http://kubernetes.io/v1.0/). No, really. They're exceptionally good docs.

# Scheduling 101

Within the context of computer operating systems, the "scheduler" is the component that manages the assignment of compute resources to running processes. Especially in the early days before parallel computing and multicore systems, it was crucial to very carefully manage how much CPU time was allowed for the various running processes, so that the user could have a seamless experience. Even today with multicore systems, this is important to ensure that each core is utilized as evenly as possible, or at least to meet certain SLA requirements.

With the rise of x86 virtualization, the imbalance problem was made worse by distributing workloads on an entire cluster of physical servers. A scheduler was needed at this cluster level, and tools like VMware's Distributed Resource Scheduler (DRS), were used to move workloads around a cluster of physical hosts to ensure they were utilized as evenly as possible. This also made the need for additional resource considerations even more evident - schedulers now had to think about things like storage capacity/throughput, network statistics, and more when making a scheduling decision, because the administrator may want to optimize on a specific resource.

In the brave new world of containerized workloads, it may be thought that we've taken a step back - in the sense that our applications are not running on virtual machines anymore, but within containers, which conceptually are really just processes on a server. However, unlike the tech world before virtualization, we still want to deal with our workloads on a cluster level. We still want to be able to deploy our workloads to a set of resources and not care about individual servers. As a result, we still need a scheduling mechanism that ensures these containers are running where they need to be to ensure efficiency in our data centers. Kubernetes is one very powerful platform that provides this and many other services.

> It's worth noting here that Kubernetes is just one (very popular) project that provides this service. There are a myriad of projects that schedule containers, and like Kubernetes, they also come with a variety of additional services and features. In the same way that an operating system is composed of much more than just a scheduler, there are many other services that are needed to make a datacenter work.

# Concepts

There are a few concepts that are worth exploring before we talk about the actual software components of Kubernetes. Keep the scheduling analogy in mind when considering these concepts - Kubernetes is fulfilling a similar role for your entire datacenter, in that it provides a set of APIs to accomplish compute provisioning in an efficient, simple way.

## Pods - "The New App"

This is nothing new - but especially within the context of highly programmable compute infrastructure, it's important to be able to represent an application using some kind of manifest. This could be a text file, or it could be a GUI workflow in a product somewhere. In short, we need a way to describe an application and its dependencies.

In Kubernetes, "[pods](http://kubernetes.io/v1.0/docs/user-guide/pods.html)" provide this mechanism - but they also do several other things.

First off, it's important to remember that pods are the "atom" of Kubernetes. Here, you aren't meant to deploy individual containers - rather, pods are the smallest deployable units within Kubernetes. Thus, all containers run in a pod. Generally, pods are composed of multiple containers that require some shared resources, but this isn't required.

Pods provide a way to share certain system resources among containers within those pods. For instance, as I mention in a [previous post](https://oswalt.dev/2015/10/namespaces-new-access-layer/), all containers in a Kubernetes pod share a single IP address because they are all in the same network namespace.

It's also important to remember that - like containers - pods are not meant to be treated as pets. Unlike the "vMotion" capabilities of server virtualization, pods are not meant to be transferred, but rather killed and restarted elsewhere.

Pods are defined using a very easy to read YAML specification. The cool thing about this - as opposed to going through some GUI form - is that the text file contains everything. No need to pass around scripts full of "docker run" commands; the pod specification declaratively describes an application pod, and everything that pod needs.

Here's an [example pod for running MySQL in Kubernetes](https://github.com/kubernetes/kubernetes/blob/master/examples/mysql-wordpress-pd/mysql.yaml):

    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: mysql
      labels: 
        name: mysql
    spec: 
      containers: 
        - resources:
            limits :
              cpu: 0.5
          image: mysql
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              # change this
              value: yourpassword
          ports: 
            - containerPort: 3306
              name: mysql
          volumeMounts:
              # name must match the volume name below
            - name: mysql-persistent-storage
              # mount path within the container
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-persistent-storage
          gcePersistentDisk:
            # This GCE PD must already exist.
            pdName: mysql-disk
            fsType: ext4



> It's also worth mentioning that you can have multiple pods in a single YAML file by using another set of triple hyphens (which serves as a YAML document delimitor).

This pod description contains useful metadata about the pod, as well as which containers should run in this pod, and which network and storage resources should be provided to them. This YAML file would normally be provided via the Kubernetes client tool, "[kubectl](https://github.com/kubernetes/kubernetes/blob/master/docs/user-guide/kubectl/kubectl.md)" (more on that in a later post).

You might also see references to [cluster add-ons](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons). These are useful pod or service definitions that the community says is the best way to run a certain useful component. The [Web UI](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/kube-ui) is one good example.

See the (extensive) [examples](https://github.com/kubernetes/kubernetes/tree/master/examples) directory for more pod file examples.

## Services and Labels

I'm saving the details of Kubernetes Services and Labels for a future post, since there's a lot to go over here. However, this is a "basic concepts" post, so I'll briefly describe them here. Within the context of Kubernetes, a "service" can be thought of as an abstraction that resides one level above the Pod, and they provide a few features on top of the basic pod definition.

It is highly likely the vast majority of applications deployed onto Kubernetes will be deployed as a service, and not as individual pods. There are some exceptions to this of course, but services provide built-in functionality that pods just do not provide on their own.

For instance, if you try to deploy things directly as pods, Kubernetes will try to fill the first available server in a cluster, rather than spreading these pods over the cluster. However, if you deploy pods within a service definition, Kubernetes knows you probably want high availability. In that case, it will spread over a few nodes.

Services are generally composed of one or more pod definitions. Usually the mapping of which pods fall into a service is done by matching on labels (you might have noticed this in our previous MySQL pod definition example).

    {
        "kind": "Service",
        "apiVersion": "v1",
        "metadata": {
            "name": "my-service"
        },
        "spec": {
            "selector": {
                "app": "MyApp"
            },
            "ports": [
                {
                    "protocol": "TCP",
                    "port": 80,
                    "targetPort": 9376
                }
            ]
        }
    }

See the [Services documentation](http://kubernetes.io/v1.0/docs/user-guide/services.html) for much, much more information. You can also check out the aforementioned "[examples](https://github.com/kubernetes/kubernetes/tree/master/examples)" directory for some examples of service definitions.

# Components

Now that we have the concepts down, let's briefly overview the components of Kubernetes that make all this possible.

<div style="height: 400px;">
   <a href="http://kubernetes.io/v1.0/docs/design/architecture.png" target="_blank">
   <img src="http://kubernetes.io/v1.0/docs/design/architecture.png" style="height: 100%;display:block;margin:auto;">
   </a>
</div>

## Kubelet

The Kubelet is the "kubernetes agent". It provides an API for each server in a cluster that Kubernetes can use to deploy workloads. When deploying Kubernetes, or provisioning a new node in an existing cluster, the Kubelet comes first. It allows a server's resources to be used by Kubernetes.

> If your Kubernetes cluster is running out of compute resources, you may want to spin up some additional nodes to handle the load. In this case, it is very important to be able to provision new servers in an automated fashion, and that includes starting the Kubelet and registering it with Kubernetes. I am working on a solution that leverages a combination of Ansible, [cloud-config](https://coreos.com/os/docs/latest/cloud-config.html) and PXE to automatically provision new nodes, but this is by far not the only way to do this. The key thing to remember is that it is crucial that you automate this process. 

Once the Kubelet has been started on one server, the "server" components of Kubernetes can be bootstrapped by manually deploying a pod definition for these services on that kubelet. This is not the only way to deploy the server components, but it's a very valid approach.

## API Server

If there was a "central" component of Kubernetes, it would be the API Server. **Everything** in the Kubernetes infrastructure communicates directory with the API Server, and not with each other.

The API server is heavily plugin-driven - and doesn't do much on it's own (though several API plugins come packaged with Kubernetes). It's main job is to provide a [central place of programmatic access](http://kubernetes.io/v1.0/docs/api.html) - both for components within Kubernetes to figure out how to deploy containers, but also for external entities to work with Kubernetes.

> The API server also functions as a proxy to [etcd](https://github.com/coreos/etcd), where all state for Kubernetes is kept. More on this later.

## Replication Controller

[Replication controllers](http://kubernetes.io/v1.0/docs/user-guide/replication-controller.html) ensure that we are running the right number of copies for a pod. This is really useful for applications that easily scale out by simply running more instances of them (i.e. a web server).

Replication Controllers are also described using a YAML format:

    apiVersion: v1
    kind: ReplicationController
    metadata:
      name: nginx-controller
    spec:
      replicas: 2
      selector:
        role: load-balancer
      template:
        metadata:
          labels:
            role: load-balancer
        spec:
          containers:
            - name: nginx
              image: coreos/nginx
              ports:
                - containerPort: 80

We can use the kubectl client to install this definition, as well as set the number of "replicas" for a given replication controller (as shown below):

    kubectl scale rc webserver --replicas=10

The YAML file defines WHAT the replication controller does, and then the "kubectl scale" command will instruct Kubernetes to ensure that this controller maintains 10 copies of the pods or containers specified in the definition.

## Etcd

Finally, it's important to remember that everything in Kubernetes is completely stateless. As a result, it stores and retrieves this state within [etcd](https://github.com/coreos/etcd), a popular distributed key/value store. 

Etcd is the single source of truth for Kubernetes, but it's not ideal to have the various components of Kubernetes communicate directly with etcd. So, as mentioned before, the API server serves as a "proxy" of sorts, centralizing and validating all communication with etcd.

Also, etcd was not built for speed - it was built for consistency. If etcd says something is true, it means it's actually true, not that it will be true soon. This is an important consideration to keep in mind when selecting a key/value store. This particular tradeoff is useful for the Kubernetes use case specifically - as it's very important to ensure that we have accurate container deployment information.

# Conclusion

This post covers the basics of Kubernetes. We will explore more advanced topics in a future post, as well as provide some tools for getting your own cluster set up at home!

In addition to the exceptional [Kubernetes Documentation](http://kubernetes.io/v1.0/), you should also check out [this really great series](http://www.dasblinkenlichten.com/kubernetes-101-the-constructs/) by Jon Langemak - he did a lot of deep exploration into actually setting up a Kubernetes cluster by hand.

I'm off to enjoy [Kubecon 2015](https://kubecon.io/) - please let me know if you have any questions or corrections in the comments below, I'm open to all!