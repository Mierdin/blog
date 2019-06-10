---
layout: post
title: OSPF Won't Redistribute My Static Routes!
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-09-07"
wordpress_id: 1030
slug: ospf-wont-redistribute-my-static-routes
tags: ['cisco']
---


I was working on some CCNP ROUTE labs, and I was attempting to rebuild a basic OSPF lab from memory. The lab included practice with inter-area route summarization, and static route redistribution. I ran across a problem that seems to be plaguing others, at least according to google, but my searches didn't yield a solution to my specific problem, which was that the static routes I had created weren't being redistributed by OSPF.

I didn't catch this the first time I worked on it because I wasn't working from memory, but this time I let my habits get the best of me. I was working with a topology larger than the one shown below, but the following diagram will suffice for our purposes:

![](/assets/2011/09/topology.png)

The topology shown above is a collection of three Cisco 2691's, all of which were in Area 0. R2 and R3 were serving as ABRs (Area Boundary Router) for connections to Area 20 and 30 respectively, and R1 simulated an ASBR (Autonomous System Boundary Router). This would represent a router at the edge of a corporate network, or at least the edge of the portion powered by OSPF. Typically this router will have static routes created, such as an "all-zero's" static route that takes all traffic that doesn't match a more specific route and routes it to the adjacent Autonomous System, such as the internet, for example. These static routes will need to get redistributed into the OSPF domain so that other routers, both in the same area and in others, are aware of the routes.

R1 contained four static routes to the networks shown above. The idea was that this router would have some sort of physical connection to these networks, so I created four loopback interfaces to simulate them:

    R1#show ip int brief
    Interface                  IP-Address      OK? Method Status
    FastEthernet0/0            172.30.0.1      YES NVRAM  up
    Loopback1                  172.16.0.1      YES manual up
    Loopback2                  172.16.1.1      YES manual up
    Loopback3                  172.16.2.1      YES manual up
    Loopback4                  172.16.3.1      YES manual up

Then, after creating and verifying the four static routes for these networks, I enabled OSPF static route redistribution:

    R1(config)#ip route 172.16.0.0 255.255.255.0 Loopback1
    R1(config)#ip route 172.16.1.0 255.255.255.0 Loopback2
    R1(config)#ip route 172.16.2.0 255.255.255.0 Loopback3
    R1(config)#ip route 172.16.3.0 255.255.255.0 Loopback4
    R1(config)#router ospf 1
    R1(config-router)#redistribute static subnets

So, right about then seemed the right time to see if my routes had made it to R2. Upon review of the routing table, they had not. After a few more seconds I realized something was wrong.

At this point is where several hours of hair-pulling occurred, mixed in with walks in and out of the apartment trying to take a break and get a new perspective on the problem, all to no avail. I finally had to go to bed, and the solution didn't present itself until the following day.

I looked at the routing table on R1 once more and noticed something peculiar.

    R1#show ip route 172.16.0.0
    Routing entry for 172.16.0.0/24, 4 known subnets
    Attached (4 connections)

    S       172.16.0.0 is directly connected, Loopback1
    S       172.16.1.0 is directly connected, Loopback2
    S       172.16.2.0 is directly connected, Loopback3
    S       172.16.3.0 is directly connected, Loopback4

I had actually created loopback interfaces for each of these networks, in addition to creating the static routes for them. The diagram above doesn't show it, but in the original lab, there were several other routers in different areas, and each of them had loopback interfaces for the purpose of practicing summarization. I got into the habit of creating these loopback interfaces and in my haste, did the same thing on R1 when in fact the only requirement was the creation of the static routes.

[![](/assets/2011/09/frustrated-1.jpg)](/assets/2011/09/frustrated-1.jpg)

I should have caught it before, but sometimes it's easy to overlook these kind of anomalies. If you look at the routing table above, you'll notice that the four routes are listed as "static", indicated by the capital "S" shown to the left, but the route entries state that they're directly connected. Typically, a next-hop address will be shown. However, since the networks are both statically configured and directly connected, OSPF viewed them to be invalid static routes for redistribution.

This was a silly mistake  - I mean there's really no point in creating a static route to a directly connected network, as connected networks have an administrative distance of 0 and static routes have an AD of 1. However, after thinking about it, this could be a relatively common occurance in a lab scenario. I shouldn't have created the loopbacks at all - I was trying to simulate too much of the scenario, and the static routes could have just been sent to Null0 or some similar interface.

The moral of the story is: try not to create static routes to directly connected networks. It could have some pretty frustrating trickle-down effects. Here in this scenario, it turns out that this simple mistake disqualified these routes for redistribution in OSPF.
