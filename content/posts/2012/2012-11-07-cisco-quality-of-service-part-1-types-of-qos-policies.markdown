---
layout: post
title: '[Quality of Service] Part 1- Types of QoS Policies'
series:
- Cisco QoS
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-11-07"
wordpress_id: 2543
slug: cisco-quality-of-service-part-1-types-of-qos-policies
tags: ['ccie']
---


There's a lot of information out there about QoS and it's an area where I'm only now starting to feel comfortable. I've been fortunate enough to have a decent amount of experience configuring datacenter equipment, especially in the context of a Flexpod, so I've been forced to know how all of these technologies play together with respect to QoS, which is very important when running sensitive applications like voice on such an infrastructure.

I'd like to kick off a multipart series (I have three articles planned at the time of this writing) where we explore certain aspects of QoS and how it applies to various datacenter technologies. There will be a lot of time spent on Cisco's Modular QoS CLI from the perspective of the Nexus switching that's found in many datacenters because, well....it's confusing as hell. I have talked with many engineers and destroyed more whiteboards than I care to admit in order to figure this out and understand why each line of a QoS config is there. I'll be the first to admit that I'm no expert but since I've spent the time and effort in learning and configuring it, I figure I'll pass along my experiences.

I'm going to assume you have some conceptual knowledge of QoS and what it's for, but only a little bit of experience actually configuring it. I'm speaking specifically to those like myself that have seen a QoS configuration from a template or documentation and said to themselves "screw this".

This post will explore primarily one specific thing: what are the types of QoS policies that can be used on a Cisco device that uses the (relatively) new MQC method for configuring QoS. This is a big reason why QoS configuration can be such a bear on modern Cisco hardware because there's so many knobs and whistles, most engineers just like to set up a default class for everything and don't bother classifying traffic. My aim is to clear things up to the point where you understand what each "knob" does so you can do things the right way. Lets face it - though it is easy, applying the same policy (like jumbo frames) to all traffic is just bad practice, and frankly is quite lazy.

I'm going to start this post by showing you a snippet from a switch I'm working on right now, where all QoS policies are currently being applied. We'll work backwards from there to help define these policy types:
    
    system qos
       service-policy type network-qos jumbo
       service-policy type qos input fcoe-default-in-policy
       service-policy type queuing input fcoe-default-in-policy
       service-policy type queuing output fcoe-default-out-policy

This snippet is applied in global configuration context, and as you can imagine, applies these policies globally - meaning that whatever these policies "do", they do it on all interfaces, either to both input and output traffic, or to whichever is specified - you might notice that most of them specify input or output.

Long story short, there are three QoS policy types:
	
  * Network QoS
  * Queuing
  * QoS

Policies typically refer to class maps for traffic identification (class-maps identify traffic and policies do something with the traffic) so when you see a list of class maps, they need to be created with the same policy type as the policy-map they're intended to be used for. For instance, here's a list of basic class maps that simply identify traffic based on CoS values:
    
    system qosclass-map type qos match-all class-platinum
      match cos 5
    class-map type qos match-all class-gold
      match cos 4
    class-map type qos match-all class-silver
      match cos 2
    class-map type qos match-all class-bronze
      match cos 1

Each class-map stands on it's own, simply identifying traffic for whatever policies refer to it. They are of type QoS, so that means they're used for a policy-map that's also of type QoS:
    
    system qospolicy-map type qos system-level-qos
      class class-platinum
        set qos-group 5
      class class-gold
        set qos-group 4
      class class-silver
        set qos-group 2
      class class-bronze
        set qos-group 3

Don't worry about the details regarding this syntax, that's all for another post.

Let's explore the policy types in that order:

## Network QoS

This is the policy type that you use to affect things that are specific to the network itself, and how packets hit the wire, not necessarily how devices handle and queue or reorder traffic- so traffic queuing is not done here. From Cisco: "A network-qos policy is used to instantiate system classes and associate parameters with those classes that are of system-wide scope."

You can only apply this type of policy globally, not per-interface.

I recommend that you read the [Nexus 7000 configuration guide](http://www.cisco.com/en/US/docs/switches/datacenter/sw/6_x/nx-os/qos/configuration/guide/nt_qos.html) on Network QoS - it explains this policy type quite well and the concepts still apply to Nexus 5000 or other. This section is largely drawn from that documentation.

The Network QoS policy is what you use when you want to apply certain changes to a specific CoS value or traffic identified via ACL. Here are a few features that you can configure using a Network QoS policy.

**Pause behavior** - This is where you identify traffic that can or cannot be dropped. If you want a certain traffic type (i.e. VoIP) to never be dropped, you apply that configuration here. Note that [Priority Flow Control](http://www.cisco.com/en/US/docs/switches/datacenter/sw/5_x/nx-os/qos/configuration/guide/qos_pfc.html#wpxref58773) is required for this behavior, which allows the switch to send pause/resume frames on congested links to help mitigate the traffic overload.

**Congestion Control Mechanisms** - This is probably the most concept-heavy part of QoS. Please read the [Cisco QoS Exam Certification Guide](http://www.amazon.com/Cisco-Certification-Telephony-Self-Study-Edition/dp/1587201240) to know more about congestion management; this is probably going to take up 80% of your study time, since very little effort is spent on the other stuff in real-life once you learn it. That's how it was for me, anyways. Functions like tail-drop (drop late packets that don't make it into the capacity for a given queue) and WRED, which selectively drops packets you've identified as less important than other packets in order to alleviate congestion on a link.

**MTU** - This is an important one for me, since a lot of the environments where I'm configuring this stuff utilizes VMware vSphere for virtualization, and jumbo frames are very useful to applications like NFS or vMotion. However, I don't want to apply jumbo frames globally, so the ability to allow it for only permitted traffic types is extremely powerful. The MTU range is from 1500 to 9216. The MTU must be smaller than the system jumbo MTU (in all VDCs, if you're using Nexus 7Ks). Be sure to apply the same MTU to both the ingress and egress queues you've configured.

## Queuing

Queuing really only does one thing, and that is to handle the order of packets in a device's queues. So policies of type queuing affect those properties. Two properties in particular are provided for us to make these changes.
	
  * Bandwidth - Sets the guaranteed scheduling deficit weighted round robin (DWRR) percentage for the system class.
  * Priority - Sets a system class for strict-priority scheduling. Only one system class can be configured for priority in a given queuing policy.

(From Cisco's QoS Configuration Guide)

This is an important concept to realize, because many engineers who don't change any of these properties just don't understand what the queuing class-maps are doing in certain configs they've come across, especially when there are also class-maps for types qos and network-qos. Very confusing, but it's like that for a reason.

## QoS

Type QoS is all about classification (or "identification", if you prefer). With this class type, we are able to identify certain types of traffic using all kinds of properties. Here's a list:
    
    system qosNX5548UP_A(config-cmap-qos)# match ?
      access-group   Access group
      cos            IEEE 802.1Q class of service
      dscp           DSCP in IP(v4) and IPv6 packets
      ip             IP
      precedence     Precedence in IP(v4) and IPv6 packets
      protocol       Protocol

You can get pretty creative with this, but essentially you match the property you want, and use a policy map of type "qos" to get it into a group that the switch uses for keeping track of different classes of traffic called QoS Groups. We'll get into that in a future post.

Those are the types of QoS policies - we'll get into their application on the next post.

## Resources

* [http://www.cisco.com/en/US/docs/switches/datacenter/nexus5000/sw/qos/Cisco_Nexus_5000_Series_NX-OS_Quality_of_Service_Configuration_Guide_chapter3.html#con_1120879](http://www.cisco.com/en/US/docs/switches/datacenter/nexus5000/sw/qos/Cisco_Nexus_5000_Series_NX-OS_Quality_of_Service_Configuration_Guide_chapter3.html#con_1120879)
* [http://www.cisco.com/en/US/docs/switches/datacenter/sw/6_x/nx-os/qos/configuration/guide/nt_qos.html](http://www.cisco.com/en/US/docs/switches/datacenter/sw/6_x/nx-os/qos/configuration/guide/nt_qos.html)
