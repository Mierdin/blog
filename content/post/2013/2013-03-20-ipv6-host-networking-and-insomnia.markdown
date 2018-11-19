---
layout: post
title: IPv6 Host Networking and Insomnia
author: Matt Oswalt
comments: true
categories: ['IPv6']
date: "2013-03-20"
wordpress_id: 3258
slug: ipv6-host-networking-and-insomnia
tags: ['asa']
---


I've been running IPv6 on my home network for a while. The solution in place has evolved over time, from terminating tunnels to a linux VM using gogo6 all the way to front-ending with a Cisco ISR using Hurricane Electric, the goal has always been the same - to practice what I preach. Running IPv6 at home and *REFUSING* to turn it off when problems arise is one of the best ways to learn the protocol.

So after one of the aforementioned evolutions (reconfigurations), I noticed that certain IPv6 web sites were not reachable, while others were. I did basic ping tests first:

    C:> ping ipv6.google.com
    
    Pinging ipv6.l.google.com [2607:f8b0:400c:c01::93] with 32 bytes of data:
    Reply from 2607:f8b0:400c:c01::93: time=62ms
    Reply from 2607:f8b0:400c:c01::93: time=60ms
    Reply from 2607:f8b0:400c:c01::93: time=60ms
    Reply from 2607:f8b0:400c:c01::93: time=60ms

Okay, so Google's IPv6-only site seems to work, let's try another one of my favorites:
    
    C:> ping www.kame.net
    
    Pinging orange.kame.net [2001:200:dff:fff1:216:3eff:feb1:44d7] with 32 bytes of data:
    Destination host unreachable.
    Destination host unreachable.
    Destination host unreachable.
    Destination host unreachable.
    
    Ping statistics for 2001:200:dff:fff1:216:3eff:feb1:44d7:
        Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),

Seems to fail, though I get a "destination host unreachable" on those attempts. I went ahead and tested web connectivity to both, as well as quite a few other sites. There were two sites that worked out of around 7 that I tested. Very strange. In addition, the "destination host unreachable" message intrigued me. So I decided to open a packet capture as I often do, to give me a little better view of the problem:

[![ipv6ra3](assets/2013/03/ipv6ra3.png)](assets/2013/03/ipv6ra3.png)

My host (Windows 7) was sending a large number of neighbor solicitations, all of which were asking for the link-layer (MAC) address of the IPv6 address I was trying to reach. [As I covered in a previous post](https://keepingitclassless.net/2011/10/neighbor-solicitation-ipv6s-replacement-for-arp/), IPv6 Neighbor Solicitation serves the role that ARP does in IPv4, which allows devices on the same L2 segment to resolve L3 addresses to L2 addresses. However, the address I was trying to reach was not only not on the same L2 segment, but likely somewhere else in the world entirely. So why wasn't my PC trying to send a Neighbor Solicitation to my router so the packet can get sent through the internet, instead of trying in vain to go directly?

Thus spawned a period of deep research, plenty of googling, and reaching out to a few peers. Over the next 48 hours I went over this in my mind, identifying little problems here and there, and all the time trying to learn more and more about how hosts handle certain quirky IPv6 scenarios.

First, the short term solution. I had a Cisco ASA 5505 serving as the gateway for this network, and I had configured both the inside and the outside interfaces to support IPv6 in a dual-stack fashion. The IPv6 tunnel from Hurricane Electric was terminated outside this firewall for this purpose. As part of my testing, I tried pinging all the addresses that were failing in the test on my end-host connected behind the firewall, and from the ASA, every single ping worked - and actually worked pretty well to boot! This only added to my confusion. Then I looked at the configuration for the inside interfaces of the ASA:

    MIERDIN-ASA# show run int vlan 10
    interface Vlan10
     nameif inside
     security-level 100
     ip address 10.12.0.1 255.255.255.0
     ipv6 address 2001:470:c26c:10::/64 eui-64
     ipv6 address fe80::1 link-local
     ipv6 enable
     ipv6 nd ra-interval 10
     ipv6 nd ra-lifetime 300
     ipv6 nd prefix 2000::/6

Someone (me) made a fat finger mistake, and though I typed out the full prefix in the "ipv6 nd prefix" command, I missed the "4" in "/64" at the end, so it truncated the entire address except for the first 6 bits. Ouch.

So I got out my handy wireshark again, since I didn't catch this the first time, but this time I was out to see the router advertisements that were being sent out by the ASA:

[![ipv6ra1](assets/2013/03/ipv6ra1.png)](assets/2013/03/ipv6ra1.png)

Interestingly enough, there were TWO prefixes being advertised via the ASA. The first one was the fat-fingered prefix I manually typed in, but the full /64 prefix I intended to type out. With a little research I discovered that the ASA will by default advertise the prefix(es) assigned to the interface in addition to the prefix (if any) explicitly stated in the "ipv6 nd prefix" command, as long as there are other RA commands stated, such as "ipv6 nd ra-interval" or "ipv6 nd ra-lifetime".

So...easy fix, right? Right - all it would take is to remove the bogus prefix command, and probably just leave it off considering the ASA will advertise the correct /64 prefix by just having the address configured on the link. However, this got me extremely interested in how Windows arrived at this decision, since it seemed to not be as straightforward as IPv4. So there are two things that I wanted to check out:

  1. When there was a longer prefix included in the Router Advertisement, why did Windows seem to adopt the /6 prefix LENGTH when making decisions on where to forward traffic?
	
  2. Despite the fact that 2000::/6 was included in the Router Advertisement, why did only the /64 get used to autoconfigure an address? (I knew that SLAAC was only able to use /64 prefixes but I needed to see the proof specific to this situation)

## On-Link Determination

We know that a logical AND operation is used to determine whether or not an address is on a given subnet. In IPv4, this is done using the subnet mask that is associated with every IP address. Before classless routing, this wasn't needed because the network portion of the address was assumed, given the class the address was in. Now, it's done by comparing the 1's in the IP address with the 1's in the subnet mask using an AND operation. If the bits match for each address, then the address is said to be on the same subnet, and an ARP (or Neighbor Solicitation) is sent out asking for that device's MAC address.

In IPv6, such an address is said to be "on-link". Router advertisements actually have a flag called the "L" flag that indicates when a given prefix is marked as "on-link". Most prefixes used for SLAAC would be viewed as such, which probably indicates that the router that can get packets **off** that segment is also present.

Looking at the IP address configuration and the IPv6 routing table on my host, it's clear that the desired address has been autoconfigured from only one of the prefixes from the router advertisement, but the routing table seems to contain routes from **both** prefixes.

    (Some output omitted)
    
    C:> ipconfig
    
    Windows IP Configuration
    
    Ethernet adapter Local Area Connection:
    
       IPv6 Address. . . . . . . . . . . : 2001:470:c26c:10:52e5:49ff:feb5:e0bc
       Link-local IPv6 Address . . . . . : fe80::52e5:49ff:feb5:e0bc%11
       Default Gateway . . . . . . . . . : fe80::1%11
    
    C:> netsh int ipv6 show route
    
    Publish  Type      Met  Prefix                    Idx  Gateway/Interface Name
    -------  --------  ---  ------------------------  ---  ------------------------
    No       Manual    256  ::/0                       11  fe80::1
    No       Manual    256  ::1/128                     1  Loopback Pseudo-Interface 1
    No       Manual    8    2000::/6                   11  Local Area Connection
    No       Manual    8    2001:470:c26c:10::/64      11  Local Area Connection
    No       Manual    256  2001:470:c26c:10:52e5:49ff:feb5:e0bc/128   11  Local Area Connection

The route to 2000::/6 immediately grabbed my eye - it certainly looked like a potential smoking gun for my issue. So I did some research on this. I came across [this article](http://technet.microsoft.com/en-us/library/dd379520(v=ws.10).aspx) on TechNet that talks about the route selection process. First, like any routing table, all routes must be checked to see if they match the destination address. After this, the article states:

> [...] The route that has the largest prefix length (the route that matched the most high-order bits with the destination IPv6 address) is chosen. The longest matching route is the most specific route to the destination. If multiple entries with the longest match are found (multiple routes to the same network prefix, for example), the router uses the lowest metric to identify the best route. If multiple entries exist that are the longest match and the lowest metric, IPv6 can choose which routing table entry to use.

This ultimately led me to [a FANTASTIC post](http://blog.ioshints.info/2012/11/ipv6-on-link-determination-what-is-it.html) by Ivan Pepelnjak, which in turn led me to [RFC 5942](http://tools.ietf.org/html/rfc5942), which I agree with Ivan is a MUST read for anyone seriously trying to learn IPv6. This RFC is one great example of the need for a mindset shift when thinking of this new protocol. There, I learned about two terms I had not seen much before: On-Link Determination and Prefix List. These constructs are extremely important in considering how hosts do IPv6, **especially** in a multi-prefix environment.

With all of these resources, I looked back at the routing table and saw that the 2000::/6 prefix was the only one that actually matched the destination address of the pings that were failing, other than the default route. Because of the prefix's presence on the link through the RAs from the firewall, this prefix was viewed as "on-link", or directly connected to the physical interface of the host. Therefore, the host decided (correctly) that no router is needed, it simply needed to send neighbor solicitations directly for that host's address and the two will communicate. Though this is actually valid behavior, it of course will not work because the host in question was miles away through many physically separated networks.

## The Correlation Between RA Prefixes and SLAAC

So, all prefixes contained within the advertisements are added to the prefix list of the host, and the method by which the next-hop determination is performed is now known, but I was still confused as to the reason why the /64 prefix was selected (albeit this was desired behavior) for SLAAC to autoconfigure the address. I even messed around a little bit, and tweaked my ASA firewall configuration so that ONLY the 2000::/6 prefix was being advertised (I assigned a 2000::1/6 to the interface). In that scenario, NO address was autoconfigured, just the link-local address.

When acquiring addresses through SLAAC, a host will only use prefixes with a prefix length of 64 bits. If no prefix of such a length is seen in a router advertisement, then no address is autoconfigured, even if there are non-64 prefixes contained in the advertisement.

I left privacy addressing turned on on another Windows host, in the interest of seeing if having EUI-64 (see [awesome explanation](http://packetlife.net/blog/2008/aug/4/eui-64-ipv6/) by Jeremy Stretch) was the root cause behind this behavior, but it looks like any non 64-bit prefixes are rejected out of principle, regardless of whether or not privacy addressing is turned on. This is because SLAAC just simply does not work with prefixes other than /64. You can use router advertisements to advertise a prefix into a segment, but prefixes other than 64 will not be used for SLAAC. [RFC 4291](http://tools.ietf.org/html/rfc4291#section-2.5.1) (Section 2.5.1) specifically states that SLAAC requires the use of /64 blocks in order to work properly.

> **Many thanks to Tom Hollingsworth ([@networkingnerd](https://twitter.com/networkingnerd)) and Jon Still ([@xanthein](https://twitter.com/xanthein)) for lending me additional pairs of eyes while I obsessed over this thing. **
