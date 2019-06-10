---
layout: post
title: SDN and Virtualization Utilizing IP over Avian Carrier Networks
author: Matt Oswalt
comments: true
categories: ['Humor']
date: "2013-04-01"
wordpress_id: 3351
slug: sdn-and-virtualization-utilizing-ip-over-avian-carrier-networks
tags: ['humor']
---


Network Virtualization has been a hot button topic for the last few years, particularly in the data center. With trends like SDN, cloud, and unicorns taking off, it's incredibly important to move towards technologies that improve scalability while preserving proper multi-tenancy.

You may be wondering that all this vendor-supplied, marketing-fueled magic and fairydust is too good to be true. You wouldn't be too far off - the fact is that none of the solutions provided thus far have addressed the implementation and operation of network virtualization in cases such as a remote datacenter where traditional connectivity like satellite and long-haul fiber is unavailable.

[RFC 1149](http://tools.ietf.org/html/rfc1149) was created to assist in addressing the immediate connectivity needs for remote data centers like this. By utilizing Avian Carrier networks, where the delay is high, the altitude is low, and the network topology is neither ring, or star (it most closely resembles point-to-point except that there may be stops along the way and wind is a factor) we can actually get decent throughput, due to the recent advances in flash storage technology and the ability to send datagrams in bursts, rather than on a 1:1 basis.  Reports of up to 9.3Gbit/s have been observed, albeit with a latency of 60 minutes. This capability opens up some interesting possibilities.

[![A Typical IPoAC Datagram](/assets/2013/03/Carrier_Pigeon_PSF.jpg)](/assets/2013/03/Carrier_Pigeon_PSF.jpg)

Due to a recent report from Gartner placing this technology in the magic quadrant, it was determined that it was prime time someone configured this link for direct L2 and ran inter-DC vMotions across it. This article will discuss the implications of operating a network to interconnect virtualized environments, as well as network virtualization itself.

## Layer 2 DCI

It's important to realize that technologies like STP exist for a reason, namely to prevent loops from occurring in L2 topologies, However, in IPoAC networks, Ethernet can take a few additional liberties. First, it should be known that the likelihood of a damaging L2 loop on a p2p IPoAC link is quite low, largely due to the fact that looping frames would never be received in a timely enough fashion to really cause a "storm". Over time, the carriers may replicate and cause additional datagrams to be placed on a "link" at a given time, but this process is quite slow and traffic shaping methods for situations like this are readily available. In addition, IPoAC topologies always use a concept defined outside of the initial 802.1D standard known as "dynamic BPDUfilter". This feature involves the potential for a BPDU to be digested during transmission, but due to the dynamic nature of this consumption, never occurs on a 1:1 basis.

When addressing the needs of a virtualized environment, a L2 DCI can be achieved fairly easily using IPoAC transport. Given the high-bandwidth nature of these links, it is certainly possible to transfer an entire virtual machine in a single IPoAC datagram. This of course will vary by the VM's RAM allocation/usage, and IPoAC fragmentation may occur as a result. Please see the section labeled "MTU and Fragmentation" for more information.

## SDN

It is possible, using Avian Mind Control technology that IPoAC networks can be programmatically altered to direct flows based on administrator-defined properties.

[![SDN for IPoAC](/assets/2013/03/Carrier_Pigeon_PSFmindcontrol.jpg)](/assets/2013/03/Carrier_Pigeon_PSFmindcontrol.jpg)

Cisco and Brocade are currently fighting over which mind control helmet actually works, and which one is complete bollocks.

## MTU and Fragmentation

The MTU of a typical IPoAC datagram is 256 milligrams, due to Carrier strength and size. Given that most modern SD cards weigh about 400 to 500 milligrams, MTU could be an issue. When utilizing VXLAN for separation of tenant virtual traffic and tracking mobile virtual machines, the encapsulated data portion of each datagram will be more and more valuable.

Pictured below is both an IPoAC datagram when jumbo frames have been enabled, as well as some fragmentation that has occurred as a result. The ability for fragmented IPoAC datagrams to provide reliable connectivity will vary, but generally gets more reliable with carrier age.

[![IPoAC Fragmentation](/assets/2013/03/0413pigeon00051.jpg)](/assets/2013/03/0413pigeon00051.jpg)

Operating Fibre Channel networks in topologies like this is possible, but only with the exclusive use of the acronym FCoIPoAC. The length of the acronym is directly proportional to the technologies' usefulness, which of course means that FCoIPoAC is far preferable to FCoTR, which means FCoE is archaic by comparison. Again, it may be recommended that FCoIPoAC traffic be fragmented to a smaller size when routed onto an IPoAC link to ensure that standards bodies like PETA are respected.

## Results

The results of this testing were very promising. The C-Level execs in charge of providing funding to the R&D departments that made this possible had this to say:

> Synergy.....low hanging fruit....cloud.....OPEX.....mission accomplished.

It's clear that the bright minds of this industry really can accomplish anything when the stakes are high enough.
