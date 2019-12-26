---
layout: post
title: Jumbo Frames Beyond the Broadcast Domain
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-03-12"
wordpress_id: 3205
slug: jumbo-frames-beyond-the-broadcast-domain
tags: ['fragmentation']
---


I've run into many circumstances where jumbo frames are enabled, most notably in the data center. After all, allowing for a maximum tranmission unit of greater than 1500 bytes allows us to transmit more data per frame

As I explained in [Part 2 of my QoS Series](https://oswalt.dev/2012/11/qos-part-2-qos-and-jumbo-frames-on-nexus-ucs-and-vmware/), MTU can be a touch subject. Do it wrong, and you encounter one of two big network problems. One potential issue when configuring jumbo frames at L2 is that stuff just doesn't work. Switches that attempt to forward a frame out of a port that through policy or otherwise has an MTU setting lower than the frame size, the frame is dropped. This is true if a port with a smaller MTU receives such a frame. The traffic just dies.

[![layer2](/assets/2012/11/layer2.png)](/assets/2012/11/layer2.png)

Interestingly enough, Layers 4 and 7 can hurt us even further here, since it's possible that traffic doesn't always use the full 9000 bytes it's allowed, resulting in traffic working some of the time, but sometimes not working. It's not fun to troubleshoot this kind of behavior, trust me.

Routers are intelligent enough to get around this, but only by fragmenting the packet, which not only defeats our original purpose of getting better performance out of the packets, but it also results in some really weird behavior in general.

[![layer3](/assets/2012/11/layer3.png)](/assets/2012/11/layer3.png)Now - it's not a terrible idea to enable large MTUs on traffic you don't intend to route, or better yet, will NOT route because of the absence of a L3 gateway (best practice there). Typical traffic would be stuff like FCoE, NFS, iSCSI, vMotion, etc - stuff that not only works on a strictly L2 basis but largely will ONLY work on this basis (i.e. cannot be routed). We get the benefits of performance, and oh hey - we also have some additional security by not allowing this sensitive traffic to route outbound.

Unfortunately it never stops there. I've now seen enough customers in the following configuration to comment on it: for some reason I keep seeing organizations enable jumbo frames everywhere, and I mean everywhere. Campus LANs, Data Center distribution, internet edge, etc. This is very bad, and mostly pointless. Why?

First off, the internet is _mostly_ configured to support an MTU of 1500 bytes, the default for ethernet. This is to prevent massive fragmentation mid-flow for customers passing through. As a result, ISPs deliver the same configuration for Ethernet-based handoffs to end customers.

[![fragment](/assets/2013/03/fragment.png)](/assets/2013/03/fragment.png)

> FYI, I took this from [http://wiki.wireshark.org/SampleCaptures#Crack_Traces](http://wiki.wireshark.org/SampleCaptures#Crack_Traces) - it's from a teardrop attack, which makes use of IP fragmentation.

The reasons I hear for configuring it this way is to improve performance for ALL traffic, not just the traffic that shouldn't be routed. It's clear that these folks have never heard of or don't care about fragmentation, but I should be clear on what this does and does not do. Many end user applications don't really benefit from jumbo frames, since messages are typically short and sweet. The traffic that does require it typically sends a large number of datagrams in addition to a large size. Don't forget - for those of you with older hardware - jumbo frames isn't even supported on 100Mbps or less.

You may have jumbo frames enabled everywhere, resulting in no fragmentation on your LAN, but you will have to "translate" to a standard size of 1500 bytes at your internet edge device, resulting in fragmentation at the edge, creating unnecessary overhead for your edge devices, and potentially severely pissing off your ISP.

Now - should you enable jumbo frames on a nonrouted segment? Sure, if your traffic will truly benefit from it. Datacenter deployments of the protocols listed above are very commonly deployed on L2 segments that do not route outbound, especially in data center contexts.

Interestingly enough, the post from [Greg Ferro](http://etherealmind.com/ethernet-jumbo-frames-full-duplex-9000-bytes/) illustrated that the reason 9000 is a common MTU size for jumbo frames is because the CRC field isn't long enough to guarantee detection of errors for frames longer than 9000 bytes. I also recommend a read of [this article](http://sd.wareonearth.com/~phil/jumbo.html), as it goes into a bit more detail on the math, as well as little tweaks on optimizing network performance.