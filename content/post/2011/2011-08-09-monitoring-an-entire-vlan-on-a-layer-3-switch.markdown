---
layout: post
title: Monitoring an entire VLAN on a Layer 3 Switch
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-08-09"
wordpress_id: 714
slug: monitoring-an-entire-vlan-on-a-layer-3-switch
tags: ['catalyst']
---


A recent and relatively quiet IOS release allows the Catalyst 2960 platform to perform limited Layer 3 Switching (See [this thread](http://www.networking-forum.com/viewtopic.php?t=23538) and [this blog post](http://blog.alwaysthenetwork.com/tutorials/2960s-can-route/)). There are limitations - for instance, it cannot run any sort of routing protocol, so routing must be done statically. Up to 16 static routes can be entered, and routing is limited to SVI's (maximum of 8), as the platform is not able to route to or from a physical interface, like you're able to do with most layer 3 switches.

I have a few Catalyst 3550's in my lab at home, I wanted to get configuring Layer 3 switching between them. In my work, I wanted to make sure I had the appropriate configuration to monitor all devices, which I had done in a [previous blog post](https://keepingitclassless.net/2010/10/raw-ip-traffic-export-rite-on-cisco-ios/) by using Raw IP Traffic Export on a Cisco 2800 router. Since all clients used this router as their default gateway, traffic from the clients to another subnet were sent to the 2800 and I was able to monitor that traffic by exporting all traffic to a dummy port connected to an IDS. However, switches don't use RITE, as it is a concept applicable only on routers. They are able to use port mirroring, but such a configuration has to be done on every port, and there can be some performance degradation if done on a large number of ports.

My solution involved a hybrid of these two concepts:

     interface FastEthernet0/1
         switchport access vlan 100
         switchport mode access
         spanning-tree portfast
     !
     interface FastEthernet0/2
         switchport access vlan 100
         switchport mode access
         spanning-tree portfast
     !
     interface FastEthernet0/3
         no switchport
         ip address 192.168.0.1 255.255.255.0
         spanning-tree portfast
     !
     interface Vlan100
         ip address 172.16.0.1 255.255.0.0
     !
     ip route 0.0.0.0 0.0.0.0 192.168.0.2
     !
     monitor session 1 source interface Fa0/3
     monitor session 1 destination interface Fa0/4

This solution allowed me to take all traffic from VLAN 100, and route it through a single non-switchport interface, namely Fa0/3. In addition, at the end of the config you can see that I'm copying all traffic from both directions to Fa0/4 - this is where my laptop's plugged in, running Wireshark. This allows me to see every packet being routed out of the entire VLAN 100.

I then set up a few routers on the 172.16.0.0/16 network as clients and started some ping traffic on each to a host on the 192.168.0.0/24 network:

[![](/assets/2011/08/packetscreenshot.png)](/assets/2011/08/packetscreenshot.png)

So why is this configuration necessary? Let me rephrase that. Why do we have to sacrifice a physical switchport in order to do monitoring (two if you count the monitor port too)?
    
    SW1(config)#monitor session 1 source interface vlan 100
                                                   ^
    % Invalid input detected at '^' marker.
    
    SW1(config)#

You cannot perform port mirroring on SVIs. Since this is the default gateway interface for the 172.16.0.0/16 subnet, it represents an optimal place to do monitoring - however, we cannot, so we must route traffic to a physical interface and monitor it there. As a result, this configuration can not apply to the new layer 3 capabilities on the Catalyst 2960's, because you cannot apply the "no switchport" command on that platform.

So we've seen that you have to use a physical port for monitoring- however, you end up with a configuration where you don't have to keep performing monitoring configurations on each switchport, just add them to the VLAN you're performing monitoring on, and whenever traffic is routed out of that VLAN, it's copied to the monitoring port.
