---
layout: post
title: EIGRP Feasible Successors
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-07-30"
wordpress_id: 649
slug: eigrp-feasible-successors
tags: ['cisco']
---


Link state routing protocols maintain topology tables to determine the best candidate to place in the routing table. EIGRP is no different - it uses this topology table to build a vision of the network from the perspective of each participating router. This topology table is reviewed by the routing algorithm (in the case of EIGRP, it is DUAL) and decisions are made regarding what gets placed into the routing table. Since EIGRP uses bandwidth and delay as metrics in this decision making process, they are used to decide which link out of several redundant connections to use to get to a remote subnet.

A big problem with this type of decision making process is that it needs to be made every time the topology changes.

EIGRP maintains redundant routes in memory so that if one fails, reverting to an backup route can occur instantaneously.  A feasible successor is a backup route that can be used in the event of a topology change without having to recalculate routes. The feasible successor can be used instantly, which means convergence time is instantaneous. This does not mean that a link that is not a successor or a feasible successor cannot be used to reach a remote subnet; if the successor and feasible successor are unavailable, it can still be used - however, DUAL must again perform calculations to find the best route.

The topology we'll work with here is included below:

[![](assets/2011/07/eigrp_fs_topology-1024x531.png)](assets/2011/07/eigrp_fs_topology.png)

We'll be working from the perspective of R0. The idea is to get to the remote subnet attached to R4,  172.16.0.0/24. This is done by selecting one of three possible next-hop routers, R1, R2, or R3. I have adjusted the bandwidth of the links shown by using the "bandwidth" command on all routers. No delay configurations have been made.

The link from R0 to its three next-hop routers are all at T1 speed, 1.544 Mbit/s. However, the links from each of those routers to R4 each have varying bandwidth settings configured with the "bandwidth" command in order to impact metric calculations.

Since EIGRP uses bandwidth as a factor to influence metric, the link between R1 and R4 will be given the lowest metric, and therefore will be preferred. Observe the following output on R0:
    
    R0#show ip eigrp topology
    IP-EIGRP Topology Table for AS 121
    
    (some output has been omitted)
    
    P 172.16.0.0/24, 1 successors, FD is 2684416
             via 1.1.1.10 (2684416/2172416), Serial0/2
             via 1.1.1.6 (3159808/2647808), Serial0/1

The Feasible Distance (FD) of the route from R0 to R1, which is a representation of the route's metric, is 2684416. This is the lowest of all the links, so it is selected to be placed in the routing table. This route is called the "successor" route.  However, the topology table shows another route through R2. This demonstrates the concept of a "feasible successor", or FS.  The parentheses after the next-hop address shows two things. First, the FD is shown. The next value is the reported distance (RD). This value represents the FD of the same route, but from the perspective of that next-hop router. The next-hop router communicates this value to R0 so that it can select a FS for the route.

The FD for the successor route is 264416.  If another route's RD is less than the successor's FD, it becomes the feasible successor. In layman's terms, this route, although slower, is fast enough to be used as a "good enough" backup. The route through R2 has a RD of 2647808, and since this is less than the FD for the successor route, this becomes the feasible successor.

When our network is in normal operation, only one route can be placed in the routing table. Right now, the successor route is in the routing table:
    
    R0#show ip route 172.16.0.0
    Routing entry for 172.16.0.0/24, 1 known subnets
      Redistributing via eigrp 121
    D     172.16.0.0 [90/2684416] via 1.1.1.10, 01:42:11, Serial0/2

If we were to administratively shut the link to R1, we would see the route to R2 immediately take it's place:
    
    R0#show ip route 172.16.0.0
    Routing entry for 172.16.0.0/24, 1 known subnets
      Redistributing via eigrp 121
    D     172.16.0.0 [90/3159808] via 1.1.1.6, 01:48:13, Serial0/1

Doing this allows communication to travel across the network uninterrupted, because the router kept the route to R2 ready and waiting in case the successor route was dropped. I performed a ping from the LAN attached to R0 to a workstation on the 172.16.0.2 subnet to ensure that no packets were dropped. I shut down the link to R1 right after I started the ping:
    
    PC>ping 172.16.0.2
    
    Reply from 172.16.0.2: bytes=32 time=187ms TTL=125
    Reply from 172.16.0.2: bytes=32 time=156ms TTL=125
    Reply from 172.16.0.2: bytes=32 time=172ms TTL=125
    Reply from 172.16.0.2: bytes=32 time=160ms TTL=125

As you can see, no packets were dropped. The link to R2 is now the successor route. However, there is no feasible successor. We have a redundant connection through R3, but the RD for that route is too high to be used as a feasible successor. If we shut down the connection to R2, EIGRP must recalculate a new route before updating the routing table:
    
    PC>ping 172.16.0.2
    
    Reply from 172.16.0.2: bytes=32 time=172ms TTL=125
    Request timed out.
    Request timed out.
    Reply from 172.16.0.2: bytes=32 time=185ms TTL=125

Dropping the connection to R2 results in dropped packets because there was no Feasible Successor for this route.
