---
layout: post
title: Vyatta OSPF Designated Router Concepts
author: Matt Oswalt
comments: true
categories: ['Virtual', 'Networking']
date: "2011-09-16"
wordpress_id: 1300
slug: vyatta-ospf-designated-router-concepts
tags: ['designated', 'router']
---


I was inspired by a (relatively) recent [post by Jeremy Stretch at Packetlife.net](http://packetlife.net/blog/2011/jun/2/ospf-designated-router-election/) that explained OSPF designated router configuration in Cisco IOS. I'd like to go into a bit more detail regarding the need for a designated router, and explore the same configuration steps on the Vyatta Core platform. [I've already shown how easy it is to integrate a Cisco router with a Vyatta router using OSPF](https://keepingitclassless.net/networking/routing-and-switching/configuring-ospf-between-vyatta-and-cisco-ios/), so you can use a mix of Cisco and Vyatta gear if you wish.

To understand the purpose of a Designated Router in OSPF, you need to know how OSPF distributes routing information around the network. In order to establish neighbor relationships with other routers, OSPF will send hello messages to the multicast address 224.0.0.5. Once neighbor relationships have been established, routing information must be distributed via Link State Advertisements, or LSAs. In a shared-media environment, this can be problematic.

Observe the following diagram:

[![diagram-ospf-dr](assets/2011/09/diagram4.png)](assets/2011/09/diagram4.png)

In this network, all five routers are connected to the same layer 2 segment via a central switch. If one of these routers were to experience an outage of some kind, perhaps a link to a network outside of this diagram were to go down, it would immediately send an update to all other OSPF routers, notifying them of the change. Each router would then, in turn, send the same update right back out to notify all other OSPF routers, and so on and so forth. This is a problem because of the sudden flood in network activity and therefore will cause strain on the routers' CPU, but also because it impacts convergence time.

Instead of going with that model, OSPF elects one of the routers on the shared segment the Designated Router (DR), and another the Backup Designated Router (BDR). Whenever a change occurs, an OSPF router will send an update to the multicast address 224.0.0.6, which sends the update to the DR and BDR. The DR will, in turn distribute the update to the non-DR routers. The BDR is just a backup, it acts as a non-DR router unless the DR goes offline. This model allows for efficiency of routing updates and prevents unnecessary flooding.

Stretch's post focused on the Cisco implementation, which is pretty straightforward, and since I've been tinkering with Vyatta lately, I wanted to publish some well-formed info on how this process works.

## Default Configuration

First, let's take a look at how the election process works with a basic OSPF configuration. We can identify pretty quickly how the OSPF network is working by showing OSPF status on the eth0 interface of R2:

    vyatta@R1:~$ show ip ospf interface eth0
    eth0 is up
      ifindex 2, MTU 1500 bytes, BW 0 Kbit &lt;UP,BROADCAST,RUNNING,MULTICAST&gt;
      Internet Address 10.1.1.1/24, Broadcast 10.1.1.255, Area 0.0.0.0
      MTU mismatch detection:enabled
      Router ID 0.0.0.1, Network Type BROADCAST, Cost: 10
      Transmit Delay is 1 sec, State DROther, Priority 1
      Designated Router (ID) 0.0.0.5, Interface Address 10.1.1.5
      Backup Designated Router (ID) 0.0.0.4, Interface Address 10.1.1.4
      Multicast group memberships: OSPFAllRouters
      Timer intervals configured, Hello 10s, Dead 40s, Wait 40s, Retransmit 5
        Hello due in 0.257s
      Neighbor Count is 4, Adjacent neighbor count is 2
    vyatta@R1:~$

As you can see, R1 has detected the DR is R5, shown not only by the router-id that I configured (0.0.0.5) but also by the detected interface IP address 10.1.1.5. If you look right below that, you'll see that R4 has been elected the BDR. Since R1 is neither the DR or BDR, it is a member of the multicast group "OSPFAllRouters". If it was a DR or BDR, it would also belong to the group "OSPFDesignatedRouters".

Viewing the OSPF neighbors on a router is also a valid way to check this configuration:

    vyatta@R1:~$ show ip ospf neighbor

    Neighbor ID  Pri   State             Dead Time Address         Interface
    0.0.0.2      1     2-Way/DROther     37.485s   10.1.1.2        eth0:10.1.1.1
    0.0.0.3      1     2-Way/DROther     33.953s   10.1.1.3        eth0:10.1.1.1
    0.0.0.4      1     Full/Backup       33.871s   10.1.1.4        eth0:10.1.1.1
    0.0.0.5      1     Full/DR           30.955s   10.1.1.5        eth0:10.1.1.1

This output verifies our findings, and lists all four OSPF neighbors adjacent to R1. Note specifically the "State" column; the DR and BDR routers, R5 and R4 respectively, are in the "full" state, indicating complete neighbor relationships. However, R3 and R2 are listed as "2-Way/DROther", which indicates that the neighbor relationships are not actually complete. This means updates are only shared with the DR and BDR.

Note also the column "Pri". This stands for Priority, and it is a key factor in the DR/BDR election process. Since they're all set to a priority of 1, the Router ID is used to break the tie, and the highest Router ID is elected the DR, and the second highest the BDR.

## Changing the Priority

Let's say this is not our desired outcome. Make up whatever reason you want, but my made-up reason is that R1 and R2 are far more reliable routers than the others - maybe they're newer equipment. As a result, we'd like these routers to be elected the DR and BDR. This requires us to change the priority. As with the Router ID, the higher the priority, the more likely a router is to be elected the DR. We're going to set the priority of R1 to 200:

    vyatta@R1# set interfaces ethernet eth0 ip ospf priority 200

and R2 to 100:

    vyatta@R2# set interfaces ethernet eth0 ip ospf priority 100

Now - it's important to remember that OSPF DR/BDR elections can't just change, once an election takes place, the configuration doesn't change unless the OSPF process is restarted. In Cisco IOS, this is a simple command: "clear ip ospf process". Unfortunately there's no similar option with Vyatta yet. There's an outstanding bug ticket opened to add this functionality [located here.](https://bugzilla.vyatta.com/show_bug.cgi?id=2560) (Go to that page and upvote so that it can get implemented.)

In the meantime, other methods of disturbing the neighbor relationships can be used, such as cycling the interfaces, this is up to you.

    vyatta@R1:~$ show ip ospf interface eth0
    eth0 is up
      ifindex 2, MTU 1500 bytes, BW 0 Kbit <UP,BROADCAST,RUNNING,MULTICAST>
      Internet Address 10.1.1.1/24, Broadcast 10.1.1.255, Area 0.0.0.0
      MTU mismatch detection:enabled
      Router ID 0.0.0.1, Network Type BROADCAST, Cost: 10
      Transmit Delay is 1 sec, State DR, Priority 200
      Designated Router (ID) 0.0.0.1, Interface Address 10.1.1.1
      Backup Designated Router (ID) 0.0.0.2, Interface Address 10.1.1.2
      Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
      Timer intervals configured, Hello 10s, Dead 40s, Wait 40s, Retransmit 5
        Hello due in 7.581s
      Neighbor Count is 4, Adjacent neighbor count is 4
    vyatta@R1:~$

As you can see, our changes have taken effect - R1 has become the DR with the priority of 200. It also shows that R2 has been elected the BDR.
