---
layout: post
title: Multi-Vendor OSPF Cost Calculations
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-04-22"
wordpress_id: 3577
slug: multi-vendor-ospf-cost-calculations
tags: ['cisco']
---


While on my current kick with virtual routing, I stumbled across an interesting concept regarding OSPF, and the flexibility that vendors have in determining the best path through an OSPF network.

The following topology is what I've been staring at for the last few days

[![screen1](/assets/2013/04/screen11.png)](/assets/2013/04/screen11.png)

Pretty simple, right? There's a single network (192.168.123.0/24) down inside each virtual host where the VMs are to sit. Each host has a router on it (one Cisco CSR 1000v and the other Vyatta Core 6.5), and both routers are OSPF neighbors with each other as well as with an upstream L3 switch.

Given this topology, and knowing that most nerd knobs have been left to their defaults, and the hardware involved is the same between the two paths, one would assume that the L3 switch would see two equal-cost paths to 192.168.123.0/24 and load-balance between the two paths.  However, upon looking at the routing table of the L3 switch, we see only one:
    
    CORE#show ip route ospf
    [output omitted]
    
    O     192.168.123.0/24 [110/2] via 192.168.5.102, 01:45:50, Vlan5
    CORE#

This is the path through the CSR 1000v, meaning that the path through the Vyatta router will only be used if this path were to go down - ideal if you want deterministic traffic flows but not if you want to load-balance between the two hosts. I verified that the Vyatta neighbor had properly formed an adjacency with the core switch - I shut down the CSR 1000v and the route through the Vyatta suddenly appeared, but I noticed the metric was higher:
    
    CORE#show ip route ospf
    [output omitted]
    
    O     192.168.123.0/24 [110/11] via 192.168.5.103, 00:00:15, Vlan5
    CORE#

It's common knowledge that while the computation of shortest path (Djikstra) is pretty complicated, the metric that OSPF uses to power this choice is relatively simple - cost. This is a simple 16-bit value that OSPF routers use in link-state advertisements to indicate the desirability of a given link to be used for forwarding traffic.

The [OSPFv2 RFC](http://tools.ietf.org/html/rfc2328#page-18) states:

    A cost is associated with the output side of each router
    interface.  This cost is configurable by the system
    administrator.  The lower the cost, the more likely the
    interface is to be used to forward data traffic

Pay attention to the wording - "output side of each router interface". This depends on which router's perspective we're taking - since we are viewing the routing table on our L3 switch, this means that the downstream interface on the switch is added to the cost calculation, as well as the downstream-facing interface in the 192.168.123.0/24 network on both virtual routers.

Typically, cost is thought to be derivative of link speed. Cisco and quite a few others use the concept of reference bandwidth to determine the cost of a given link. These are both virtual devices with the same "hardware", so why is the cost through the Vyatta router so much higher than the cost through the CSR 1000v?

This isn't EIGRP so we don't have a topology table, but the OSPF link-state database can give us the answers we need. Below is the link-state advertisement for the Vyatta router (pay attention to the cost attribute):
 
    CORE#show ip ospf data router
    
                OSPF Router with ID (192.168.100.1) (Process ID 1)
    
                    Router Link States (Area 0)
    
      LS age: 66
      Options: (No TOS-capability, No DC)
      LS Type: Router Links
      Link State ID: 192.168.5.103
      Advertising Router: 192.168.5.103
      LS Seq Number: 80000142
      Checksum: 0xFF2F
      Length: 48
      Number of Links: 2
    
        Link connected to: a Transit Network
         (Link ID) Designated Router address: 192.168.5.1
         (Link Data) Router Interface address: 192.168.5.103
          Number of MTID metrics: 0
           TOS 0 Metrics: 10
    
        Link connected to: a Transit Network
         (Link ID) Designated Router address: 192.168.123.2
         (Link Data) Router Interface address: 192.168.123.3
          Number of MTID metrics: 0
           TOS 0 Metrics: 10

A quick look at the OSPF-specific interface properties of the Vyatta router confirms that the cost being applied to both interfaces is 10:
    
    vyatta@vyatta:~$ show ip ospf interface
    
    [non-relevant output omitted]
    
    eth0 is up
      Router ID 192.168.5.103, Network Type BROADCAST, Cost: 10
    eth1 is up
      Router ID 192.168.5.103, Network Type BROADCAST, Cost: 10

We only care about the link listed last, since it is the link facing downstream, away from us (as we saw before this direction is used to calculate cost). So the cost calculation for both paths looks something like this:

[![screen2](/assets/2013/04/screen2.png)](/assets/2013/04/screen2.png)

For those used to Cisco defaults (and Juniper and a slew of others) when it comes to OSPF, this cost would seem to indicate a 10Mbps link, since on those platforms, the formula of Reference Bandwidth / Link Speed is used, and Reference Bandwidth is usually 100Mbps. Of course, this was not the case.

The current version of Vyatta core (6.5R1) does not even use a concept like reference bandwidth by default, though it can be configured to do so. (See the [VC6.5 configuration guide](http://www.vyatta.com/downloads/documentation/VC6.5/Vyatta-OSPF_6.5R1_v01.pdf))

    vyatta@vyatta# set protocols ospf auto-cost reference-bandwidth 100
    [edit]
    vyatta@vyatta# commit
    [ protocols ospf auto-cost reference-bandwidth 100 ]
    OSPF: Reference bandwidth is changed.
          Please ensure reference bandwidth is consistent across all routers
    
    [edit]
    vyatta@vyatta#

Interestingly enough, Vyatta still treats it's interfaces as 10Mbps interfaces, since the default reference bandwidth of 100 will still produce a cost of 10 on all interfaces.

Vyatta will simply designate a standard cost of 10 per interface, regardless of link speed. I swore this deviated from the standard in some way (thinking that a concept like reference bandwidth was part of the OSPF spec) so I referred back to [RFC 2328](http://tools.ietf.org/html/rfc2328) - sure enough, bandwidth is not a requirement for cost calculation. (Go ahead, do a search for the word "bandwidth"). Good idea, you bet. But not a requirement per the RFC.

For what it's worth, you can either statically set the cost on a per-interface basis, or for the small number of vendors that don't implement some kind of bandwidth mechanism by default, it looks like it can be turned on. I decided to statically set all interfaces to a cost of 1, and the second route appeared on my core switch right away.

## Conclusion

Be sure to go back to the fundamentals when researching technologies and protocols like this, like the IETF RFCs. You'd be surprised what you find, or in some cases, don't find. I have been studying and using OSPF for years and the fact that bandwidth wasn't a required factor in OSPF cost calculation just didn't occur to me until I ran into this.