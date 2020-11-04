---
layout: post
title: Network Function Abstraction Redux (Now with DevOps!)
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-10-22"
wordpress_id: 4819
slug: network-function-abstraction-redux-devops
tags: ['api']
---


[I wrote a few days ago](https://oswalt.dev/2013/10/opendaylight-and-those-pesky-southbound-apis) about how cool projects like OpenDaylight are abstracting network functions into consumable policies that non-network folks can use (and that's a good thing!). I felt this quick follow-up was necessary.

Providing the right tools to the application folks that allow network provisioning to occur as quickly as anything else that's software-defined, such as servers, while keeping those tools light on the learning curve, is exactly what the apps folks have been wanting from the network for the last 10 years or so. OpenDaylight allows us to hand off a single interface that combines many "southbound APIs" together in order to manage everything from your open source hypervisor switch all the way up to the black box at the end of the cabinet row.

Another term that's pretty much past the hype cycle, just a bit older than SDN itself, is the concept of DevOps. One of the reasons why concepts like SDN started becoming a big deal because DevOps folks had been chugging away in the DC for quite some time, doing really cool stuff like automating server configuration. We on the network side wanted that - and everyone else wanted that from us.

Jeremy Schulman, who really is one of the leading pioneers of bringing DevOps into the networking world, does a great job for Juniper at [Networking Field Day 5](http://techfieldday.com/event/nfd5/), outlining how a Puppet agent on a networking device may be of some use to us. This video was not only a nice demo of how DevOps can really help to improve compute and network resources operationally but just a great conversation about IT operations in general.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/NuyamiblDng" frameborder="0" allowfullscreen></iframe></div>

This is quite a unique model of network automation, given all of the recent products involving control plane separation and whatnot. Here, the puppet agent installed on each device merely takes advantage of a local XML API, which could also just as easily be consumed by another outside entity.

[![diagram1](/assets/2013/10/diagram11.png)](/assets/2013/10/diagram11.png)

The value in using Puppet in this way, rather than a separate tool that calls the XML directly, is that Puppet is a known commodity among DevOps groups today. Bringing Puppet into the discussion of network provisioning is clearly targeted at shops that already have a strong DevOps-practicing operations team. Those guys don't know, nor should they, how to configure a VLAN trunk. The role of the network engineer then moves into more design, and more supplying the DevOps guys with the tools they need to automate network-centric tasks.

So, Puppet is in my mind a little bit at odds with the current SDN model. A controller-based SDN structure is nice for things like service insertion in the hypervisor across the data center, and ODL can abstract these APIs, providing a single interface for your infrastructure. However, Puppet on the network also has advantages, if you already have a team that uses it to operationalize the rest of your data center. Both seem to offer tools without increasing network awareness of non-network folks. Just a different provisioning model, and it greatly depends on your current personnel.
