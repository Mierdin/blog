---
layout: post
title: 'Network Configuration: The Case for Normalization'
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2014-02-28"
wordpress_id: 5552
slug: the-case-for-normalization-of-network-configuration
tags: ['api']
---


I've had network configuration tools and protocols on my mind for the last few weeks. Everyone's got some hot new API or configuration protocol - and on the outside looking in, it's easy to assume that they're all just different flavors of the same general concept - network configuration. So are they basically competing standards (VHS vs Betamax, anyone?)? Or is there a method to this madness?

Just to name a few, OVSDB and Netconf are actually established JSON-RPC and XML-RPC (respectively) based standardized formats for accomplishing network configuration on the wire, rather than chase down each vendor's individual [XML/JSON API](https://keepingitclassless.net/2014/02/cisco-aci-nexus-9000-nxapi/). In both cases, the underlying configuration is entirely dependent on the schema implementation (the stuff that goes inside OVSDB or Netconf) but at least the transport is more or less standardized.

What's NOT been done well up until now is the standardization of a network configuration model, outside the realm of any one particular vendor's implementation. A good example is the fact that Cisco is one of very few vendors that refers to link aggregation as "port channels". Most vendors actually call these "trunks". In Cisco lingo, a "trunk" is a port that tags VLANs across the wire (opposite of access port). Is this hard to remember for someone that is at all skilled in networking? Not at all - but it is an apt example of translation that needs to take place across implementations. When working programmatically with these ideas, standardization becomes even more important - some kind of data model that takes the general idea that we're trying to convey (link aggregation implementations don't really differ, it's just their name), and describes it in a language understood by all. Then, specific implementations like "trunk vs port channel" can be extrapolated from that higher language.

A common name for this concept is "abstraction". Another is "normalization". We want the desired end state to be described in a language that's not specific to that infrastructure. If we can get to this point, network operators can continue to function consistently even during periods of infrastructure refreshes. I believe a sign of a mature infrastructure team of any kind (not just networking) is a consistent presentation of services to other IT or business teams, even when moving to a new shiny hardware/software solution.

> This is also remarkably similar to the concepts behind "[promise theory](http://en.wikipedia.org/wiki/Promise_theory)". Ask [Mike Dvorkin](https://twitter.com/dvorkinista) about the topic sometime if you want your mind to be blown.

This discussion represents one of the biggest advantages of SDN platforms like OpenDaylight - that we don't have to define our network policy by adhering to a specific per-box syntax. Instead of treating the network as a collection of boxes, we can now apply policy on an abstracted layer defined by languages that normalize the configuration to something very basic, very "translatable".

ODL is far from the only example where network configuration is moving in this direction. Plexxi defines applications using "affinities", and defines how they interact with each other using "affinity links". There is no network-specific lingo that the apps guys have to worry about -this is all applied behind the scenes. Cisco ACI uses a similar concept called "application network profiles" and "contracts", then pushes these policies into an ACI-enabled fabric. Tail-F has a platform very similar in architecture to OpenDaylight - they, too make heavy use of a modeling language called [YANG](https://tools.ietf.org/html/rfc6020), which is the de-facto standard for normalizing specific vendor configuration data. So it's clear that this idea is neither new or scarce - the industry needs this. And network engineers need to understand this as well - learning a vendor's specific syntax is no longer the most important thing to focus on....and it really shouldn't ever have been.

The struggle that many networking guys have with this concept is that they feel they will lose the ability to troubleshoot. I want to be clear - abstraction is not meant to put up a smokescreen. It is primarily aimed at hiding the nerd knobs from those who don't wish to see it. Products in this space should absolutely provide the same level of bits and bytes detail for engineers, especially for troubleshooting. However, it is important to note that in terms of configuration, it is no longer advantageous to spend a lot of time working at the CLI of each individual device. Learn how your configuration is modeled in a generic way, and it is a skill you'll have to learn once.

I see a lot of value in having this discussion with both network operators and developers alike - expect more from me on this subject, as I think there's some value in this topic - at the very least as a temporary "middle ground" for the industry to converge upon in order to come to a quick, practical solution to the network configuration problems we face today.
