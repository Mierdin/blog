---
layout: post
title: Nexgen Storage (Part 1) - Solution Overview
author: Matt Oswalt
comments: true
categories: ['Storage']
date: "2013-01-11"
wordpress_id: 2785
slug: nexgen-storage-part-1-solution-overview
tags: ['iscsi']
---


I was given the privilege to tinker with some gear from my friends over at Nexgen Storage. For those that have not heard of them, I encourage you to head over to [http://www.nexgenstorage.com/product/technology](http://www.nexgenstorage.com/product/technology) and take a peek at the solution. They are one of the "little guys", but they're doing some cool things with respect to performance, and providing the ability to give priority to certain tiers of applications or tenants that are using the system.

## Overview

First, like any other storage solution, Nexgen provides long-term data retention via some kind of spinning disk, or if price is no object, all SSD's (not cost effective for nearly everyone, IMHO). These are offered inside the controller/chassis itself if you don't need a ton of capacity, or in additional disk shelves. There are three models, (n5-50/n5-100/n5-150) and the difference between them is found in the maximum storage capacity as well as IOps they can each provide through the difference in caching architectures. Nexgen's focus is on performance, no doubt about it. Every presentation is riddled with slides showing some derivation of the architecture shown below:

[![hl_arch_nexgen](assets/2013/01/hl_arch_nexgen.png)](assets/2013/01/hl_arch_nexgen.png)

Nexgen has partnered with FusionIO to provide SSD caching capabilities, and they've built the controllers to provide this caching as close to the network ports as possible, by placing this SSD directly on the PCIe bus itself. This means that data does not need to traverse the entire controller from front to back, the caching is done in the shortest distance possible.

Now - every storage vendor is doing caching of some kind, so what's different about this? Yes, it does read caching so that when there's a particular block that's getting read very often, it's copied to the SSD so that the spinning disks don't have to be bothered as much - take for instance operating system files, things that are accessed regularly, and likely from multiple locations. However - this also serves as a write cache. Write requests are received by the Nexgen controller and are immediately written to the SSD cache, not the higher-capacity drives in the front. This allows the write request to be acknowledged, and allows the server to move on.

The FusionIO technology caches data in the PCIe SSD drive in tiers, meaning that more blocks can be reserved for higher-tier applications.

[![data placement](assets/2013/01/data-placement.png)](assets/2013/01/data-placement.png)

Another cool feature that is really a by-product of this architecture comes into play. In-line deduplication is now no big deal, since dedupe can take place on the SSD itself, not just on the spinning disks. Scheduled dedupe will still take place, but only using surplus I/O resources, meaning the I/O you have guaranteed to your volumes will not be impacted by dedupe. By the way, this particular brand of dedupe is a byte-by-byte comparison, not the extremely common "block hash" method.

## Particulars

Nexgen's vision obviously stresses that PCIe is the way of the future for storage architectures. Every presentation is riddled with this design. As the controllers are basically just x86 blades (as we'll see in the next post), we're able to use really cost effective processors for parallel processing. Nexgen's whitepapers mention that each of their storage systems have 48 cores (I believe it's 12 cores times 2 CPUs times 2 controllers), which allows for some good compute power, and is capable of using the full PCIe bus bandwidth. This non-proprietary approach is not completely original (see [HP ProLiant storage](http://h18004.www1.hp.com/products/servers/platforms/storage.html) and many others) but seems to be the first that directly targets the PCIe bus for enhanced performance.

Historically, performance has been attacked with solutions like [tiering](http://www.compellent.com/Products/Software/Automated-Tiered-Storage.aspx), or well as standard [flash-based](http://www.netapp.com/us/products/storage-systems/flash-cache/) (or other) caching mechanisms. Of course, the original solution to increasing performance has been to spread data across more spindles, which is no longer an acceptable answer.

## Summary

My main problem with the solution is that the "QoS" feature is incomplete. I would like to see them incorporate CoS or DSCP marking for the iSCSI write requests, and receive the same prioritization on the network.

Rather than simply "more spindles", performance must be addressed by architectural innovations in order to keep pace with ever-increasing demand from killer applications like VDI.

If your priority is performance, especially guaranteeing performance to a particular app (or tenant), then Nexgen is worth a look. However, there are just not a lot of features at this time, most administrative control in the current version of the operating system is limited. Most experienced storage administrators will not like how little they are able to do with the system, while new users will appreciate the simplistic interface, dashboard-like reporting, and hands-off performance guarantees.

> Nexgen did not provide any equipment for free, nor did they have anything to do with the writing of this article.