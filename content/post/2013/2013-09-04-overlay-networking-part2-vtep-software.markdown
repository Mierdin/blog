---
layout: post
title: '[Overlay Networking] Part 2 - VTEPs and Software'
series:
- Overlay Networking
author: Matt Oswalt
comments: true
categories: ['Virtual', 'Networking']
date: "2013-09-04"
wordpress_id: 4505
slug: overlay-networking-part2-vtep-software
tags: ['netvirt']
---


In the previous post, we discussed the role of the overlay network, and the virtual switches they connect to. In this post, we're going to talk about a few additional components.

## The Role of the Hardware VTEP

There's been a lot of talk about VTEP, and how virtually every networking vendor but Cisco is part of this elaborate ecosystem of vendors that contribute to the angelic glory that is NSX. Let's put the politics aside and talk about what (specifically hardware) VTEPs could do, even if they're not doing them right now (announced and shipping are two very different things. :) )

Two points here - first, the low-hanging fruit is the non-virtualized workloads. How do these integrate into this brave new world? Well, whether you're talking VXLAN or whatever, you need some kind of device that speaks overlay. If you can't speak overlay, and somehow terminate that network so that you can insert other traffic types inside, then you're not doing much good. VTEP stands for VXLAN Tunnel End Point (thus VXLAN is a requirement here, but more on that later). One thing we can do with these is provide a sort of translation boundary between the overlay network and the physical devices. So you'd set up one port to participate in a VLAN of your choosing, plug your physical server in there, and configure the VTEP to inject that VLAN's traffic into a VXLAN of your choosing.

[![diagram3](/assets/2013/09/diagram3.png)](/assets/2013/09/diagram3.png)

Ultimately this should be the job of the SDN controller, since the VTEP is little more than a distributed linecard at this point.

We've been talking about this kind of device for some time, just not with this name. Think about what a device like this would be with a pure OpenFlow/OVSDB implementation (and it sounds like most announced VTEPs will also support OpenFlow/OVSDB). Same thing, just without the vXLAN tag. We plug physical devices in, but rather than rely on the flood and spray methodology of Ethernet or the standard forwarding behavior of routing protocols, we can define our own forwarding through a centralized controller. Same car, different engine.

These are a few of the tweets I picked up in the last week or so - they can help give some ideas for how hardware VTEPs are used and how they work.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/santinorizzo">@santinorizzo</a> <a href="https://twitter.com/networkingnerd">@networkingnerd</a> <a href="https://twitter.com/Mierdin">@mierdin</a> NSX has gateway VMs as soft VTEP or you have HW VTEP. Both support OpenFlow &amp; OVSDB.</p>&mdash; EtherealMind (@etherealmind) <a href="https://twitter.com/etherealmind/status/373515083064020992">August 30, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/etherealmind">@etherealmind</a> <a href="https://twitter.com/santinorizzo">@santinorizzo</a> <a href="https://twitter.com/Mierdin">@Mierdin</a> Okay, so the plugins for phi VTEP participate in NSX. They offer visibility. Got it.</p>&mdash; Tom Hollingsworth (@networkingnerd) <a href="https://twitter.com/networkingnerd/status/373518863347879936">August 30, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Mierdin">@Mierdin</a> <a href="https://twitter.com/etherealmind">@etherealmind</a> Non NSX hosts can decap the vWire. Think MPLS PHP. Maybe NSX host agents down the road?</p>&mdash; Tom Hollingsworth (@networkingnerd) <a href="https://twitter.com/networkingnerd/status/373507974817280001">August 30, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## The Role of the Software

This is pretty simple. The software on top is what makes this all work. While technology like OpenFlow, OVSDB, vXLAN, etc. are cool to talk about, they're just building blocks. Those same building blocks that are being used to do great things in one product can be used to do not-so-great things in another. SDN is about centralizing control so that we don't have to spend time doing simple m/a/c requests when we could be doing it from a central intelligent point. I used this graphic in a previous post and it applies pretty well here. SDN started in the virtual realm because it was easy, but should absolutely encompass the physical world, as we saw in the previous section about VTEPs.

[![diagram3](/assets/2013/08/diagram3.png)](/assets/2013/08/diagram3.png)

The controller needs to be aware of all of the overlay networks so that it can coordinate between hypervisors, and keep things straight.

This is also where we get implement nifty network services like distributed routing in the vSwitch, load balancing, firewalling, etc. etc. That's ultimately the job of the controller, since we've now centralized the control plane. The data plane now just does what it's told.

As a data center network engineer, I've spent a lot of time thinking about the "underlay", or the physical infrastructure on which these overlays run. I have split this off into a third and final part, [Part 3](https://keepingitclassless.net/2013/09/overlay-networking-part-3-underlay/).