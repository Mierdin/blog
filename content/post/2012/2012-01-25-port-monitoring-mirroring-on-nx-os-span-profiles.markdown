---
layout: post
title: 'Port Monitoring/Mirroring on NX-OS: SPAN Profiles'
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2012-01-25"
wordpress_id: 1904
slug: port-monitoring-mirroring-on-nx-os-span-profiles
tags: ['monitoring']
---


Port mirroring is a very valuable troubleshooting tool. Cisco calls this SPAN, and it's pretty easy to do. Cisco's NX-OS platform does it a little differently than traditional IOS, so I wanted to briefly post a walkthrough.

First, you have to set up the monitor session and configure source and destination interfaces:

    switch(config)# monitor session 1
    switch(config-monitor)# source int port-channel 2 both
   switch(config-monitor)# source int port-channel 3 both
    switch(config-monitor)# destination interface ethernet 1/7
    switch(config-monitor)# no shut
    switch(config-monitor)#

Notice that I configured both downstream port-channels to be my source interfaces, and that I used the "both" keyword. This means that any traffic going over either port channel, in either direction, will be copied to the SPAN profile, and subsequently the destination interface, which I then configured as ethernet 1/7. Finally, it's important to note that you have to "no shut" the session while in that mode to start actively monitoring your source ports.

In fact, you will run into an issue when you try to add an interface that is a part of a port-channel to a SPAN profile:

    switch(config-monitor)# source interface e1/3 , e1/4
    ERROR: Eth1/3: Interface is a PC member
    Eth1/4: Interface is a PC member

Be sure to use the port-channel interface itself as shown in the configuration above.

Now, you can "show" your SPAN profile to see how it's working:

    switch(config-monitor)# show monitor session 1
     session 1
    ---------------
    type : local
    state : down (Dst in wrong mode)
    source intf :
     rx : Po2 Po3
     tx : Po2 Po3
     both : Po2 Po3
    source VLANs :
     rx :
    source VSANs :
     rx :
    destination ports : Eth1/7
    Legend: f = forwarding enabled, l = learning enabled

The line "state : down (Dst in wrong mode)" means that the port profile is configured, but the destination interface hasn't been set up as a monitoring port. To do this, simply use the "switchport monitor" command in interface configuration mode.

    switch(config-monitor)# int e1/7
    switch(config-if)# switchport monitor
    switch(config-if)# show monitor session 1
     session 1
    ---------------
    type : local
    state : up
    source intf :
     rx : Po2 Po3
     tx : Po2 Po3
     both : Po2 Po3
    source VLANs :
     rx :
    source VSANs :
     rx :
    destination ports : Eth1/7
    Legend: f = forwarding enabled, l = learning enabled

Now, the SPAN profile is up, and life is good. Plug a patch cable into the destination port (e/17 for me) and the other end into a packet capture interface like your laptop. Enjoy your packets!

[This Cisco wiki page](http://docwiki.cisco.com/wiki/Cisco_NX-OS/IOS_SPAN_Comparison) goes over a lot of the differences in SPAN between NX-OS and IOS.
