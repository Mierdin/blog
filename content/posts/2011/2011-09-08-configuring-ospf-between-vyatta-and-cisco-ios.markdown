---
layout: post
title: Configuring OSPF Between Vyatta and Cisco IOS
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-09-08"
wordpress_id: 1100
slug: configuring-ospf-between-vyatta-and-cisco-ios
tags: ['cisco']
---


This is a guide to configuring OSPF between Cisco IOS and the open-source Vyatta router platform. I was able to do all of this on my desktop PC, by running Cisco IOS in GNS3 and Vyatta as a virtual machine. [I used the guide here](http://www.facebook.com/topic.php?uid=190010265716&topic=15852) to bridge both virtual routers together, so that communication could be established.

The Cisco side was pretty straightforward. I configured the FastEthernet interface and enabled OSPF on it:

    R1#(config)interface Fa0/0
    R1#(config-int)ip addr 172.16.0.1 255.255.255.0
    R1#(config-int)no shut
    R1#(config-int)exit
    R1#(config)router ospf 1
    R1#(config-router)router-id 1.1.1.1
    R1#(config-router)network 172.16.0.1 0.0.0.0 area 0

The Vyatta side took some doing, though there were more interfaces involved here, so that could be to blame. First, I set up all the interfaces with their respective IP addresses:

    vyatta@R2:~$ configure
    vyatta@R2# set interfaces ethernet eth0 address 172.16.0.2/24
    vyatta@R2# set interfaces ethernet eth1 address 192.168.0.1/24
    vyatta@R2# set interfaces ethernet eth2 address 192.168.1.1/24
    vyatta@R2# set interfaces ethernet eth3 address 192.168.2.1/24
    vyatta@R2# set interfaces ethernet eth4 address 192.168.3.1/24

Then, I enabled OSPF on the interfaces I configured:

    vyatta@R2# set protocols ospf area 0 network 172.16.0.0/24
    vyatta@R2# set protocols ospf area 10 network 192.168.0.0/24
    vyatta@R2# set protocols ospf area 10 network 192.168.1.0/24
    vyatta@R2# set protocols ospf area 10 network 192.168.2.0/24
    vyatta@R2# set protocols ospf area 10 network 192.168.3.0/24

I then set the router ID and configured the router to log adjacency changes.

    vyatta@R2# set protocols ospf parameters router-id 2.2.2.2
    vyatta@R2# set protocols ospf log-adjacency-changes

I want to mention that I created the four ethernet interfaces in the 192.168 networks so that I could demonstrate inter-area route summarization from the Vyatta router. To summarize these four networks in area 10 so that area 0 would only see one route, I entered the following:
   
    vyatta@R2# set protocols ospf area 10 range 192.168.0.0/22

After commiting the changes, I checked to verify that we had established a neighbor relationship with R1.
  
    vyatta@R2:~$ show ip ospf neighbor

    Neighbor ID Pri State           Dead Time Address
    1.1.1.1           1 Full/Backup       32.136s 172.16.0.1

According to that output, the Vyatta router had established a neighbor relationship with R1, and that R1 was acting as the backup designated router for the network, which means the Vyatta router was the DR proper.

Since we had a valid neighbor relationship, I wanted to see if my summarization configuration worked:

    R1#show ip route 192.168.0.0
    Routing entry for 192.168.0.0/22, supernet
      Known via "ospf 1", distance 110, metric 20, type inter area
      Last update from 172.16.0.2 on FastEthernet0/0, 00:07:29 ago
      Routing Descriptor Blocks:
      * 172.16.0.2, from 2.2.2.2, 00:07:29 ago, via FastEthernet0/0
         Route metric is 20, traffic share count is 1

The routing table lists it as a supernet, a.k.a. a summary route, it is an inter-area route, which is true because the networks are in area 10, and the correct mask is being used, encompassing all our subnets, but no more. Success!

The last thing I wanted to do is practice passing a default route from the Cisco router to the Vyatta router. I first created the static route, then instructed OSPF to originate default information from R1 to other routers, which passes the default static route along with normal route updates.

    R1(config)#ip route 0.0.0.0 0.0.0.0 1.1.1.1
    R1(config)#router ospf 1
    R1(config-router)#default-information originate

After reviewing the routing table on the Vyatta router, we can see that the 0.0.0.0 route has made it across the network, and that all traffic that matches this route should get sent to R1. Great success!

    vyatta@R2:~$ show ip route
    Codes: K - kernel route, C - connected, S - static, R - RIP,
    O - OSPF, I - ISIS, B - BGP, > - selected route

    O>* 0.0.0.0/0 [110/1] via 172.16.0.1, eth0, 00:00:12

    ...truncated...
