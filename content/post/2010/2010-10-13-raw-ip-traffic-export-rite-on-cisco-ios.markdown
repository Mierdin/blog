---
layout: post
title: Raw IP Traffic Export (RITE) on Cisco IOS
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2010-10-13"
wordpress_id: 266
slug: raw-ip-traffic-export-rite-on-cisco-ios
tags: ['monitoring']
---


Often, especially in medium to large networks, it's crucial to monitor the traffic traversing your networks.

Those in the networking industry know that tools like tcpdump and wireshark are crucial for deeply investigating network issues. Even developers use these tools to diagnose issues with applications utilizing network resources. Many times, it is helpful to install/use one of these tools to figure out exactly what's traversing the network, by seeing the frames and packets themselves, in a visual way.

However, what if you cannot use these tools on your end devices? Many times, this type of diagnosis is needed in a highly-available datacenter-type environment, and installing one of these tools is not acceptable. Neither is, by the way, moving network cables around to get to a point in the network appropriate for capturing the right kind of traffic. Unlike wireless networks, which can be captured openly by simply standing between the devices communicating with a laptop, wired networks are structured in a way where capturing all the traffic you need can be difficult.

Cisco routers have the ability to export IP traffic from one interface to another by creating Raw IP Traffic Export (RITE) profiles within IOS. This is also known as port mirroring, although the two concepts are not exactly alike - port mirroring is usually attributed to a similar configuration on switches.

However, this will allow you to monitor traffic on a router by replicating either ingress,  egress, or bidirectional traffic from one port, even when that port is used by another device, by replicating that traffic on another port of your choosing. That way, you need only plug in a laptop to the secondary "monitoring" port, and start Wireshark, or some such program. (A common implementation is to send traffic to a centralized capture device like an IDS or a Wildpackets appliance). In fact, you could apply this configuration to EVERY port on a switch/router except your monitoring port, and ALL traffic on that switch/router would be replicated on your monitoring port.

A quick and easy way to configure RITE is as follows:

    LAB-2811-R01>enable
    LAB-2811-R01#configure terminal

    ! Profile name an be anything you want, just name it
    ! something useful
    LAB-2811-R01(config)#ip traffic-export profile <profile-name 

    ! Enter your monitoring interface here - the interface where
    ! you want traffic to get replicated to
    LAB-2811-R01(config)#interface <interface-name>

    ! indicates that you want traffic both going out and going
    ! in to be replicated to the monitoring port
    LAB-2811-R01(config-if)#bidirectional 

    ! This is the MAC of the device receiving packets, i.e., your
    ! laptop with wireshark
    LAB-2811-R01(config-if)#mac-address <mac-address>

    LAB-2811-R01(config-if)#exit
    LAB-2811-R01(config)#

You're now good to go with your RITE profile. However, you wont receive any replicated IP packets until you apply this profile to an interface or interfaces that you want to monitor. For instance, if you want traffic from interface FastEthernet 0/1 to replicate to your monitoring port, perform the following configuration:

    ! Here, you type the name of the profile you created earlier
    LAB-2811-R01(config)#interface FastEthernet 0/1
    LAB-2811-R01(config-if)#ip traffic-export apply <profile-name>

And that's it! Now, both traffic going in and out of FastEthernet0/1 will be replicated completely to your monitoring port. You can now plug in a laptop with wireshark, and start monitoring traffic. This command can be repeated on any number of interfaces you wish to capture traffic on.
