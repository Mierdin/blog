---
layout: post
title: Why Python?
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-01-31"
wordpress_id: 5305
slug: why-python
tags: ['api']
---


It's been really interesting to see the industry in an all-out zerg rush to adopt Python as a skill-set. What is it about this seemingly arbitrary selection in the vast array of programming languages available out there? What is so special about Python that it comes up in nearly every conversation about SDN?

> This post has been in drafts for some time, and I was motivated to finish it up by [this Packet Pushers episode](http://packetpushers.net/show-176-intro-to-python-automation-for-network-engineers/), where Jeremy Schulman and others discuss Python and its impact to networking.

Let's think about what we're trying to do when it comes to network programmability. We want what the networking industry has always wanted: a common standard to sit back on and know that - while the implementations may differ - the building blocks are always the same. My switch talks the same version of Ethernet as your switch. My router talks the same version of IP that yours does (unless you've lived under a rock and haven't adopted [RFC2460](http://tools.ietf.org/html/rfc2460) yet).

The networking industry (in general) tends to fall back on what's easy, and what's cheap - interoperability tends to trump every other consideration. One result of this is that proprietary hardware features are beginning to take a back seat to commoditization of the forwarding plane and enhancements made in software - that's why we're doing this whole SDN thing in the first place.

Sure - not every network controller / orchestration tool is going to be open source - but if the network engineer of tomorrow is going to be using APIs and SDKs as much as or more than individual CLIs, then there should probably some kind of common standard there as well. JUNOS and IOS maintain different command structures and syntaxes, but there is a decent amount of overlap, and at the end of the day, they're both CLIs. Learning one still puts you in a better position to learn the other.

A better, and perhaps even more practical example would be the education of engineers new to networking. Would it be beneficial to teach a new network engineer the list of syntaxes to make a router or switch "go", so that they can repeat those commands in order when prompted? Or would it instead be better to teach fundamentals such as subnetting, how cabling works, what the various protocols are on the network and how they work? After all, these concepts are by nature not dependent on a specific vendor.

Once a network engineer has learned these fundamentals, the next phase can begin - how to configure a specific platform to support these concepts. Learning an API is just another extension of this process. Okay, you know how STP works, here is the CLI command on NX-OS to configure it, and oh by the way, here is the JSON snippet you can send to make the same change programmatically.

When some SDN-happy whippersnapper comes up to you and says "oh you really should learn Python", understand that first and foremost, the reason for this goes way beyond Python specifically. The goal of what you're achieving with Python is rooted deeply in concepts of automation and "big picture" network configuration. Thinking programmatically can now go way beyond the context of application development and now move into an iterative model of configuring network devices.

So the reason for suggesting Python is much like everyone else's - it reads like a scripting language but is a lot more powerful. As a result, you can achieve a ton of functionality without that much additional complexity. That said, this network programmability movement seems to be settling on Python, so if you're new to all of it, that's probably a good place to start.

I will be defining exactly WHAT I believe network engineers will be required to write (in Python or whatever) in another post.
