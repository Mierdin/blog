---
layout: post
title: The Importance of QoS in a Converged Infrastructure
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-04-10"
wordpress_id: 3381
slug: the-importance-of-qos-in-a-converged-infrastructure
tags: ['10GbE']
---


I've done quite a few posts on Quality of Service, particularly on it's basic concepts, as well as specific implementation details in a Data Center environment. Many of these concepts can be applied to really any use case, since QoS is QoS - just depends on how you classify traffic.

But what do we gain by implementing QoS, especially in a context like Data Center, where a modern core layer is typically at least 10GbE and network congestion is rarely seen? Will it really help us that much do configure QoS in any specific way, other that some default policies? In an environment where the Nexus 5000 is used to do some basic ethernet and FC/FCoE switching, it surely seems easy enough to deploy switches with the plethora of default FCoE QoS policies that come with the switch's FCoE feature set, especially if an application like voice is not present, at least not yet. So why do more?

[![QoS](assets/2013/04/QoS.png)](assets/2013/04/QoS.png)

Let's first clarify the definition of QoS and get down to what it's really aimed at doing. QoS is indeed good for providing priority to certain types of traffic in times of network congestion, but really when you think about all QoS can do, that's just a side benefit, albeit a really popular one. QoS is really aimed at providing the ability to classify traffic and treat it differently, regardless of what you're "doing" with the traffic. It allows you to define tags (CoS for L2 and DSCP for L3) that give class to a certain type of data, which keeps that class consistent when being transmitted between network nodes.

This is incredibly useful in converged infrastructure, whose entire point of existence is to reduce the physical (and even logical in some cases) separation requirements that have been seen in prior network evolutions. Given the recent bandwidth advances (10GbE is much cheaper, 40GbE is here and 100GbE is right around the corner) it's no problem to provide service-level, security, and bandwidth guarantees to very specific protocols, or even users of protocols.

Modern QoS solutions can do all kinds of things, many outside the context of a network under load. Sure, the big use case is allocating bandwidth so that under congestion, the "slice of the pie" that you've agreed upon for the various customers, tenants, applications to have is more or less protected. I'm sure most have seen a QoS configuration very similar to this Cisco policy map:

    policy-map type queuing Uplink-out_policy
      class type queuing class-platinum
        bandwidth percent 10
        priority
      class type queuing class-gold
        bandwidth percent 20
      class type queuing class-silver
        bandwidth percent 20
      class type queuing class-bronze
        bandwidth percent 10
      class type queuing class-fcoe
        bandwidth percent 30
      class type queuing class-default
        bandwidth percent 10

However, the same MQC structure can be used to apply other cool things like traffic shaping for a particular class, even when not under congestion. The best use case I can think of for this is vMotion. Those VMware guys sure like to move things around - it can be useful to carefully throttle this specific type of traffic to never exceed a certain throughput.

QoS can also be used to define queuing rules for multicast or broadcast traffic. It can be used to deploy  a structure where certain types of traffic (i.e. NFS, vMotion) gets Jumbo frames and other traffic (like VMs) do not. VERY useful if you are anything like me, and wary about simply enabling jumbo frames everywhere, like so many seem to want to do.

    policy-map type network-qos system-level-net-qos
      class type network-qos class-platinum
        set cos 5
      class type network-qos class-gold
        set cos 4
        mtu 9216
      class type network-qos class-fcoe
        pause no-drop
        mtu 2158
      class type network-qos class-silver
        set cos 2
      class type network-qos class-bronze
        set cos 1
        mtu 9216
      class type network-qos class-default
        multicast-optimize

EXTREMELY useful to avoid global jumbo frames, but still enabling it where it makes sense, and not where it doesn't. These are the kind of properties that a QoS structure can give you, even if you don't make a big use out of it right away. When deploying new switching hardware, it's a good idea to plan for the future, and still make use of the tools available where they make sense. In a converged environment, anything that allows you to get into the very granular will benefit, especially as the number of applications that we decide to collapse onto Ethernet increases.

Found a pretty good slide deck from Cisco Live about QoS. Recommend a peek at [this](http://www.cisco.com/en/US/technologies/tk543/tk759/technologies_white_paper0900aecd8019f3e0.pdf).
