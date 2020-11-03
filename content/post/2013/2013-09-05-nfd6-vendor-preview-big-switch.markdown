---
layout: post
title: 'NFD6 Vendor Preview: Big Switch'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-09-05"
wordpress_id: 4588
slug: nfd6-vendor-preview-big-switch
tags: ['big', 'switch']
---


Big Switch will be making their first appearance at [Network Field Day 6](http://techfieldday.com/event/nfd6/) next week, and I'm pretty excited to hear their session.

This isn't their first appearance at a Tech Field Day event, however. They first appeared at the [OpenFlow Symposium](http://techfieldday.com/event/ofs11/) back in 2011. I re-watched that video and realized that they were talking about network virtualization a long time ago. They even made the statement that they viewed SDN "like VMware but for networking" - something we're hearing a lot of these days. This session is where I first heard OpenFlow referred to as an "x86 instruction set for networking".

They make the point that "infrastructure as code" is an idea that was always possible, but made much more practical by server virtualization. All of this SDN stuff is aimed at helping to reduce time spent on repetitive, simple tasks. While that was always a noble goal, it wasn't as feasible or practical because there really was no bottleneck - everything was slow. Since we've gotten a lot more efficient at spinning up virtual machines, we need to do the same for the network.

There are quite a few SDN controllers available today, many are open source. Big Switch focuses pretty heavily on the applications riding on top of the SDN controller, and relies on innovations elsewhere in the industry for the controller and data planes. They recognize that there are a few different ways to build out that section, so they focus mainly on using that "x86 instruction set" and making it useful to applications that need advanced networking functionality.

This essentially puts them in the same category as [OpenDaylight ](http://www.opendaylight.org/)(which they used to be a member of but [not anymore](http://www.networkcomputing.com/data-networking-management/big-switch-leaves-opendaylight-touts-whi/240156153)) and in my opinion, VMware NSX. All three are aimed specifically at providing a layer above the controller for the apps to easily inter-operate with network functions made possible by an SDN controller.

My main interest for this session is seeing what they've been doing since the symposium in late 2011 and how they're choosing to work with or against the recent developments from other vendors in the SDN and network virtualization space. I look forward to hearing from these guys at NFD6.

This [recent post](http://www.sdncentral.com/news/breaking-news-big-switch-angling-cisco-acquisition/2013/09/) is also very interesting. I wonder if there will be a word from Big Switch regarding this at NFD...
