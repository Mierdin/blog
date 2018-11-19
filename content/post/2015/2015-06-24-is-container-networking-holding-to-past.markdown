---
layout: post
title: Is Container Networking Holding On To The Past?
author: Matt Oswalt
comments: true
categories: ['Software']
date: "2015-06-24"
slug: container-networking-holding-to-past
tags: ['containers']
---


There has been a plethora of docker-related info on the internet this week, thanks in no small part to DockerCon, and I was motivated to finish this blog post about container networking.

In short, it seems like most if not all container networking projects are going out of their way to give devs the feeling of a "flat" network. My question is - who cares?

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Seems to me that &quot;cloud-native&quot; applications should be okay if two of the cattle are not on the same broadcast domain.</p>&mdash; Matt Oswalt (@Mierdin) <a href="https://twitter.com/Mierdin/status/613553938374090752">June 24, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

> For this post, I am not talking about IaaS (which is arguably a declining use case). I am talking about an application cloud provider (i.e. SaaS, and maybe PaaS) where all IP addresses are assigned by the provider and under their control, within the context of the data center.

The way that most of these projects are being marketed to developers is that they provide one big flat network upon which to communicate. Why this choice of terminology? Why does "cloud-native" application design not **by default** include things like IPv6, or application nodes that are agnostic of what broadcast domain they are participating in?

I have been spending the last few weeks doing research on production container deployments, and I believe it's pretty well known that the VAST majority of applications that are being deployed in production container infrastructure are new-style "microservices" application design, which means they absolutely should not require L2 adjacency between nodes. If this is not true of your container-based application, please contact me, I'd love to hear your reasoning for this.

I have a few examples of what I'm talking about (off the cuff, not an exhaustive list):

- Weave refers to a [giant ethernet switch](http://docs.weave.works/weave/latest_release/features.html) in their documentation
- The recent [Ubuntu Fan](https://wiki.ubuntu.com/FanNetworking) announcement contains several references to "flat" networking (though admittedly they do admit this is an "illusion")
- CoreOS' "flannel" uses [overlay networking](https://coreos.com/docs/cluster-management/setup/flannel-config/) to provide adjacency between containers. Though the abhorrent terms like "flat" are not explicitly used, this concept is presented as a first-class feature which in my mind is mostly the same thing.

> I am **not** suggesting that these solutions are fundamentally flawed. I am **not** suggesting L2 domains in their various forms should be scrapped an available construct. I **am** saying that L2-adjacency shouldn't be viewed as a "given", because I'd argue that most cloud-native applications don't (or shouldn't) need it. It is clear that there will always be use cases that warrant direct L2 connectivity, but this messaging as it stands today will result in tons of L2-dependent software that didn't need to be.


# Does a Container-Driven Datacenter Need Overlays?

If you continue along this thought process, overlays in the datacenter become less important. Overlays are really useful over infrastructure that is under diverse control (the WAN, or the internet, as an example). In contrast, we can typically control the entire physical infrastructure of the datacenter. Therefore, we should be able to get away with a pure layer 3 approach for handling multitenancy of container applications in the data center. Assigning address space to "tenants" becomes an extension of the orchestration that should already be taking place.

The only problem with this (arguably, this is true only for the largest providers or enterprises) is address exhaustion. This is a rare but possible situation in which the provider is unable to provide unique addressing to all of the tenants that are relying on their infrastructure.

This is a legitimate use case for an IPv6-only datacenter, and many of the organizations that reach this scale (there aren't that many) have already gone in this direction. I highly encourage you to get in touch with [Ed Horley](https://twitter.com/ehorley) and [Ivan Pepelnjak](https://twitter.com/ioshints) for examples and technical details about how this is done.

In summary, multitenancy within a container-driven infrastructure can feasibly be handled by integrating with the local firewall on each host (i.e. iptables) and providing orchestration there. 


# A Proposal for New Terms

If you think about it, there is an affinity between the terms "logical network" and these "flat networks". I actually very much understand why this is the case - for a long time we've attributed a "logical network" with a VLAN, which is almost always assigned a single subnet and broadcast domain. 

In the world of containers and microservices, this is simply not a requirement anymore. Logical networks should be sized according to need, and may be composed of a single, or multiple subnets. The applications written in this world just _should not care_ whether the other node in this logical network is on the same subnet, or a different subnet. By virtue of being assigned to the same generic logical network, it is permitted to talk directly to other nodes on that logical network - regardless of subnet. It stands to reason that this whole thing is a discussion about policy - not forwarding or address identification.

Isn't that what developers **really** care about anyways? That they can "just talk" to that other container? Call me crazy, but I don't think it's about how subnets are being laid out.

# Conclusion

Am I suggesting that all of these container networking projects stop providing L2 connectivity between containers? No. My main issue is actually not with the technical aspects of any of the projects here - it's with the prevalence of the messaging that providing these constructs is somehow a "must have". Again, the majority of applications being deployed in production container infrastructure are net-new projects and should not have this requirement.

My message to the developers of applications targeted at these kind of environments is this: do not make the assumption that your application nodes will be part of the same "flat" network, and do not communicate this as a requirement for your app when talking to network operations and engineering.

My message to network engineers and operations teams that deal with containerized applications is this: please make it clear that a logical network can still span multiple subnets or "broadcast domains", because what matters most is the policy of "who can talk to who". Make it clear to your developers that within the context of a logical network, there are no restrictions.

I would hate to give the impression that I believe I'm smarter than anyone behind these awesome projects, so if there is a genuine use case that I haven't addressed here, please comment below and let's have a discussion! These conversations are what is needed most by this industry to move forward.
