---
layout: post
title: 'SDN: Integration over Manipulation'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2015-05-13"
wordpress_id: 6087
slug: sdn-integration-over-manipulation
tags: ['acls']
---


I'd like to briefly express a sentiment that I pondered after listening to another one of [Ivan's great podcasts](http://blog.ipspace.net/2015/05/openflow-in-hp-campus-solutions-on.html), specifically regarding the true value of a software-defined network approach. The statement was made that ACLs are terrible representations of business policy. This is not inaccurate, but the fact remains that ACLs are currently the de facto representation of business policy on a network device. The "network team" gets a request from an application team to "fix the firewall", and the policy that is applied to enable that application typically results in an ACL change.

If you've ever been in this situation, you likely realize this entire process probably takes some time. Either the application team doesn't know what exactly needs to be changed, or the network team is too busy, or both. Clearly, there's a problem. And more often than not, this discussion becomes all about the forwarding architecture.

<blockquote>Oh yes, with old-school ACLs we could only match on a few things - IP subnets, TCP ports, that's about it. But now with OpenFlow - we can match on **EtherType**!! We're saved!!</blockquote>

Don't be misled - the value of an SDN architecture does not lie in the fact that we can do cool new things with our packets. These interesting extensions are useful but not ultimately the primary source of value.

So what's so hip and valuable about this new SDN thingy? Vendors will be happy to talk to you about the radically different control planes and forwarding planes that enable all kinds of interesting path manipulation and frankly I don't blame them - this is undoubtedly the area where customers want to drill into most often. We are so often concerned with the nerd knobs to make sure the vendor did it right, to the point where we overlook the more important part of the conversation.

Admittedly, ACLs are not great representations of business policy, but it's not because it doesn't have enough fields to match on - it's because business policy should be applied at a much higher layer. We shouldn't be relying on ACLs to be the end-all representation of what we're trying to do. Where things get interesting is when you're able to pull down metadata from outside the network into the network (and vice versa). This is only possible when dealing with the network as a system, and not simply a collection of boxes. Without this integration, you're just working with ACLs in isolation, which will always require (extremely inefficient) human "collaboration" to work out.

The biggest value of driving the network in software is that you can address the network as a system - and as a result, are able to share metadata around tightly coupled feedback loops much more easily. This puts us much further down the road to autonomy, and allows us to define business policy in a language more relevant to the business policy, leaving low-level constructs - ACLs and OpenFlow alike - totally up to the abstractions provided in software. In truth, many of the solutions emerging (both paid products and those assembled from open source components) allow for some really powerful policy definitions. Unfortunately, due to the way I've seen IT infrastructure is bought and sold, I fear these awesome cross-silo integrations will go largely underutilized.

As network engineers, it's important to get to the bits and bytes level - especially when troubleshooting. However, always keep in mind that this is first and foremost a systems integration problem that we're trying to solve. I frankly would prefer a solution that provides much more robust systems integration that doesn't change anything radically at the forwarding plane than a closed black box that has endless nerd knobs.
