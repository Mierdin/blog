---
layout: post
title: 'KIClet: NX-OS - Ethernet[X] is down (inactive)'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-09-21"
wordpress_id: 2480
slug: kiclet-nx-os-ethernet-is-down-inactive
tags: ['cisco']
---


This is a short one. I didn't see a ton of information on this on the internet so I figured I'd put it forward.

I'm using a pair of Nexus 2K FEX switches (N2K-C2248TP-1GE) for 1GbE copper connectivity off of a pair of Nexus 5548UP switches.

I needed to set one of the 2K ports to access mode and place it in a VLAN. Pretty simple. After configuring one of the 2K ports through the 5K CLI though, I noticed that the port was listed as "down (inactive)". I had not seen that port state before, so I did a little digging.

    Nexus5548UP_02# show int e100/1/48
     Ethernet100/1/48 is down (inactive)

Turns out that you need to configure the same thing on both 5Ks for the configuration to take, and the port to go up. Tony Mattke over at Packet Pushers [goes over this briefly](http://packetpushers.net/cisco-nexus-2000-a-lovehate-relationship/).

I, for one, would like to know when Cisco plans to fix this, as it is a pain, in my opinion. Doesn't seem to be too difficult to sync configs across the two 5Ks to which the 2Ks are connected, especially if they compose a vPC domain.

> [EDIT] I instantly received a response indicating that the NX-OS "config sync" feature could be used for this purpose. [See here for more info](http://www.cisco.com/en/US/docs/switches/datacenter/nexus5000/sw/operations/n5k_config_sync_ops.html#wp998883).
