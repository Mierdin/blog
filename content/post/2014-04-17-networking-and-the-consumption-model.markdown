---
layout: post
title: Networking and the Consumption Model
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2014-04-17"
wordpress_id: 5815
slug: networking-and-the-consumption-model
tags: ['networking']
---


I've talked with all kinds of IT professionals in the past year or so about building an organization of various IT disciplines that are truly service-oriented towards each other and to the other parts of the business. While I will never claim to be an expert in business development and will always claim allegiance to the nerdy technical bits, it's easy to see the value in such an organizational model, and very interesting to explore the changes that technical people can make to push for such an approach. Let's bring this down to earth a bit.

## Compute

Server Virtualization is old news now, so lets go back about 15 years before it was even really on the scene. You've heard the arguments for server virtualization, and the description of this "ancient age" - servers were provisioned on a 1:1 basis with applications, they took weeks to provision or replace, and the capex/opex costs were way too high because on the one hand, the sheer amount of hardware necessary to run your apps was outrageously expensive, and on the other hand, the power and cooling required to constantly run them was no better.

Lets think about the kind of resources the server team was providing to the business. Back then, it was little more than CPU and RAM. You need an application? Cool - find out how much CPU and RAM it needs, then I'll buy the right hardware and let you know when it's spun up in the DC in a few weeks.

Fast forward to today. Applications still require CPU and RAM - so the primary resource that the server teams watch over is CPU and RAM - right? Wrong. Server virtualization was a big step towards enabling a new model, but it required a few years of getting the right software in place, and utilizing methodologies like automation, self-service provisioning, and centralized policy to get to this point. We now have an entirely different operating model in this space.

Applications will always need CPU and RAM, so it's true that this is a crucial piece of what makes a server team successful - but it's no longer the focus of the service this team provides to other business units or IT disciplines. Because of these advances, resources like CPU and RAM (and many others) are no longer thought of in discrete quantities, but rather as part of a massive compute pool that is portioned up and handed out when needed. The "consumable resource" that the server team now offers is a home for your applications - one that is flexible, and instantly available. Yes the apps need CPU and RAM, but these are nerd knobs. The rest of the business wants the app - not it's nerdy details. This is an important distinction.

## Networks

As a network engineer, it's important to consider a similar paradigm. The network is required for communication between applications, or between apps and users, so what's the hard and fast technical resource that is "requested"? How about port count? Maybe bandwidth, latency or other metrics? In the past this may have been the most important consideration.

CPU and RAM are absolutely required to run apps. Sufficient bandwidth and low latency are just as crucial. No one is denying their importance. However - they are a commodity at this point. There is an expectation that an IT department will always be able to provide a compute platform for new apps at a moments notice, and that the network is already built to support it.

Like server virtualization did 10 years ago, networking is undergoing a transformation - a realization that the most important resource that other disciplines wish to consume about the network isn't these basic nerd knobs like bandwidth or latency - but rather the availability of tools that allow the network to be consumed in a similar fashion.

Take a simple thing like subnets/VLANs. Can you really honestly tell me that you enjoy being the gatekeeper for the spreadsheet, or sharepoint site, etc? Does it drive your passion for technology to be the guy or gal that takes requests for a new address space, works through the routing and security implications, implements the configuration, and marks the spreadsheet line as "in use" when finished? I imagine this is as pleasurable as it was for server engineers to get a request for a new application before virtualization, and probably just as time consuming.

We're smarter than this. We have better things to do than spend time updating spreadsheets and tagging trunk ports. The consumable resource in a networking shop is our amazing, nearly infinite experience in ensuring networks are sufficiently sized, secure, and always on. Let's get in the habit of offering this as a service. Lets treat the VLAN/subnet spreadsheet just like we treat compute pools now, which is just that - a pool. Build a process that allocates these resources dynamically, but with constraints that network engineers put into place to ensure consistency across their internal customers. Let's build a service catalog of policies that are constructed in a universal consistent language, so that minimal translation needs to happen between the network team and their customers.

## Conclusion

Server/virtualization admins have enjoyed the benefits of this approach for some time. The "in-use" portion of the infrastructure operates on it's own for the most part, and the focus then turns to monitoring - ensuring the existing infrastructure is stable - and staying ahead of future needs for expansion. It is a proactive approach rather than a reactive one. Networking engineers worldwide already have the capacity for this, and it doesn't require you to learn Python - only to think in a service-oriented fashion.

We have the technical expertise to build networks in the most cost-effective way, that is scalable, and as-closely-as-possible follows the K.I.S.S. (Keep It Simple Stupid) principle. We have the desire to get away from menial tasks and putting out fires. Let's push for a model where our network's consumable resource is the rapid and flexible application of policy - not to dumb our networks down, but rather to make them more intelligent.
