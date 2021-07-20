---
layout: post
title: '[IPv6] Subnetting - Wait, we still need to do that?'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-01-11"
wordpress_id: 290
slug: ipv6-subnetting-wait-we-still-need-to-do-that
tags: ['addressing']
---


Subnetting, in short, can be thought of as an adjustable "slide rule" that tells the network infrastructure the logical size of a sub-network, or subnet. This is useful if you know how many IP addresses you'll  to suit the needs of a predetermined number of PCs, so you can plan the size of your subnets to match that requirement. With IPv4, subnet masks are used to determine how big the subnets are.

A standard IPv4 address requires 32 bits to describe it. These are commonly seen in the following format:

    192.168.0.1

You've probably also seen these addresses accompanied by their "subnet masks". A pretty standard mask could be:

    255.255.255.0

While IPv4 addresses were traditionally read in decimal form, IPv6 addresses are usually shown in hexadecimal form. A sample address could be:

    2001:42b:7a5:1::1/64

The internet does NOT have a lot of information regarding IPv6 subnetting. For those that have worked in the networking industry for a while, or have had a networking education that primarily focused on IPv4, as mine did, you're used to subnetting. Its one of those concepts that's been ingrained into our minds as a fundamental component to designing and running a network.

You'll notice in the above example that I threw on the "/64" to that IPv6 address. Much like IPv4, this notation describes which part is the network portion of the address (doesn't change from host to host), and which is the host portion. Lets say that address was part of a block allocated to our company by our ISP. This block might look like this:

    2001:42b:7a5::/48

This is not an address, but rather a large block of addresses (notice that there is no number at the end, only the "::") The /48 describes, again, that the first 48 bits of the address will not change. These characters will be seen on EVERY address in that block. That means that the whole company, using this block, will use addresses that all start with 2001:42b:7a5, since those are the characters described by the first 48 bits of the address.

Remember that the actual address had a /64 notation at the end. So what happened to those 16 bits? That, my friends, is our subnet portion. In this example, its actually the fourth quartet in the address, which is visible in the address as "1", or in uncompressed notation, "0001".

[![](/assets/2011/01/Untitled.jpg)](/assets/2011/01/Untitled.jpg)

This quartet is ours for the taking. This portion of the address is analyzed in the same way the entire subnet mask in IPv4 was analyzed by PCs to determine if a destination is on the same subnet. If the IP address was on the same subnet, it was sent to the MAC address in the ARP table associated with that IP. If not, it was sent to the default gateway for routing. This concept is exactly the same in IPv6 - if the first four quartets are the same in a /64, its on the same subnet, and its sent straight to the host. If not, its sent to a router that knows how to get to that IPv6 subnet.

So, with that 16-bit subnet portion, IPv6 [global unicast](http://lmgtfy.com/?q=global+unicast) addresses always have 64 bits in their host portion. Although it is technically possible to design networks with a smaller host portion, it is impractical because stateless autoconfiguration is one of the biggest advantages of IPv6, and it requires a 64 bit prefix.

Due to the MASSIVE increase in address space, "IPv6" and "subnetting" are two terms that are logically disjoint. After all, subnetting is commonly used to segment networks into smaller chunks, making more efficient use of the available address space, and because there's an absurd amount of address space with IPv6, that level of efficiency is a bit unnecessary.
Subnetting was also created to help manage broadcast traffic, and in IPv6 there are no broadcasts, only multicasts. So what is the point of subnetting?

Remember, that even with the reduction of broadcasts, subnetting is still useful to further reduce unnecessary network traffic. It's also important to remember to use subnetting for security purposes. Having a portion of your network (Like Research and Development or Accounting) on a different subnet forces other clients to go through a router to get there, which is where security policies and devices can be applied. So, the answer is - subnetting in IPv6 is still necessary, but not for the reasons IPv4 people are used to. You have a pre-defined number of available subnets to use, based on the /48 you'd get from your ISP, but you'll have more than enough address space to work with. (Thats 65,536 subnets with 18,446,744,073,709,551,616 available hosts per subnet, folks.)

This gives us as network administrators a lot of flexibility in designing networks. Route summarization is now extremely easy, since we can give our networks logical, hierarchical address blocks that are able to be summarized into areas(Check out [OSPF](http://lmgtfy.com/?q=OSPF+areas)). This results in more efficient routing, and networks that are easier to manage. For more on IPv6 in general, or about any of the topics discussed here, please question me in the comments; I'd love to hear from you as both of us learn about this exciting new topic in networking.
