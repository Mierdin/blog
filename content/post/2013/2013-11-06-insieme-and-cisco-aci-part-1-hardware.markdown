---
layout: post
title: '[Insieme and Cisco ACI] Part 1 - Hardware'
series:
- Cisco ACI Announcement
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2013-11-06"
wordpress_id: 4938
slug: insieme-and-cisco-aci-part-1-hardware
tags: ['aci']
---


I'm pleased to kick off my 3-part blog series regarding the VERY recently announced data center networking products by Insieme, now (or very soon) part of Cisco.

## Nexus 9000 Overview

From a hardware perspective, the Nexus 9000 series seems to be a very competitively priced 40GbE switch. As (I think) everyone expected, the basic operation of the switch is to serve up a L3 fabric, using VXLAN as a foundation for overlay networks. The Nexus 9000 family will run in one of two modes: Standalone (or NXOS) mode, or ACI mode. In ACI, we get all of the advantages of a VXLAN-based fabric, with application intelligence built in to provide abstraction, automation and profile based deployment.

Some NXOS mode products are shipping now, more to follow beginning of next year.  ACI will be available by the end of Q1 next year, so I'll talk about ACI in the next post. For now, assume that the hardware I'm going to talk about is with Standalone mode in mind, meaning this is the hardware the early adopters will be able to get their hands on. I will also write about ACI-compatible hardware that Cisco's announcing in the second half of this post.

## Nexus 9500

The Nexus 9000 series will start off with an 8-slot chassis, the Nexus 9508. The 4-slot and 16 slot models will be released later. The Nexus 9508  is 13RU high, meaning each rack could hold up to 3 chassis. This will be a modular chassis with no mid-plane, for complete front to back airflow across each line card.

[![9500](assets/2013/11/9500.jpg)](assets/2013/11/9500.jpg)

Some hardware specs:

  * 4x 80w Plat Plus PSW's (same as used in the UCS fabric interconnects)
  * 3 blanking plates in the front allow for future PSU's (most likely used for 100G)
  * 3 fan trays (9 fans) in rear
  * 6 fabric modules (behind fan tray)

The initial line card with the Nexus 9508 will serve as a 40GbE aggregation line card (36 QSFP+ ports). The linecard was built to support 100GbE ASICs in the future with similar port density.

## Nexus 9300

The Nexus 9300 is being positioned as either a small, collapsed access/aggregation, with no core feature set - a ToR switch to be uplinked to a spine of 9500s.

[![9300](assets/2013/11/9300.jpg)](assets/2013/11/9300.jpg)

It is initially provided in two models:
	
  * Nexus 9396PQ - a 48 port non-blocking 10GbE switch. (2RU)	
  * Nexus 93128TX - a 96 port 1 or 10 GbE switch (with a 3:1 oversubscription ratio on the latter) (3RU)

Both models include a Generic Expansion Module (GEM). This is a 12 port 40GbE QSFP+ module used to uplink to the 9500 spine when running in ACI mode, or to any other 40GbE device if running in NXOS mode. Only 8 of these ports are using on the 93128TX. This module also provides an additional 40MB buffer, as well as full VXLAN bridging and routing. As will be detailed later, the custom ASIC developed by Insieme (called the Application Leaf Engine, or ALE) provides connectivity between ACI nodes, so the QSFP ports in the GEM module connect directly to the ALE ASIC, while the other ports use the Trident II.

## BiDi Optics

The Nexus 9000 hardware comes with some unique optics - they are [purpose-built bidirectional optics](http://www.cisco.com/en/US/products/ps11708/index.html) that were created to provide an easy migration path from 10GbE to 40GbE. These optics will allow customers to re-use their existing 10G multimode fiber cabling to move to 40GbE. This sounds like magic, but it's actually quite simple. These BiDi optics are still a QSFP form factor, and even uses the traditional LC connector that your existing 10GbE cable runs likely use.

These QSFP optics can be installed in any QSFP port, not just N9K, and not even just Cisco. This works by taking 8 lanes from the ALE ASIC and multiplexing it to 2 wavelengths at 20Gbit/s each (each is bidirectional) within the optic. Yes - you guessed it, WDM right in the optic.

This appears to be an offering by Cisco designed to move to 40GbE (a must for the ACI architecture) without drastic changes to existing cable plants. From what I've been told, you can even connect the ACI fabric to another non-Cisco switch in this manner. Obviously because of WDM directly in the optic, there must be one of these BiDi optics on both ends, but that should be it. These optics will support 100m on OM3 and 125m+ on OM4.

## Chipsets and Forwarding Behavior

The Broadcom Trident II will do the vast majority of the work, such as unicast forwarding, but also including VXLAN tagging and rewrite to/from NVGRE and 802.1Q. (more on this in Part 2) Insieme's own ALE ASIC is specifically designed to provide advanced functionality including ACI readiness. The ALE is still used in standalone mode to add an additional 40 meg of buffer (T2 only has 12Mb)

The Trident II ASIC handles all unicast forwarding.  Insieme's ASIC (ALE) provides additional buffer to the T2, as well as offers VXLAN offloading.  There is no direct path between Trident II ASICs, even on the same line card. Packets are sent to the Fabric Module if the ingress and egress ports are managed by separate ASICs. Fabric Modules have their own CPU and acts as a separate forwarding engine.

For L3 LPM lookups, the ingress line card forwards the packet to the Fabric Module (configured as the default route) which contains the LPM lookup table and forwards to the line card with the destination port V.1.0 of VXLAN is based on multicast, but the upcoming version will utilize a centralized VXLAN control plane. The new VXLAN control plane will be very similar to how LISP's control plane works, but VXLAN will retain the original full Ethernet header of the packet.

## ACI Mode

As mentioned before, the second mode that the Nexus 9000 series operates in, is ACI mode. This mode allows for enhanced programmability across a complete fabric of Nexus 9000 switches. With ACI as the SDN solution on top, the fabric acts like one big switch - forwarding traffic using a myriad of policies that you can configure. We'll be talking about these nerd knobs in the second post, but first, let's look at the hardware that will make this possible - slated for release sometime in Q2 2014.

  * 1/10G Access & 10/40G Aggregation (ACI)
  * 48 1/10G-T & 4 40G QSFP+ (non blocking) - meant to replace end-of-rack 6500's
  * 36 40G QSFP+ (1.5:1 oversubscribed) - used as a leaf switch, think end of rack
  * 40G Fabric Spine (ACI)
  * 36 40G QSFP+ for Spine deployments (non blocking, ACI only)
  * 1,152 10G ports per switch
  * 36 spine ports x 8 line cards = 288 leaf switches per spine
  * Leaf switches require 40G links to the spine

The line cards that support ACI will not be released until next year.

Spine line cards
	
  * 36x 40G ports per line card and no blocking

Supervisor Modules

  * Redundant half-width supervisor engine	
  * Common for 4, 8 and 16 slot chassis (9504, 9508, and 9516)
  * Sandy bridge quad core 1.8 GHz
  * 16GB RAM
  * 64GB SSD

System controllers
	
  * Offloads supervisor from switch device management tasks	
  * Increased system resilience & scale
  * Dual core ARM 1.3GHz
  * EoBC switch between Sups and line cards
  * Power supplies via SMB (system management bus)

Fabric Extenders

  * Supports 2248TP, 2248TP-E, 2232PP-10G, 2232TM-10G , B22-HP, B22-Dell

> Disclaimer - This article was written based off of informal notes gathered over the course of time. This article is merely intended to serve as an introduction to the concept of Nexus 9000 and ACI, and as such is potentially subject to factual errors that I may go back and make corrections to. I was not asked to write this article, but I did seek out factual details on my own because I wanted them for the purposes of accuracy. I also attended the Cisco ACI launch event as a Tech Field Day delegate. Attending events like these mean that the vendor may pay for a certain portion of my travel arrangements, but any opinions given are my own and are not influenced in any way. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
