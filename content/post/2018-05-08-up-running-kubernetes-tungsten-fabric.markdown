---
layout: post
title: Up and Running with Kubernetes and Tungsten Fabric
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2018-05-08"
slug: up-running-kubernetes-tungsten-fabric
tags: ['kubernetes']
---


I have a predominantly technical background. You can show me all the slide decks you want but until I can get my hands on it, it's not real to me. This has greatly influenced what I'm focusing on now that I'm doing more than just technical work - how to reduce the barrier to entry for people to become acquainted with a project or product.

As a result, I've been getting more involved with [Tungsten Fabric](https://tungsten.io/) (formerly OpenContrail). Tungsten is an open source Software-Defined Networking platform, and is a healthy candidate for building some tutorials. In addition, I'm new to the project in general - so, even if only for my own benefit, a blog post summarizing a quick and hopefully easy way to get up and running with it seems quite appropos.

# Introduction to the Lab Environment

We're going to spin up a 3-node cluster in AWS EC2 running Kubernetes, and using Tungsten Fabric for the networking. Why AWS instead of something like Vagrant? Simply put, a lot of advanced networking software require a lot of system resources - more than most laptops are able to provide. In this case, a total of four virtual machines (three-node cluster plus Ansible provisioning machine) with Kubernetes and Tungsten isn't exactly "lightweight", and that's without any applications on top. So this is a good option to quickly spin up or spin down lab all programmatically.

The lab consists of four instances (virtual machines):

- **Ansible Provisioning VM** - started by CloudFormation, responsible for instantiating the other three instances, and installing Kubernetes and Tungsten on them.
- **Controller** - runs Tungsten and Kubernetes controller software
- **Compute01** - runs Kubernetes Kubelet and Tungsten vRouter, as well as any apps
- **Compute02** - runs Kubernetes Kubelet and Tungsten vRouter, as well as any apps

Recently, the Tungsten wiki was updated with instructions and [a Cloudformation template](https://github.com/tungstenfabric/website/wiki/Tungsten-Fabric:-10-minute-deployment-with-k8s-on-AWS) for spinning up this environment. Cloudformation is a service offered by AWS to define a whole bunch of underlying infrastructure in text files ahead of time, so you can just run a single command rather than click through a bunch of GUIs, and presto chango you have a lab.

I took this work and ran with it to provide more opinionated parameters. This makes things a little simpler for our uses, so you don't need to bother with a bunch of inputs to get to a quick Kubernetes/Tungsten cluster.

This lab also uses the relatively new [Ansible provisioning playbooks](https://github.com/Juniper/contrail-ansible-deployer) for doing much of the legwork. Once CloudFormation spins up a single instance for running these playbooks, they'll spin up additional AWS instances, and take care of installing Kubernetes and Tungsten components for us.

# Prerequisites

One advantage of using tools like CloudFormation or Terraform, as well as simpler tools like Vagrant, is that the overwhelming majority of the infrastructure complexity is defined ahead of time in text files, so that you, the user, really only need to do a few things to get a lot of value from this lab. That said, you need to do a few things ahead of time:

- [Install Git on your local machine](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). This allows you to clone the repo that contains our lab files so you can run it.
- [Set up an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/). You'll need to provide a credit card to pay for the compute time. Don't worry, I'll make sure to include instructions for shutting everything down so you don't get charged an arm and a leg.
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) and configure it with your [secret keys and secret access keys](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html) from your AWS account in the previous step. [See here for some insight on where to find these](https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/) - this is how the AWS CLI knows how to authenticate to AWS as you.

# Spin up the "Stack"

CloudFormation defines infrastructure using template files. When we spin up infrastructure using CloudFormation, it refers to it all as a "Stack". I have a Github repo where my modified CloudFormation template is located, so the first step is to clone this repo to your machine:

```
git clone https://github.com/mierdin/tftf && cd tftf
```

Now that we've got the repo cloned, we can run this command to spin up our stack. Note that we're referring to `cftemplate.yaml` in this command, which is the CloudFormation template that defines our stack, located within this repo:

```
aws cloudformation create-stack --capabilities CAPABILITY_IAM --stack-name tf --template-body file://cftemplate.yaml
```

If that runs successfully, you should see it output a short JSON snippet containing the Stack ID. At this point, we can navigate to the [CloudFormation console](https://console.aws.amazon.com/cloudformation/) to see how the set-up activities are progressing:

<div style="text-align:center;"><a href="/assets/2018/05/spin-up-stack.png"><img src="/assets/2018/05/spin_up_stack.png" width="700" ></a></div>

You can navigate to the [EC2 dashboard](https://console.aws.amazon.com/ec2/) and click on "Instances" to see the new instance being spun up by CloudFormation:

<div style="text-align:center;"><a href="/assets/2018/05/ansible_started.png"><img src="/assets/2018/05/ansible_started.png" width="700" ></a></div>

You might ask - why only one instance? Actually this is how the Ansible playbooks do their stuff. CloudFormation only needs to spin up a single instance with Ansible to run these playbooks. Once done, those playbooks will connect to the AWS API directly to spin up the remaining instances for actually running our cluster.

> This means **you need to be patient** - it may take a few minutes for all of this to happen. Read on for details on how to know when the provisioning is "done".

After a few minutes, some additional instances will start to appear (use the refresh button to the right):

<div style="text-align:center;"><a href="/assets/2018/05/cluster_provisioning.png"><img src="/assets/2018/05/cluster_provisioning.png" width="700" ></a></div>

Eventually, you'll see a total of four instances in the dashboard - one for our initial Ansible machine spun up by CloudFormation, and the remaining three that will form our Kubernetes/Tungsten cluster:

<div style="text-align:center;"><a href="/assets/2018/05/cluster_provisioned.png"><img src="/assets/2018/05/cluster_provisioned.png" width="700" ></a></div>

# Accessing the Cluster

While it's possible to SSH directly to any instance, as they all have public IPs provisioned, the Ansible machine already has certificates in place to easily authenticate with the cluster instances. So, we can SSH to the Ansible machine once and find everything from there.

First, grab the public IP address or FQDN of the Ansible instance:

<div style="text-align:center;"><a href="/assets/2018/05/get_ip_ansible.png"><img src="/assets/2018/05/get_ip_ansible.png" width="700" ></a></div>

Then, use that to connect via SSH with the user `root` and the password `tungsten123`:

```
ssh root@<ansible instance public IP or FQDN>
```

You should be presented with a bash prompt: `[root@tf-ansible ~]#` on successful login.

Now that we're on the Ansible machine, we can take a look at the Ansible log located at `/root/ansible.log`. This is our only indication on the progress of the rest of the installation, so make sure you take a look at this before doing anything else:

```
tail -f ansible.log
```

> YMMV here. Sometimes I ran this and it was super quick, other times it took quite a long time. Such is the way of cloud.

You should see `PLAY RECAP` somewhere near the bottom of the output, which indicates Ansible has finished provisioning everything on the other instances. If you don't, let the execution continue until it finishes.

Finally, we can navigate to the Tungsten Fabric (still branded OpenContrail, don't worry about it :) ) console by grabbing the public IP address: 

<div style="text-align:center;"><a href="/assets/2018/05/get_ip_controller.png"><img src="/assets/2018/05/get_ip_controller.png" width="700" ></a></div>

Use that IP or FQDN as shown below in your web browser, and log in with the user `admin` and the password `contrail123` (leave "domain" blank):

```
https://<controller public IP or FQDN>:8143/
```

<div style="text-align:center;"><a href="/assets/2018/05/tungsten_screen.png"><img src="/assets/2018/05/tungsten_screen.png" width="700" ></a></div>

We can use the same FQDN or IP to ssh from our Ansible instance to the controller instance. No password needed, as the Ansible instance already has SSH keys installed on the cluster instances:

```
ssh centos@<controller public IP or FQDN>
```

# Destroy the Lab When Finished

If you wish to clean everything up when you're not using it to save cost, there's a bit of a catch. We can delete our CloudFormation stack easily enough with the appropriate command:

```
aws cloudformation delete-stack --stack-name tf
```

You should eventually see the stack status transition to `DELETE_COMPLETE` in the CloudFormation console.

However, as mentioned previously, CloudFormation is only responsible, and therefore only knows about, the one Ansible instance. It will not automatically delete the other three instances spun up by Ansible. So we'll need to go back into the EC2 console, navigate to `instances`, and manually check the boxes next to the controller and both compute instances, and select `Actions > Instance State > Terminate`.

<div style="text-align:center;"><a href="/assets/2018/05/terminate.png"><img src="/assets/2018/05/terminate.png" width="700" ></a></div>

> You may also have to clean up unused EBS volumes as well. Make sure you delete any unused volumes from the "EBS" screen within the EC2 console. For some reason, CloudFormation isn't cleaning these up from the Ansible instance, and I haven't had a chance to run this issue down yet.

# Conclusion

That's it for now! We'll explore this lab in much greater detail in a future blog post, including interacting with Tungsten Fabric, running applications on Kubernetes, and more.

I hope you were able to get a working Tungsten Fabric lab up and running with this guide. If you have any feedback on this guide, feel free to leave a comment, and I'm happy to improve it.
