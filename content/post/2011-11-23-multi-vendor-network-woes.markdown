---
layout: post
title: Multi-Vendor Network Woes
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-11-23"
wordpress_id: 1730
slug: multi-vendor-network-woes
tags: ['ccnp']
---


First, I'd like to thank you all for continuing to read my thoughts these last few weeks. Some already know that I passed the CCNP ROUTE exam this past weekend, and that has slowed my ability to write consistently. Fortunately, I laid that beast of an exam to rest and I get to focus on bigger, better things.

I've been working a project for the past few weeks that's involved the integration of HP and Cisco networking equipment. The project itself is intended to replace HP gear with Cisco switches, but that's not something that can just take place overnight, so there's a lot of integration that has to go on during the process. I will do my best during this post to not make fun of HP's networking equipment because realistically, many customers are running HP at some places in their network, and in some use cases, it's a good fit. As a result, we need to be aware of some pretty dangerous landmines when working with integrated networks, especially when designing change windows with such an environment.

First off, every change should have been put through some sort of lab testing. When you're integrating two types of networking platforms, even if you're using nothing but "open standards" like OSPF or STP, there's no reason to assume they'll play nice together. If you're short on lab equipment, you should still find a way to slowly introduce a new piece of equipment, rather than cut over all the cables and hope it works. Keep in mind that the purpose of a network change is to be successful with minimal downtime - and if it cannot be, then it needs to be easy to back out.

The aforementioned project was in an environment that was made up of 4 HP 9315s at the core, and the task was to replace them with 2 Cisco 6509s as a VSS pair ([Check out my post](https://keepingitclassless.net/2011/10/virtual-switching-system-on-cisco-catalyst-6500/) on VSS, I think it's pretty cool). One important thing to worry about with integrating switching platforms is how their implementations of Spanning Tree work together. Since we had some extra switches (HP and Cisco) we were able to lab this concept pretty thoroughly, but for the sake of being exhaustive with our testing, we decided to design the change window in a way that slowly introduced the Cisco switches into the environment. We did this not only for the sake of preventing a "rip and replace" scenario, but also because we wanted to see how the spanning tree configurations would work together. The HP switches were not capable of any PVST implementations, so we had to configure Multiple Spanning Tree (ugh) on the Cisco core. In doing so, we discovered an issue that would have caused our change to go downhill fast, and we were able to back out with no issue because of our testing.

Another thing I've come across is the need to keep your network devices updated to current code levels. Newer code revisions of HP Procurve switches are able to integrate (somewhat) well with Cisco switches when it comes to PVST, but older code will only be able to run 802.1s Multiple Spanning Tree which is **abhorrent**. I'm not going to say that you should get to the newest version of code no matter what all the time, because that's unrealistic, and also because sometimes the newest version isn't any better because of bugs, etc. However, I will say this - be aware of feature sets that exist in current code releases and if there's any improvements in newer versions. Be aware of any features that are discontinued in future releases - maybe your in-place feature is being phased out, and if you're too heavily invested in that feature, it will prevent you from upgrading, at least easily. Do not get caught in that situation, because many other things will begin to suffer. Many times a multi-vendor integration can go bad simply because of old buggy code.

## Matt's Mind

The bottom line is this: Using multiple vendor's equipment in your environment isn't necessarily a no-no. Just like anything else, such a design requires the network engineer to be vigilant in their design, but more than anything, it requires proactive monitoring and optimization to succeed. Be aware of any potential issues with each integration, and if there's not a wealth of information about your particular design, lab it up first - always.

It all comes back to how the network is being run. Pure Cisco networks are expensive, so if the lighter devices are a different vendor, most of the time it's no big deal, as long as you can get ahead of some of the issues that present themselves, and to always have a plan for continuing to optimize network operations.
