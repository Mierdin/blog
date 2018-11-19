---
layout: post
title: Outgoing Interface Determination
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-05-27"
wordpress_id: 3859
slug: outgoing-interface-determination
tags: ['bgp']
---


I received a [comment](https://keepingitclassless.net/2011/07/the-anatomy-of-show-ip-route/#comment-909366194) on an old post regarding the identification of outgoing interface for learned routes through BGP. In fact, it's not the first time I've had a discussion in the comment section regarding the interaction between the control plane and the forwarding plane.

So, let's work backwards from the point where our packet leaves *some* interface on a router, which would be considered purely an act of the forwarding plane. In order to get to that point, we need to populate the RIB with some entries.

[![bgp](assets/2013/05/bgp.png)](assets/2013/05/bgp.png)

I established an eBGP neighbor relationship and advertised the 123.123.123.0/24 network to R2:
    
    R2#show ip bgp
    BGP table version is 2, local router ID is 10.1.1.1
    Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
                  r RIB-failure, S Stale
    Origin codes: i - IGP, e - EGP, ? - incomplete
    
       Network          Next Hop            Metric LocPrf Weight Path
    *> 123.123.123.0/24 10.1.1.2                 0             0 321 i
    
    R2#show ip route 123.123.123.0
    Routing entry for 123.123.123.0/24
      Known via "bgp 123", distance 20, metric 0
      Tag 321, type external
      Last update from 10.1.1.2 00:00:14 ago
      Routing Descriptor Blocks:
      * 10.1.1.2, from 10.1.1.2, 00:00:14 ago
          Route metric is 0, traffic share count is 1
          AS Hops 1
          Route tag 321

Ultimately, the role of a routing protocol, or the RIB, is to maintain topology information, to allow each router to make decisions about which path is best. That sentence is essentially the loose definition of the control plane. Routing protocols simply help the routers exchange this topology information.

Since the routing protocol doesn't directly control the outgoing interface for a given router, the decision process is simply the identification of the best route, and the next-hop address is produced as a result of that selection. The next-hop address for a given route is usually in the same subnet as one of the router's interfaces.**

> In the case of BGP routes, it is possible that the next-hop address is not a locally significant address, if an eBGP neighbor is not using the "next-hop-self" command. In this case, another routing method like an IGP would be used to get packets to where they need to go. This post will analyse the case where a directly connected next-hop address has been provided.

Once the next-hop address is known, then the forwarding plane takes over. In the case of Cisco routers, the FIB is powered by CEF, and is responsible for matching a particular flow with a next-hop adjacency to be forwarded to.
    
    R2#show ip cef 123.123.123.0
    123.123.123.0/24, version 10, epoch 0, cached adjacency 10.1.1.2
    0 packets, 0 bytes
      via 10.1.1.2, 0 dependencies, recursive
        next hop 10.1.1.2, FastEthernet0/0 via 10.1.1.2/32
        valid cached adjacency

With an entry in the FIB, we can see that the outgoing interface for this particular route (learned through BGP as we saw before) is Fa0/0. All packets destined for this subnet will be forwarded out this interface, until a reconvergence of the control plane dictates otherwise.
