---
layout: post
title: Static Routes to an Interface, Not A Next-Hop
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2012-03-15"
wordpress_id: 1979
slug: static-routes-to-an-interface-not-a-next-hop
tags: ['arp']
---


Static routes can be handy in some situations where you want to do some quick and (sometimes) easy routing to get the job done, whether replacing the job that a routing protocol would perform, or redistributing the static route into that protocol.

The best way to do this would be to identify the remote subnet being routed to, and specify a next-hop IP address to send traffic to so that it can be reached. The next-hop IP address must be in the routing table, and usually it is, since next-hop IP addresses are commonly in a directly connected subnet, which appear in the routing table with no configuration needed.
    
    R1(config)# ip route 0.0.0.0 0.0.0.0 192.168.0.1

However, sometimes the next-hop IP address is not known. For instance, a router that is installed on some kind of mobile platform would be connected to many various networks, and the static routes would need to be changed to a correct next-hop address each time. A better option would be to statically route to that interface, without specifying a next-hop:
    
    R1(config)# ip route 0.0.0.0 0.0.0.0 FastEthernet0/1

Me and my sleep-deprived brain are both looking at this and thinking: "How does this work? What are the implications of configuring it one way or another?" If you know me at all, you know I'll test any kind of routing theory question with GNS3/Wireshark any chance I get.

I set up a simple topology, with two routers serving as the L3 boundary for two Ethernet segments, and a single router connected to each. The idea is to set up a static route on R1 to a loopback address on R4 so that communication to the remote subnet can be established.

[![](assets/2012/03/topology.png)](assets/2012/03/topology.png)

Let's say we did things the traditional way, and entered a static route to the address assigned to R2's Fa0/0 interface: 1.1.1.2:

    R1(config)#ip route 0.0.0.0 0.0.0.0 1.1.1.2

You can worry about your own redundancy mechanisms, such as a floating static route to R3 in case the link to R2 fails - whatever you see fit. Regardless, if R2 is up, the initial connectivity, as with all network communication, requires a link-local address, which is retrieved via an ARP request for that next-hop address:

[![](assets/2012/03/old_arp.png)](assets/2012/03/old_arp.png)

We've all (hopefully) seen this before: since the address we're trying to get to (123.123.123.1) is on a subnet that is not directly connected, the routing table is used to identify the next-hop address. Since one is found, the ARP request is for that next-hop address, and the traffic to follow will be sent to the MAC address retrieved as a result. Shown above, R2 responds with it's MAC address, an entry is created in R1's ARP table and we all go on our merry way.

What if, however, we were to enter a static route to an interface, not a next-hop address? In the topology shown above, there are two viable next-hop routers that are absolutely capable of getting our traffic to where it needs to be. If we were to use this method, my question is: what's the selection process? What governs the decision to use R2 versus R3, or vice versa? Let's give it a try and see what happens.

We remove the static route shown above, and enter the new one, listing the Fa0/0 interface as the "next-hop":

    R1(config)#no ip route 0.0.0.0 0.0.0.0 1.1.1.2
    R1(config)#ip route 0.0.0.0 0.0.0.0 Fa0/0

When we ping the remote subnet, we get quite different results on the wire:

[![](assets/2012/03/new_arp.png)](assets/2012/03/new_arp.png)

There are several things I'd like to call to your attention. First, we are pinging an address that is on a non-directly-connected subnet, yet we see an ARP request for this address. This lets us in on a little-known fact about this particular type of static routing:

> Static routing to an interface where the next-hop address is ambiguous (i.e. NOT a point-to-point interface) will treat all addresses within the route as directly connected.

This means that every destination address that matches this route will be ARP'd. Depending on the environment, this could create an inordinate amount of ARP traffic on this segment, and increase the size of the ARP table on the router.

Notice also that both R2 and R3 responded with their MAC addresses, even though the 123.123.123.1 address isn't assigned to either of them. This is known as [Proxy ARP](http://en.wikipedia.org/wiki/Proxy_ARP). In the lay vernacular: "send it to me, I'll get it to where it needs to go". R2 and R3 both know how to handle this destination address, and since they both received this request, they both responded to it. As a result, if you decide to configure this method of static routing, you must ensure that the next-hop router supports Proxy ARP.

As to what address actually makes it into the ARP table, it seems to be all about timing. I've run this multiple times, and sometimes R2 will become the next-hop, and other times R3 will become the next hop.

## Conclusion

There's nothing intrinsically WRONG about static routing to an interface, but it does bring up major scalability problems, as well as other issues that you must be aware of if you're going to do it this way. In a point-to-point topology, this isn't too bad, because there can only be one next-hop address. But when using a broadcast medium like I was, it's best to use a next-hop address.
