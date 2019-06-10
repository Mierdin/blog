---
layout: post
title: Vital Gadgets for a Datacenter Network Engineer
author: Matt Oswalt
comments: true
categories: ['Datacenter']
date: "2012-04-11"
wordpress_id: 2067
slug: vital-gadgets-for-a-datacenter-network-engineer
tags: ['cisco']
---


I would like to share some tips regarding gadgets that I believe every Datacenter Network Engineer should have with them. There are several, but I want to bring up my top two.ß

## Travel Router

I am often in situations where it is either difficult or impossible to manage Nexus switches and/or UCS remotely. Pick your reasons - sometimes the management network doesn't exist (yet) or there are heavy security measures in place that restrict wired management, whatever. Sometimes it's handy to be able to provide wireless access to something on the fly.

I will say, that in these types of situations it is CRUCIAL that the owner of the network is completely aware of your actions here. It is never a good thing, especially in a pro services context, for the customer to discover this when you haven't received the proper approval.

My solution to this problem is the [TRENDnet TEW-654TR Wireless Travel Router Kit](http://www.newegg.com/Product/Product.aspx?Item=N82E16833156262).

[![](/assets/2012/04/2012-04-11_15-12-50_151.jpg)](/assets/2012/04/2012-04-11_15-12-50_151.jpg)

This particular model isn't a powerhouse of wireless excellence, but it is absolutely compact and feature-rich despite its size. It supports up to 802.11n, can autosense channels (great for avoiding interference with enterprise WLANs), and supports just about anything else that a normal SOHO wireless router would support, like NAT/firewall, DHCP, etc.

My only complaint is not even one against this particular model, because I've found that it is true of just about any travel router you can buy: it does not support Gigabit Ethernet. Dealbreaker? No. Given that management is the single use case for my purchasing of this device, GigE is certainly not high on my priority list. HOWEVER - as mentioned, I typically use this to remotely administer Nexus/UCS installations, and your typical Nexus 5K/7K port does not support LOWER than Gigabit Ethernet. So I've matched up a travel router that can't do GigE, and a switch that can't do anything lower.

See below for a resolution to this issue.

## Gigabit Autosensing Switch

As mentioned before, the inability for 10/100 devices to operate while connected to a switch that cannot do lower than Gigabit is a problem. This is an issue with the travel router shown above, but also when you want to test/manage devices directly via the wire. As a result, it's important to have a small switch that's capable of going up to Gigabit and performing autosensing to get up to those speeds when needed, and operating at 10/100 when devices like a 100Mbit travel router is connected.

Check out the [TRENDnet TEG-S80G](http://www.newegg.com/Product/Product.aspx?Item=N82E16833156251) on Newegg. It has all the features I need, and it doesn't cost that much.

I ran into an issue a while back at a customer site where the Nexus 5000 pair was set up to connect to a pair of upstream firewalls that did not support Gigabit Ethernet. This was a POC that would eventually be moved to a production site where GigE firewalls existed, but for the time being, we needed to make the 100Mbit firewall work with the Nexus. A small GigE Autosensing switch is perfect for situations like this (temporarily of course - not recommending this for production).

If you really want to get hardcore, you might consider purchasing a managed switch in some cases. For instance, with respect specifically to Nexus 5000 installations using vPC, it's a good idea to have a device capable of running LACP port channels. This allows you to communicate on both sides of the vPC environment for testing or normal traffic. I've done enough of these that I don't need to do this testing with a device like this, but if you think the hefty price tag is worth it, that's your call.

Before you ask, I am not a prophet of all things TRENDnet, it just so happens that these two devices do the job for me and are well-priced. YMMV, and there are devices from other vendors that do the job as well.
