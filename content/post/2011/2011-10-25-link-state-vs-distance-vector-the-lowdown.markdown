---
layout: post
title: Link-State vs. Distance Vector - The Lowdown
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-10-25"
wordpress_id: 1655
slug: link-state-vs-distance-vector-the-lowdown
tags: ['eigrp']
---


I've been trying to get more into networking message boards like [Networking Forum](http://www.networking-forum.com/) and [TechExams.net](http://www.techexams.net/forums/) lately. It's a great way to get in touch with fellow packet lovers and gain some interesting perspectives along the way. In fact, it's great for anyone in networking, whether you're a hardened veteran or a newbie - there's usually a place for you in at least one of these sites. As a result, I've seen quite a few posts asking about fundamental concepts, which is great because it shows that new networkers are getting out there and learning new things proactively.

I'd like to address one such post I saw recently:

> "What's really the difference between link-state and distance vector routing protocols? I know RIP is old and garbage, and that's what I usually equate distance vector routing protocols to, but what about EIGRP? I hear that's "advanced" distance vector. Is BGP really distance vector - why would the internet routing protocol be so 'old school'?"

Hopefully by the end of this post I'll answer these questions for you.

## Distance Vector

What's the first thing that comes into your mind when you think of distance vector routing protocols? Most think of Routing Information Protocol (RIP) because it is often the first routing protocol taught in networking courses. By no means is it the best protocol to run, but it is the easiest to configure, and conceptually very easy to swallow. However, after learning all of the loop prevention mechanisms required to run it, and seeing how shiny and pretty basically every other protocol is, it's easy to quickly dismiss RIP as nothing more than an early learning experience. However, that departure from this crappy routing protocol can tend to create a separation between RIP and other distance vector routing protocols that isn't there.

Now - we've established that RIP is a distance vector routing protocol, but what about these other things that we've heard? How about EIGRP, for starters? EIGRP establishes neighbor relationships and maintains a topology table just like OSPF, which we all know is a link-state protocol. Yet we hear Cisco, the creator of EIGRP, refer to it as an "advanced distance vector" protocol What gives?

First, let me be clear -EIGRP is a distance vector protocol; don't let Cisco tell you any differently. They label it with the "advanced" keyword because they see it your way - they don't want EIGRP to be grouped with the likes of RIP (hoity toity much?). However, if you understand the key difference between the two classes of protocols, you'll learn that there's no reason to make that separation - EIGRP is still a pretty good routing protocol because of the features it has, and being a distance vector protocol doesn't change that.

Ever heard that distance vector routing protocols like RIP perform "routing by rumor"? It's true - and it's the fundamental reason why they are in a separate class from link-state routing protocols. RIP, as you may know, announces its whole routing table to the entire network. RIPv1 would actually send it via broadcast (ouch), but RIPv2 at least limited it to sending only to RIP routers via multicast address 224.0.0.9. Still even with multicast, it was sending its entire routing table every 30 seconds by default, and those even at the CCNA level know: that's garbage! Already we've established a key difference between RIP and other DV protocols like EIGRP. EIGRP sends only triggered updates, not this routing-table-at-an-interval stuff.

Now - it's true that EIGRP establishes neighbor relationships and maintains a topology table like OSPF does, and that's probably a big cause of some of the confusion. However - take a look at a sample EIGRP route advertisement:

[![](assets/2011/10/EIGRP-UPDATE.png)](assets/2011/10/EIGRP-UPDATE.png)

Now - those familiar with EIGRP are pretty comfortable with everything shown here. We know that all of the values used for calculating metric (as well as MTU even though it's not used in EIGRP metric calculations) are sent along with each route - it is, after all, just one big route advertisement. So maybe it's not as bad as RIP, because it's only one route, and there's certainly a lot more information given here so that each EIGRP router can make more intelligent routing decisions, but the decisions themselves are still based off of another router's routing table. This advertisement is here because the sender uses it themselves and is advertising itself as a potential next-hop to get to this route.

This is what we adequately describe as "routing by rumor". EIGRP doesn't  make the decision on where to route packets based on our own calculations, it simply listens on the network for route advertisements, then picks the best one out of the ones it received and placed it into the routing table. In this way, EIGRP is exactly like RIP, and that's because this is the precise definition of a distance vector protocol.

## Link State

Link-state protocols do not advertise routes. They advertise links. The SPF algorithm generates routes based on that information - and it is as complex as it is because it has to do so mathematically. SPF is essentially distrusting of other routers. SPF wants to figure out for itself, with no help, exactly where each packet should go. This decision is based purely on the state of each link in the network - thus link-state. No distance vector protocol like RIP, EIGRP, or even BGP does this.

[![](assets/2011/10/OSPF-UPDATE.png)](assets/2011/10/OSPF-UPDATE.png)

The above packet capture is from an OSPF Link State Update, which contained a single Link State Advertisement. This is the way OSPF works - rather than distribute routes, it advertises links. These can take a variety of forms, and there are entire books dedicated to the different type of LSAs, but the important thing to remember for this post is that this packet is not a route advertisement. This message contains a Type 1 LSA, other wise known as a router LSA, and it describes everything this particular router is connected to.

Near the bottom, you can see two "stub" networks listed. These networks actually would also be advertised via a separate LSA by the routers connected to them, which would be Type 2. Eventually, the OSPF router would receive LSAs from everyone and would build out its link-state database (LSDB) as a result. The LSDB has nothing to do with routing - not yet - it just contains a detailed account of every router and network within this OSPF area.

Once this picture of the network is complete - then the SPF algorithm goes to work, building out the network topology and choosing the shortest path to every single destination based off of this information. The routing decisions are based off of the conditions and properties of each link, and this decision is not influenced by a neighbor's routing table.

As you might imagine, the SPF algorithm must be really complex to be able to do all this. It is - this algorithm requires the most processor power out of any other routing protocol. It is for this reason that OSPF should only be run if you can do it correctly. OSPF makes your network work better but only if you design hierarchically, making good use of areas and proper summarization. It is crucial to have contiguous IP addressing in place to take advantage of summarization.

The concept of OSPF LSAs aren't really emphasized heavily until the CCNP ROUTE level, and it can be a crucial concept in order to truly understand what it means to be link-state.

## The Catch

Now - protocols like EIGRP are obviously vastly superior to the likes of RIP. Distance vector protocols still have to implement loop prevention mechanisms, as is the nature of the beast, but EIGRP has plenty of features that make it much more desirable. EIGRP has a much better convergence time than any other routing protocol, including OSPF. One feature in particular that helps speed convergence is the concept of EIGRP Feasible Successors, [which I blogged about in detail in an earlier article](https://keepingitclassless.net/2011/07/eigrp-feasible-successors/). The idea that Distance Vector protocols are inherently bad is an ignorant assumption - not only because you're limiting yourself to basically just OSPF since IS-IS isn't really used anymore, but also because protocols like EIGRP might be a better fit for your environment.

I'll be the first to admit - some network engineers feel like OSPF is a pain in the neck, and sometimes I can see their point of view. It's kind of overkill for small-to medium environments and only makes sense to run in large environments where link state information would be complex enough to take advantage of the protocol and make more intelligent routing decisions. When it comes down to it, OSPF is a great tool to have if you need it. For all the other environments, as long as they run Cisco, EIGRP is a great alternative. It has great convergence time and it's easy to configure (dont' forget "no auto-summary")

So Cisco, you don't need to defend your protocol and call it "advanced" distance vector. We know it's not as bad as RIP.
