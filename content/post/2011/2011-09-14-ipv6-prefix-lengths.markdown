---
layout: post
title: IPv6 Prefix Lengths
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-09-14"
wordpress_id: 1228
slug: ipv6-prefix-lengths
tags: ['ipv6']
---


For years, discussions regarding the appropriate prefix length for IPv6 subnets have been waged, with high profile organizations and bloggers chipping in their $0.02 for all kinds of opinions.

IPv6 enthusiasts have long-adhered to their "A /64 for every subnet" approach, and they give many good reasons for this approach. There are others who recognize the sheer amount of waste from this method, and suggest much more restrictive prefixes, such as /126 for a point-to-point link, as that prefix allocates 2 addresses, identical to the /30 mask in the IPv4 world.

##  The Kool-Aid Drinkers

The proponents of "a /64 for every subnet" have a few valid points. A big problem with large subnet sizes with IPv4 was that excessive broadcasts were free to storm around the network. In IPv4, we use ARP to resolve MAC addresses from known IP addresses - this is done via layer 2 broadcasts. In IPv6, we use Neighbor Discovery, and there is no such thing as broadcasts, only multicasts.

According to [AboutIPv6.net](http://www.aboutipv6.net/2011/02/ipv6-addressing-and-subnetting/):

> IPv6 addresses are 128 bits wide, but the **last 64 bits are always host bits**. Whilst it is possible to use a prefix longer than /64 (i.e. fewer host bits), this is **strongly discouraged **as various features of IPv6 depend on this convention.

By "various features", I'm imagining they mean something like Stateless Address Autoconfiguration (SLAAC), as that feature requires a /64 prefix.

Another thing to consider is that many host OS's probably expect a /64 allocation. Linux is one example that implements the EUI-64 format, which uses the 48 bit MAC address to compose a 64-bit identifier that's specific to that specific host.

## The Skeptics

Most skeptics are not ignoring the fact that sometimes you need a /64 allocation, for many of the reasons above, but are challenging the "A /64 for every subnet" mantra.

The biggest "What, are you crazy?" point is with the idea of assigning a /64 to a point-to-point link. With this, the problems encountered by deviating from a /64 tend to be irrelevant; there's obviously no need for SLAAC in that type of environment, and layer 3 forwarding devices typically have no problem with prefixes longer than 64 bits.

[Ivan over at IOSHints](http://blog.ioshints.info/2011/05/ipv6-neighbor-discovery-exhaustion.html) keenly points out that IPv6 is indeed classless, and there's no reason to believe such an address allocation practice would produce problems. The general rule of thumb is to stick with a /64 in workstation subnets, but anywhere else, it's fair game.

Also, smaller subnet sizes helps defend against [NDP Table Exhaustion attacks.](http://inconcepts.biz/~jsw/IPv6_NDP_Exhaustion.pdf)

## Matt's Mind

If I had to pick, I'd say I too question the mentality of assigning a 64 bit prefix everywhere, but only because I've labbed out a variety of prefix lengths with equipment from several vendors, and have observed no problems. As with everything in IPv6, and for that matter, new technology in general, it's up to the engineer to be vigilant in the design, and not take for granted something they fail to validate for themselves. If you've been told that you need to allocate every subnet 64 bits worth of address space, figure out if that's really what's best for your environment.
