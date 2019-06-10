---
layout: post
title: IGP Metric Tweaks - Direction is Important
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-07-29"
wordpress_id: 4191
slug: igp-metric-tweaks-direction-is-important
tags: ['eigrp']
---


A while back I was responsible for setting up a group of switches and routers to serve as the internet distribution for a hospital, mainly the function of designing the IGP of choice to work given the hospital's requirements and coordinating with the teardown of the old gear. The idea was to configure EIGRP so that one next-hop was preferred over another. We know this is possible through tweaking the various metrics for a given IGP, but in the process, I was reminded of something that's quite important to think about when doing so.

The metric for EIGRP by default is most largely influenced by tweaking interface bandwidth or delay. Since the "bandwidth" command can have a much larger impact than tweaking the EIGRP metric if you're not careful, the best practice is to use delay tweaks to influence routing decisions.

The below topology is pretty similar to what I was working with at the time:

[![screen1](/assets/2013/07/screen1.png)](/assets/2013/07/screen1.png)

Let's say that R1 is our network core, and we have redundant routers to reach R4. I wanted all traffic destined for the 172.16.1.0/24 network (loopback on R4 for our purposes) to go through R2.

EIGRP is configured in a fairly standard way here, with no routers configured as stub, the K-values for all routers are left at their defaults, and because the default variance is 1, R1 will install both equal-cost paths to R4's loopback network into it's routing table and load-balance between them. Auto-summarization has been disabled.

> Well, with CEF it's more [flow-based load-balancing](https://keepingitclassless.net/2013/04/igp-route-multipathing/) so it ends up only using one path, but you get the point.

With this standard configuration in mind, the routing table on R1 is as we'd expect:
    
    R1#show ip route eigrp
         172.16.0.0/24 is subnetted, 1 subnets
    D       172.16.1.0 [90/158720] via 10.1.3.3, 00:00:14, FastEthernet1/0
                       [90/158720] via 10.1.1.2, 00:00:14, FastEthernet0/0

Two equal-cost paths to the destination network. So without thinking, one might expect that you can simply change the delay on the next-hop interface. After all, this is where the EIGRP advertisement for that network originates from.
    
    R3#show int Fa0/0 | i DLY
      MTU 1500 bytes, BW 100000 Kbit/sec, DLY 100 usec, 
    
    R3#conf t
    R3(config)#int Fa0/0
    R3(config-if)#delay 11
    R3(config-if)#end
    
    R3#show int Fa0/0 | i DLY
      MTU 1500 bytes, BW 100000 Kbit/sec, DLY 110 usec,

After waiting for a while, you may wonder why the routing table on R1 has not changed, even though you've directly affected the delay on a path that is being advertised. This is because the interface on which you tweak the metrics is very important.

When an EIGRP router receives an update from a neighbor, it looks at it's K values (which must match the neighbor's in order for the neighbor relationship to form in the first place) and calculates the Reported Distance for that route based on which K values are set to 1. Assuming the defaults, the bandwidth remains the same unless the **receiving** interface bandwidth is less than what's contained in the update. The delay for the receiving interface is always added, because in EIGRP, delay is cumulative.

The key here is that the route for the 172.16.1.0/24 network is being **received** on interface FastEthernet 1/0, not FastEthernet 0/0. So, making a delay change on the interface facing away from the advertised route will do nothing. Making the same delay change on Fa1/0 on R3 instead of Fa0/0 would have accomplished the desired result.

> By the way, EIGRP always includes all metric values in each EIGRP update. It is up to the K values on a router whether or not certain ones are used.

OSPF works much the same way. With a standard configuration, all networks advertised, no multi-area configuration, the network shows up with two redundant next-hops in R1's routing table:

    R1#show ip route ospf
         172.16.0.0/16 is variably subnetted, 2 subnets, 2 masks
    O       172.16.1.1/32 [110/3] via 10.1.3.3, 00:01:12, FastEthernet1/0
                          [110/3] via 10.1.1.2, 00:01:12, FastEthernet0/0

The appropriate place to make a metric tweak to influence the routing behavior for this network would be on Fa1/0 here as well, because the "cost" property is considered on the interfaces that are pointing towards the route in question. We explored this in a [previous post](https://keepingitclassless.net/2013/04/multi-vendor-ospf-cost-calculations/), specifically referring back to the OSPF standard, [RFC2328](http://tools.ietf.org/html/rfc2328#page-18):

    A cost is associated with the output side of each router
    interface.  This cost is configurable by the system
    administrator.  The lower the cost, the more likely the
    interface is to be used to forward data traffic

IGP metric tweaking - direction is important!
