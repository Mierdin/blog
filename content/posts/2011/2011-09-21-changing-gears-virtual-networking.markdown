---
layout: post
title: 'Changing Gears: Virtual Networking'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-09-21"
wordpress_id: 1451
slug: changing-gears-virtual-networking
tags: ['fabric']
---


When it came to networking, my university classes didn't teach me much more than the basics of network infrastructure, and a little bit of route/switch. Now that I've graduated, I continue to learn as I strive for the next steps. So far, it's been CCNP ROUTE, since I knew I wanted to go for it soon after CCNA. Because of this trend, I've been pretty devoted to routing, with a small segway into security as I obtained my Security+ certification. With all of that going on, I've had little time to look into what I'm sure will become a big part of network engineering in the next few years - virtual networking.

That said, I'm going to be balancing my CCNP ROUTE studies with my own personal explorations into technology trends with respect to datacenter and cloud computing as it pertains to the skills I already have. I've found that a blog I already follow closely - [Etherealmind.com](http://etherealmind.com/) - has some great posts in this area and I'll be happy to look into some of these things, and perhaps generate some good blog content in the process. Here's some topics I've recently become interested in, for better or worse:

## The Death of Spanning-Tree

I was first introduced to this concept by listening to [Packet Pushers Podcast](http://packetpushers.net/), and Greg mentioned TRILL as the "Death of Spanning Tree". TRILL was invented for many reasons, but what I found to be most interesting is the lack of single-path bridging, as we have with STP. Although Multiple Spanning Tree (or PVST) solves this problem by load-balancing across multiple bridge paths, it's a very manual process and doesn't scale well.

TRILL is also supposed to have much quicker convergence time, which is the real play for cloud computing, as failures won't have nearly as much of an impact.

I also found it interesting that Radia Perlman, the creator of Spanning Tree, is leading this specification through the ratification process with the IETF. IEEE 802.1aq is also being proposed as alternative solution to the STP problem, but I've noticed far less "hype" about it. In a future post, I'll be exploring both solutions and figuring out why this is the case.

## VXLAN

What many people outside of networking don't realize is how much of a game-changer cloud computing is for us. While the learning curve isn't particularly high, and platforms like Vyatta can help us apply our learned concepts to a virtual network environment relatively easily, there are MANY things about virtual networking that break the mold. The biggest problem is that virtual machines are not tied to specific physical ports like a typical server is. This presents a problem for configurations applied at a switchport level, such as access lists, since virtual machines move around a lot.

VXLAN is one technology that attempts to solve this problem. Publicized (and criticized) quite heavily at the most recent VMWorld, VXLANs attempt to solve the scalability issues with classic VLANs. Keeping in mind that my exposure to this technology is limited, since it was only announced two weeks ago and I'm unfamiliar with the arena as a whole, it appears to run over IP as a form of encapsulating layer 2 traffic to a specific host or group of hosts.

If you research VXLAN, you're bound to find out more information about other technologies like OTV and LISP, which appear to be related pretty closely, but are more like competing solutions rather than compatible design options. In a future post I'll be comparing and contrasting all of these and joining in what has already turned out to be a very active debate.

The VXLAN draft is available here: [http://tools.ietf.org/html/draft-mahalingam-dutt-dcops-vxlan-00](http://tools.ietf.org/html/draft-mahalingam-dutt-dcops-vxlan-00)

## Fabrics: The Flat Network

In a high-demand environment like cloud computing, latency is a killer. When traffic is required to jump from device to device, latency is increased, and in the cloud, there's not a lot of tolerance for latency. Companies like Brocade have long-promoted solutions like Ethernet Fabric as a way of "flattening" the network, which means the reduction of hops to get from point A to point B, further reducing latency and improving overall performance in the datacenter. This goes against everything I know so far because my training has been physical networking with hierarchical design as a primary focus, but I'll do my best to switch gears when I'm thinking within the four walls of a datacenter.

## Well...It's A Start At Least

That's all I have for now. As I said, my main goal here is balance - I really feel like there's some space for me to use my existing knowledge to leverage additional learning experiences in an area that has promise of growth, and I want to make sure I apply my passion for research and tinkering to multiple areas of the industry.

I've created a new category called "Datacenter" and all related posts, including this one, will fall there.

I mentioned three key areas I've identified as a good start to get into these topics. If you have any particular desire to see one over the others, or have any additional suggestions for me to write about in this area, let me know in the comments! If you haven't noticed, I've switched to Disqus for comments, and enabled Facebook, Twitter, and Google authentication options for your convenience.

You can also visit the [Keeping It Classless Facebook Page](http://www.facebook.com/keepingitclassless) - leave some comments there!
