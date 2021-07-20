---
layout: post
title: What is a "Best Practice"?
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-12-19"
wordpress_id: 5158
slug: what-is-a-best-practice
tags: ['best', 'practice']
---


I see a lot of articles and even vendor whitepapers that like to throw the term "best practice" around like it's pocket change. Truth be told, while there are plenty of general best practices that are recommended in any case, many of what a vendor will call "best practices" are usually just the most common response to an If/Then statement that represents the surrounding environment.

[![](https://i.chzbgr.com/maxW500/3164785920/hC56543CD/)](https://i.chzbgr.com/maxW500/3164785920/hC56543CD/)

Here's a good example. I've heard on multiple occasions regarding the standard vSwitch in VMWare vSphere that it is a "best practice" to set the load balancing policy to "route based on the originating virtual port ID".  This Load Balancing Policy is no exception. There is no "best practice" for configuring this policy - each policy is selected based entirely on what the upstream switching configuration looks like. (The default of "virtual port ID" is there I'm guessing because it's the most common use case.)

[![diagram1](/assets/2013/12/diagram1.png)](/assets/2013/12/diagram1.png)

Allow me to elaborate.

This "virtual port ID" policy is used when you have two different upstream switches that aren't using any kind of MLAG (like Cisco's vPC or VSS), in other words, they are completely separate switches that may or may not be connected to each other. This policy allows the MAC addresses of the virtual machines and VMK interfaces to be learned on a single interface at any given time, so there's no issue with connecting multiple switches. (By the way, route by source MAC works more or less the same way)

Does this mean that selecting this policy is a "best practice"? Many leading VMware experts have told me that it is. I would suggest that it is **if** the upstream switching configuration warrants it. This would mean two separate (no MLAG) switches, for example. I work with Cisco UCS and from a basic perspective, those represent two separate switches with no vPC or anything, so I use this policy. When using stacked switches, however, I can form a port channel to each rackmount ESXi server without requiring LACP, so in that instance, it is a "best practice" to route based on IP hash. All depends on what I'm doing in that configuration.

In my opinion, stating best practices, especially in documentation, is all about wording. A properly stated best practice would be 

> "in the presence of _ it is best to do _" etc. Not just "doing _ is a best practice".

Saying the latter would be like saying that when driving somewhere, it is always best to turn right. Of course this is a preposterous way to give directions; the driver may need to turn right OR left...it all depends on where they are in the trip.

This is why there are so many "it depends" in technology....truly we're all in this to integrate various systems together - that's kind of what IT is. Therefore, I posit that a "best practice" is at least one "if/then" statement that first tries to narrow down the operating environment before giving a recommendation for how to turn the nerd knob. This is also why it is so super important that we as technologists learn EVERY aspect of integration points like the example I gave.

As a VMware expert, should you learn everything about routing and switching? Probably not, but you should know everything about how the integration with your stack takes place, such as the inner workings of a port channel - perhaps a high-level understanding of the various MLAG technologies that vendors are offering, as well as what LACP truly does and does not do. Understanding these integration points is the key for getting what has traditionally been two siloes technology skillsets to at least communicate well on a basic level.

(This post brought to you by a pet peeve of mine that I've never thought to write about until now.)
