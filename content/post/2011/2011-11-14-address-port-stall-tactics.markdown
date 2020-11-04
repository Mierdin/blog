---
layout: post
title: Address + Port = "Stall Tactics"
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-11-14"
wordpress_id: 1756
slug: address-port-stall-tactics
tags: ['cgn']
---


I recently listened to [Packet Pushers Show 72](http://packetpushers.net/show-72-how-we-are-killing-the-internet/) on "How we are killing the internet" and want to voice my thoughts on the topics discussed.

The majority of the conversation circled around IPv6 adoption, and the state of the internet in light of the existence of tunneling mechanisms being used. Ivan mentioned that we are destroying the internet with all the tunnels (PPPoE, PPPoA, 6to4, 4to6, 6rd, etc) and translation points. The preference should always be to just route packets, but the majority of the internet isn't dual-stack yet so even the early adopters of IPv6 still need tunnels. Unfortunately, tunneling can cause some serious issues related to MTU; tunneled packets are often fragmented because of the packet size brought on by all of the additional headers. Packet inspection problems can also be seen, as some tunnels aren't easily inspected by security equipment.

The point is, tunnels are static, networks are not. Networks are constantly growing, changing, and moving. Tunnels may have been a good idea when they were created, but after a while, you lose the guarantee that the traffic is taking the best way through the network. If implemented correctly, tunnels can save your butt in a pinch; they should rarely be considered as a long term solution.

An author of recently published [RFC 6346](http://tools.ietf.org/html/rfc6346) was present, and mentioned this new proposed solution to the existing IPv4 shortage. With what they're calling "Address + Port" or A+P, an IP address can be shared between customers. Multiple customers will receive the same IP address, and the ISP will use port numbers to differentiate between the two.

In reading the RFC more closely, it appears as though CPE devices will be required to use some sort of NAT-PMP or UPnP(v2) mechanism to establish the range of ports it has, then a port-multiplexing mechanism like Port/Address Translation will use ports from that range. Some might call it layer-4 routing, but I'm not going to give it a name. Apparently, if the CPE device cannot request these port ranges, they're screwed. There are references to documents created in the last year or so for options related to port ranges.

A noble solution, but why? Lets look at the larger picture here. Those that have been keeping tabs on the IPv4 exhaustion have undoubtedly heard of something called Carrier-Grade NAT (CGN). In addition to the problems an **additional layer** of NAT will create on an application level, CGN will create even more obscurity when it comes to uniquely identifying a user with an IP address and a timestamp, which is impossible to do already.

The authors are obviously against Carrier-grade NAT. The Address + Port mechanism seems to be describing nothing more than a suggestion for ISPs to begin actually doing something with ports. One of the reasons for this suggestion is to allow IP addresses to be used more than once, as described above, which would be a direct competitor to the idea of CGN, since CGN is attempting to solve the same problem, but in a terrible way. Jan Zorz, an author of the A+P RFC and a guest on the Packet Pushers Podcast, said that content AND service providers need to start paying attention to source ports, so that this can be a realistic solution, but also because an IP address and timestamp by themselves can never indicate a unique user - there could be 60,000 users behind a single IP address. Carrier-grade NAT will make this situation even worse, which is why the authors have proposed the idea of ISPs making more use of port numbers.

Don't get me wrong - the whole A+P concept is certainly interesting and a damn sight better than carrier grade NAT. However, I wager it won't pick up steam. Even if it did see rapid adoption, it's not going to make people move to IPv6. The A+P mechanism will reach it's limits of extending the IPv4 space, just like NAT did. I'd like to think that giving people more time to move to IPv6 will solve the problem, but it won't. Therefore, the A+P idea shouldn't be looked at as a way to solve the IPv4 address shortage, but as a reminder to ISPs that there's a way for them to track users more precisely - and for that use case, I'd say it would do a pretty good job.
