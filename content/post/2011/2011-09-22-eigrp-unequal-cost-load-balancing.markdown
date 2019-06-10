---
layout: post
title: EIGRP Unequal-Cost Load-Balancing
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-09-22"
wordpress_id: 1470
slug: eigrp-unequal-cost-load-balancing
tags: ['cisco']
---


[In a previous post](https://keepingitclassless.net/2011/07/the-anatomy-of-show-ip-route/), I explored the basics of IP routing, and in the process, we discovered an interesting default feature of OSPF. When there were two OSPF routes in the routing table to a network, and both routes had the same cost, the router performed load balancing between the two. Take, for instance, the following route:

       172.16.2.0 [110/12] via 1.1.1.13, 00:09:24, FastEthernet0/0
                  [110/12] via 1.1.1.2, 00:09:24, FastEthernet0/1

In this example, every packet sent would take one of two routes. The next hop at this particular router would be either 1.1.1.13 or 1.1.1.2. As a result, the path bandwidth from R0 to R2 was essentially doubled to 200Mbit/s because the two FastEthernet interfaces were only being utilized at half the normal rate.

As you can see, the metric for each route is 12, but what if one path was a bit slower, and therefore had a different metric? The better route would make it into the routing table, and the other would be set aside. However, we end up with a link that's completely idle, and that's not what we want.

Unfortunately, with OSPF we aren't able to do load balancing between links of different cost, so we must switch gears and go to EIGRP, which allows us to do this, and it's called "Unequal-Cost Load Balancing".

Observe the following diagram:

[![](/assets/2011/09/Diagram.png)](/assets/2011/09/Diagram.png)

This diagram isn't completely different from my original post. We're on R1 and we're trying to get to the remote 172.16.0.0/24 network. I set up R4 just so we had something in the middle to ping. I also statically configured the bandwidth of the serial links as shown in the diagram. If you do the math, you'll notice that the link between R1 and R2 is T1 speed, and the link between R1 and R3 is precisely half that.

Let's take a look at the routing table to see how things work with a basic EIGRP configuration:

    (Some output omitted)
    
    R1# show ip route
    
         172.16.0.0/24 is subnetted, 1 subnets
    D       172.16.0.0 [90/2195456] via 10.1.2.2, 00:00:03, Serial0/0

As you can see, we've only got one route to the 172.16.0.0 network, and it's going through R2, as that link is at full-T1 speed, and therefore has the better metric.

A look at the EIGRP topology table shows that R1 is aware of the additional route, but it isn't good enough to be in the routing table.

    (Some output omitted)
    
    R1# show ip eigrp topology
    IP-EIGRP Topology Table for AS(100)/ID(10.1.3.1)
    
    P 172.16.0.0/24, 1 successors, FD is 2195456
            via 10.1.2.2 (2195456/281600), Serial0/0
            via 10.1.3.3 (3853568/281600), Serial0/1

In fact, it's not even good enough to be a feasible successor, and that makes sense because R2 and R3 are connected to the same FastEthernet switch, so both routes' reported distances would be equivalent.

In order to get this additional route to be acceptable to EIGRP, we need a simple yet powerful command. In EIGRP configuration mode, we enter the following:

    R1(config-router)#variance 2

This command specifies that we would like to include routes that have a metric **up to and including** 2 times that of the route with the best metric. Our slower link has exactly half the bandwidth, and actually a bit less than twice the metric of the faster link, so this keyword will be able to consider this extra route to be placed in the routing table.

Lastly, it's important to remember that EIGRP will auto-calculate load-balancing parameters once this additional route is selected. It will do it's best by dividing the two metrics and rounding to the nearest integer.

If we take a look at the routing table and look at the details for our remote network, we have a bit more visibility into the ratio of traffic being placed on each link.

    R1#show ip route 172.16.0.0 255.255.255.0
    Routing entry for 172.16.0.0/24
      Known via "eigrp 100", distance 90, metric 2195456, type internal
      Redistributing via eigrp 100
      Last update from 10.1.3.3 on Serial0/1, 00:07:14 ago
      Routing Descriptor Blocks:
        10.1.3.3, from 10.1.3.3, 00:07:14 ago, via Serial0/1
          Route metric is 3853568, traffic share count is 137
          Total delay is 21000 microseconds, minimum bandwidth is 772 Kbit
          Reliability 255/255, minimum MTU 1500 bytes
          Loading 1/255, Hops 1
      * 10.1.2.2, from 10.1.2.2, 00:07:14 ago, via Serial0/0
          Route metric is 2195456, traffic share count is 240
          Total delay is 21000 microseconds, minimum bandwidth is 1544 Kbit
          Reliability 255/255, minimum MTU 1500 bytes
          Loading 1/255, Hops 1

Our T1 link has a metric of 2195456, and the half-T1 has a metric of 3853568. Divide the smaller metric over the larger metric and you get 56.9. That's our percentage difference between the metrics. If you do the same process for the traffic share counts, you get 57.0, which is pretty damn close. It can therefore be said that for every 240 packets sent over our T1 line, we send 137 over our half-T1.

Let's run a traceroute from R1 to see how our changes turned out:

    R1#traceroute 172.16.0.4

    Type escape sequence to abort.
    Tracing the route to 172.16.0.4

      1 10.1.3.3 28 msec
      2 172.16.0.4 32 msec *  60 msec

And once more...

    R1#traceroute 172.16.0.4

    Type escape sequence to abort.
    Tracing the route to 172.16.0.4

      1 10.1.2.2 44 msec 4 msec 16 msec
      2 172.16.0.4 52 msec *  20 msec

And there you go. I tried this a few more times and I noticed I was getting the path through R2 a bit more often than the path through R3, which is what we'd expect, since the path through R3 only has roughly half the packets being sent over it.

You should be aware there are more configuration options available to fine-tune exactly how much traffic is placed on each link. However, for our purposes, we've successfully load balanced across both links proportional to the bandwidth on each link.

For more information, see below:

[http://www.cisco.com/en/US/tech/tk365/technologies_tech_note09186a008009437d.shtml](http://www.cisco.com/en/US/tech/tk365/technologies_tech_note09186a008009437d.shtml)
