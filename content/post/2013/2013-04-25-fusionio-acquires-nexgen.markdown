---
layout: post
title: FusionIO Acquires Nexgen
author: Matt Oswalt
comments: true
categories: ['Storage']
date: "2013-04-25"
wordpress_id: 3628
slug: fusionio-acquires-nexgen
tags: ['fusionio']
---


For anyone keeping tabs on the storage industry these days, you might have noticed the news today regarding [FusionIO's acquisition of Nexgen](http://www.fusionio.com/blog/exit-to-the-beginning/) - one of a myriad of storage startups that have cropped up in the past few years to address the ever-changing needs of the data center industry. After looking through some of the articles that were published today, I think we all understand the financial details behind the transaction. Not many have posted their thoughts on the technical strategy behind the move. So here's mine.

In many respects, storage is an area of technology that has changed the most in recent years, so any company that addresses a pressing need and does it well will prove very valuable even with the shortcomings that come with just a simple lack of maturity. Nexgen has done a good job of helping to pioneer the idea of PCIe-based SSD inside a traditional storage array. Of course the marriage between FusionIO and Nexgen makes sense from this perspective because Nexgen's entire idea is based on FusionIO's performance. However, Nexgen offers a little more than just a chassis for these cards.

I've [written about the Nexgen solution](https://keepingitclassless.net/2013/01/nexgen-storage-part-1-solution-overview/) before, [even done a hardware overview](https://keepingitclassless.net/2013/01/nexgen-storage-part-2-hardware-overview/). I have worked with quite a few folks from Nexgen, especially in the past few months. They know what they're good at, and they know what they're not good at. The internal logic of the array does some pretty cool things with respect to inline dedupe. The idea of [dynamic data placement](http://www.nexgenstorage.com/sites/default/files/FB_ioControl_TakeControl.pdf) is a pretty groundbreaking way to meet **per-tenant** IOps SLA metrics. It doesn't hurt that the graphs are pretty.

They are also aware of the problems that comes with simply being young. Their background in coming from LeftHand means they knew what it took to get storage customers' attention right away, and though they've done it very well, it does mean that their solution isn't where the other guys are when it comes to software maturity and features.

Now to the acquisition - if it were to ever happen, I think everyone would have known FusionIO would be the one to pull the trigger. FusionIO has provided cards for compute (i.e. Cisco UCS) for a while, and obviously close partners like Nexgen for a while. With companies like EMC just about to hit the market with PCIe-based SSD competition, the timing is interesting to say the least.

> By the way, Nexgen team - this kind of announcement literally less than 24 hours before you go in front of the [Storage Field Day 3](http://techfieldday.com/event/sfd3/) delegates? Nice.

I think it's clear that this acquisition is going to put Nexgen in a really good place. I think their message right now is fine - they have their market, and a great purpose-built product. Now with the resources of a company like FusionIO they can focus on some of the advanced features they just haven't had a chance to get to just yet.
