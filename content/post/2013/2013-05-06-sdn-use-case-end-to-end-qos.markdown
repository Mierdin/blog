---
layout: post
title: 'SDN Use Case: End-to-End QoS'
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2013-05-06"
wordpress_id: 3409
slug: sdn-use-case-end-to-end-qos
tags: ['api']
---


Just a little unicorn-y brainstorming today.

This post is in some ways an extension of my [earlier post](https://keepingitclassless.net/2013/04/the-importance-of-qos-in-a-converged-infrastructure/) on the importance of QoS in a converged environment like FCoE or VoIP (or both). This will be a good example of a case where SDN very efficiently solves a policy problem that is present in an unfortunately large number of networks today.

For many organizations, large or small, the network is approached with a very siloed, "good enough" mentality - meaning that each portion of an organization's technology implementation is typically allocated to those that have that particular skillset. The folks that configure and maintain the Data Center network can often be a separate group (or at least a separate person) from the folks that support the campus network infrastructure, which is even further removed from the team that manages the server infrastructure, the storage infrastructure, etc. - all of which have a piece to play in what should be considered that organization's "global" QoS policy.

Of course, in small to medium environments, many of these roles are consolidated down to a few folks, but even then, there are silos, and where there are silos, communication tends to be more difficult.

[![QoSSDNVisio](/assets/2013/04/QoSSDNVisio.png)](/assets/2013/04/QoSSDNVisio.png)

This is all assuming that all technology under the org's roof is managed in-house. Frequently, technology implementations can be farmed out to third party solution providers (see Flexpod, vBlock, etc), and those engineers are only onsite for a few weeks - their main concern is getting the technology in place and working according to a general best practices deployment guide. I don't mean to really say "bare minimum", but most of the time a VAR isn't around long enough to do any of the really nitty gritty final touches like proper QoS design, especially if an application that really needs QoS isn't present.

The result of all of this is a pretty severe fragmentation of QoS policies from device to device. So, when an application like VoIP comes around and needs not only an intelligent QoS policy but a consistent one at that, the planning and the implementation stages will take quite a while to do properly.

SDN can and should take hold where the human element is the weakest link. For now, forget the idea that SDN may make our lives easier by making it easier for the DevOps teams to automate network tasks. While that's definitely  a very viable use case, the consistency that comes with SDN is a much more immediate benefit, in my opinion. Give me an open format for doing really basic interaction with each node on the network: routers, switches, servers, load balancers, firewalls, etc.

[![Network Intelligence Centralized - Probability for Human Error Diminished](/assets/2013/04/QoSSDNVisio2.png)](/assets/2013/04/QoSSDNVisio2.png)

For now I don't really care whether it's true control plane / forwarding plane abstraction - this specific use case will work just as well with continued decentralized control planes and a simple API on each device. There will be (and probably already are) pressing use cases that require a little more granularity.

This is also why SDN isn't the end-all-be-all solution for our problems. Will SDN eliminate the need for a CLI in the next 5 years? Likely not at all, if only for the few that want to tackle configurations in this manner. The movement of organizations to an SDN model will be an evolution, as they uncover one-by-one additional functions that we want to pass to the API.
