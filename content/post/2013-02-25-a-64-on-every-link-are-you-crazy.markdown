---
layout: post
title: A /64 On Every Link? Are You Crazy?
author: Matt Oswalt
comments: true
categories: ['IPv6']
date: "2013-02-25"
wordpress_id: 3032
slug: a-64-on-every-link-are-you-crazy
tags: ['addressing']
---


I've had some great conversations lately with a lot of folks on the topic of IPv6 prefix length in a variety of applications, specifically [one very good discussion](http://classcblock.com/2013/01/14/show-8-poking-ipv6-with-a-stick/) on just about anything IPv6 between me, the kind folks over at The Class-C Block and Tom Hollingworth (aka The Networking Nerd).

For many folks that are considering the impact of going dual-stack in their environments, the idea of using a /64 on all links is still a point of contention. This becomes a religious debate when this argument is centered around point-to-point (2 host) links. After all - on paper, using a subnet length that supports up to nearly 18.5 quintillion addresses for a physical medium that logically should not need any more than 2 seems CRAZY wasteful. And anyone with half a mind would agree with you, if you're just talking about addresses, there's 18.5 quintillion - 2 addresses that we're basically throwing out, and that's for every point-to-point link we light up.

Let me put this whole thing another way. When considering a typical campus network where users plug in, get an address and start transmitting, you're probably used to thinking of size in terms of hundreds of clients. There are always exceptions, but it stands to reason that if the subnets you're using for these basic purposes are larger than this (i.e. thousands) then you're probably doing something wrong. Thus, most client-access subnets that are running IPv4 typically are represented by a /24, but can go down to longer prefixes if you really want to control traffic. This post is about scalability and not about security, so lets assume you aren't subnetting for the purpose of segmenting users from each other - most don't do this for user subnets anyways. Therefore, client access subnets can easily go up to /23 in size.

Starting at /22 (1,022 hosts), and assuming that the subnets are this big because there are THAT MANY workstations in need of addresses, in my experience, you begin to see some interesting behavior. IPv4 is bound to the function of ARP, which is inherently broadcast traffic - every workstation will receive and process ARP frames because technically each frame is addressed to them. On small subnets, this isn't an issue, because there just aren't many nodes that are doing ARP in the first place. However, the larger the subnet and the more hosts that exist on it, the greater amount of ARP traffic is seen. Lets not forget the fact that anytime you expand a subnet, you're increasing the number of hosts that are not required to send traffic through a layer 3 gateway - which can be a security risk. Separating users and servers logically is crucial for this - without a separate subnet, they're not forced to go through an L3 boundary like a router or firewall, and it gets really hard to prevent access where you don't want it (First person to mention VACLs/PACLs gets slapped).

Per IPv6's modus operandi, there is a bit of a mindset shift when moving to 128-bit addresses. Nearly every thought leader in the IPv6 space agrees - a /64 is a good idea just about everywhere. Let's break this into two parts:

## Isn't a /64 wasteful?

Jeff Doyle (my name for him is "Supreme Potentate of Routing") [puts it best](http://www.networkcomputing.com/ipv6-tech-center/the-fear-and-loathing-of-64s-on-point-to/231700160?pgno=1):

> Let's take a really big LAN. Say, 5000 devices. Is a /64 acceptable there? Yes, you say? So we're wasting (1.8 x 1019) - 5000 addresses instead of (1.8 x 1019) - 2 addresses. The difference between 5000 and 2 relative to 18 million trillion is miniscule. It diminishes to practically nothing.

The impact of using prefix lengths greater than /64 on a LAN where clients will be plugging in is definitely a bad idea. We know that basic IPv6 mechanisms like SLAAC just don't work on subnets like this. So rather than treat point-to-point links differently, purely on the basis of address waste, let's remember that even on the largest LANs, we're really not wasting that much less than on a point-to-point link. Seeing as we know that a /64 is rarely a bad idea, it makes sense to implement it everywhere. This approach - if nothing else - at least keeps things consistent and simple. Routing tables become very clean, easy to summarize, and make it almost intuitive to design a network that is hierarchical and contiguous.

## Okay - what *really* breaks when you use a /127?

[![Well, first off....this happens.](assets/2013/02/2588900543_b74701c1cd.jpg)](assets/2013/02/2588900543_b74701c1cd.jpg)

Originally, this was a pretty easy question. In [RFC 3627](http://tools.ietf.org/html/rfc3627) made it pretty clear that a /127 prefix had some serious problems, specifically with respect to subnet-router anycast addresses. The big "oh wait nevermind" RFC came 8 years later with [RFC 6164](http://tools.ietf.org/html/rfc6164), which makes two points: not only is the use of a /127 on a point-to-point possible, but it may be a good idea. Two specific issues are cited: the ping-pong routing issue that was mitigated in a later release of ICMPv6, and the problem of a neighbor cache exhaustion attack. This attack takes advantage of the fact that there are a bazillion addresses in a /64 (so this doesn't just apply to point-to-point links) and creates INCOMPLETE resolutions for each address on the router by spamming traffic to these unused addresses. Eventually the resources of the routers spike, and the legitimate addresses assigned to the routers are not able to be resolved across the point-to-point link, so this attack is viewed as most harmful to point-to-point links.

The RFC cites a /127 as the only true solution to this problem. Using link-local addresses is another possible solution, but.....it's ugly. It breaks traceroute, for instance, and it kind of defeats the purpose of global unicast addresses on those links in the first place. I personally have used /127 prefixes for point-to-point links, (with subnet-router anycast disabled) as well, and it works great. Security aside, there are pros and cons to each. Playing devil's advocate, there are some compelling reasons to use a /64 everywhere, and having REALLY clean routing tables is one of them. However, the "a /64 everywhere" mantra isn't one I'll be chanting, though in reality I may still implement it that way. The truth is, if it works, it works. Because IPv6 adoption seems to be slowly increasing, we're seeing that a /127 isn't really all that bad. My suggestion would be to adopt one of two methods:
	
  1. Allocate a single /64 for ALL point-to-point links. Out of that subnet, allocate specific /127 or larger subnets for your point-to-point links so that you know that the subnet you're looking at is used for that purpose. While this is only a drop in the bucket if you're seriously trying to conserve IPv6 address space, it does keep things neat, and Excel remains useful for recording subnets like this.

  2. Use a /127 on all point-to-point links, but preserve the /64 that it is part of for later use, if you decide to expand it later. A /127 seems to be working well for most point-to-point implementations, and having the ability to expand to a /64 later with no re-numbering is an attractive solution, especially if you're trying to avoid the neighbor exhaustion problem short-term.

Keep in mind though, that a nice benefit of using /64 everywhere from the get-go is the ability to keep your subnets EXTREMELY contiguous. You can allocate prefixes in your global space to something that makes logical sense - say an entire state, if you're a national organization. This way, you know by prefix what that network belongs to in your organization.

Also, note that [ARIN expects that a /64 is to be used on all point-to-point links](http://vermin.arin.net/index.php/IPv6_Addressing_Plans). They cite some rather informal reasons for this on that page.

In summary, it looks like the question of whether or not to use /64 on point-to-point links is answered with.....do whatever you want. This isn't really even an "it depends" situation, because it's almost a matter of preference. If you want to risk the possibility of neighbor cache exhaustion attacks and don't mind maintaining a discontiguous piece of your address space for all point-to-point links, then use a /127 on these links. If you want to keep things simple, use /64 everywhere. Keep it simple on all other network types, and use a /64. The key is to think several steps ahead when planning out your network's numbering scheme.
