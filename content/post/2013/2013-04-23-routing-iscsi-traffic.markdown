---
layout: post
title: Routing iSCSI Traffic
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-04-23"
wordpress_id: 3607
slug: routing-iscsi-traffic
tags: ['FCoE']
---


This post was initiated by a side conversation I had about iSCSI. From time to time I'm required to implement an iSCSI-based solution, and this is not the first time I've heard the question: "So why can't I route iSCSI traffic?" Most folks with any knowledge of storage protocols will have at some point picked up this informal best practice idea; some will vehemently defend this idea as the word of $deity and shun all those who contradict this truth.

> Disclaimer: this post is based on my experience. I realize (and hope) this may kick off some debates - just keep it healthy. Comments below are an open door.

First off - I believe the argument is moot for use cases other than production datastores. A good example of something else would be using iSCSI for asynchronous replication; this idea is okay in nearly every case. DCIs are usually provided with L3-only connectivity (as they should), so routing is not optional in this case. iSCSI runs over So for asynchronous site-to-site replication, you're okay.

For actual synchronous I/O, let's say from a vSphere cluster, the story is a little different. I'm going to go ahead and spoil the story and say that it can still be okay, but there's a few important caveats.

## Latency

The big argument against routing iSCSI traffic is that it incurs an undesirable amount of latency. Block-level reads and writes generally require a certain guarantee of performance, which in legacy Fibre Channel networks was not nearly as much of a concern as it is when using dumb ol' Ethernet. 10GbE has made great strides in this area because it helps guarantee sufficient pipe to transfer the data. Latency, however, is a killer for obvious reasons - if the latency is high, the server spends too much time waiting on read requests to come back or write requests to be acknowledged, and workloads suffer.

However, latency is a concern for two reasons. First off, if you do decide to route the traffic (it has an IP header, so go ahead, right?) be aware of the difference between hardware and software routing. Cisco IP/IPv6 CEF, for instance is a great way to provide near line-rate performance when routing traffic from one network to another. This is a fundamental concept in Layer 3 switching. So when I say it's "okay" to route iSCSI traffic, I'm not suggesting that this be done in software. The industry is full of hardware-based solutions for making this pain go away.

The other factor that would make latency a concern is the fact that iSCSI runs over TCP. I came across Greg Ferro's [post](http://etherealmind.com/why-does-iscsi-use-tcp/) on the subject and he mentions that the TCP checksum calculation adds additional latency between endpoints, in addition to the simple fact that the TCP header is extra overhead. Take FCoE, for instance. It's a very well-recommended best practice to deploy FCoE with some very careful QoS-related precautions put into place. In addition to bandwidth guarantees, priority fair-queuing and no-drop policies are crucial to deliver the same kind of delivery guarantees that traditional FC-storage admins have been used to in the past.

The Nexus 5000 series comes with some [pre-built QoS policies](http://www.cisco.com/en/US/docs/switches/datacenter/nexus5000/sw/qos/513_n1_1/b_cisco_nexus_5000_qos_config_gd_513_n1_1_chapter_011.html) designed solely to protect FCoE with attributes I just mentioned.

So, when designing iSCSI networks, make sure these mechanisms are put into place as well.

## Endpoints and ASICs

From an endpoint perspective, the current TCP Offload Engine implementations available on the market are pretty good. [Broadcom's 5709C](http://www.broadcom.com/products/Ethernet-Controllers-and-Adapters/Enterprise-Server-Controllers/BCM5709C) is a fairly common card that provides iSCSI in hardware on an otherwise standard ethernet NIC ([10GbE too](http://www.broadcom.com/products/Ethernet-Controllers-and-Adapters/Enterprise-Server-Controllers/BCM57712)). ASICs like these have existed for a while to provide iSCSI connectivity solutions that don't include dedicated iSCSI HBAs or poor-performing software adapters. So while the endpoint part of all this isn't relevant to the routing argument per ce, it does provide a nice warm and fuzzy that it shouldn't be the focus of concern.

## Summary

In summary, iSCSI (yes, even routed) can work quite well as long as you use common sense and a few good ideas:
	
* Use some kind of hardware-based L3 switching. Cisco's example is IP CEF. This delivers near line-rate forwarding of packets, meaning that latency is kept to an acceptable minimum. Be aware of the types of [traffic that must be punted](http://www.cisco.com/en/US/products/sw/iosswrel/ps1828/products_tech_note09186a00801e1e46.shtml) to the routing process (bad for latency)

* I can't lab this at the moment but I'd love to see a case study where iSCSI over MPLS was done. In theory this should still provide as low-latency connectivity as possible, aside from the fact that if it's an MPLS network there's likely a large amount of pure distance involved. The point is that label switching isn't going to add inordinate amounts of latency, so that particular medium could be okay.

* I won't go so far as to say you need dedicated iSCSI infrastructure. If you have the budget, knock yourself out. Most don't (and it's IP traffic so why the excess waste?), so while it is probably okay to share the infrastructure with other types of traffic, have a reasonable amount of confidence that the traffic you are sharing the infrastructure with won't impact the ability for the switch to forward iSCSI traffic at line-rate, both from a CPU/backplane and bandwidth perspective. That leads really nicely into the next point...

* Use QoS policies similar to the recommended policies for FCoE. Dedicate bandwidth to iSCSI in the event of congestion. Perform traffic shaping for other traffic types if you have to. Use PFC to guarantee iSCSI is given priority

* Use hardware/ASIC solutions wherever possible. Current software solutions just don't meet the performance needs right now. Maybe they'll get there, but for now the hardware is cheap and works well. This will help keep the CPU overhead to a minimum.
