---
layout: post
title: The Formation of "Brocatta" - Brocade Aquires Vyatta
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-11-05"
wordpress_id: 2531
slug: the-formation-of-brocatta-brocade-acquires-vyatta
tags: ['brocade']
---


Yes, I invented the word "Brocatta", and I am not ashamed.

[The announcement was made today](http://kellyherrell.wordpress.com/2012/11/05/vyatta-a-brocade-company/) that Vyatta, a company that I've long used for their software routers and firewalls, has been acquired by Brocade.

The move was not a surprise to me, as Brocade has yet to define a proper SDN strategy to compete with the announcement of Cisco's Open Network Environment and onePK. Positioning Vyatta as Brocade's "Software Networking" business unit is a good move because now Vyatta can operate more like an R&D department with better funding than I'm sure they've enjoyed thus far. This means the potential exists for some nice products coming out of that shop in the next few years.

It's important to understand, however, that Software Networking is NOT Software **Defined** Networking. The latter requires that the control plane be abstracted from the forwarding plane, so that a top-down view of the entire network can be had. A non-abstracted control plane will still require that protocols like OSPF and BGP are used so that two routers can communicate and converge on a common understanding of the network. This is a misunderstanding that is all too prevalent on the web right now.

By enabling an API on your network devices, or producing a piece of software that manages devices through netconf or something similar, you are not enabling software defined networking - you are simply managing individual management planes in a script more quickly. If you're truly SDN, you can start to ask yourself questions like "Do I really **need** BGP?"

No doubt, Vyatta has the "Software Networking" thing down pat. When it comes to true SDN, however, they seem to enjoy talking about it, but as yet have not emerged with anything tangible.

I'm a long-time user of Vyatta Core and will continue to use it, but it will take some big innovations to become a solid player in the same market as Juniper's Virtual Gateway (vGW) and Cisco's Nexus 1000v product suite, which now includes the ASA1000v for virtual firewall and the CSR1000v for virtual routing.

If Brocade is going to make a splash with this acquisition, in my opinion, they need to keep the momentum and use Vyatta to do two things:
	
  1. Produce a real, tangible SDN strategy to manage both software and hardware networking platforms. Much of the work is done, as Vyatta already boasts a capable API, but the control plane is still localized to each device. Vyatta can be better aimed at products like Juniper's vGW by leveraging technologies like VM FastPath the way the vGW does to improve performance and scalability.
  2. Make the SDN solution manageable, and fast. Produce a dashboard to manage network devices in a truly control-plane-abstracted manner within the next few years. Low-hanging fruit is the virtual space, quickly enabling cloud users to hand off the network to the application teams and get to developing purpose-built flows for the cloud apps.

No doubt still an exciting announcement and no one can deny the potential involved, but like most things in this space, it will take well-guided execution. I'll be watching these developments pretty closely.