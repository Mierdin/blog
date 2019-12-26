---
layout: post
title: Cisco UCS vNIC Switchport Mode
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2013-07-23"
wordpress_id: 4231
slug: cisco-ucs-vnic-switchport-mode
tags: ['cisco']
---


I wrote [an article](https://oswalt.dev/2012/05/management-vlan-best-practices-in-esxi-and-cisco-ucs/) a while back regarding VLAN configuration when running vSphere ESXi on top of Cisco UCS.

A comment pointed out that all vNICs are automatically configured as trunks. I had not heard of this before, so I got into the CLI to take a look.

Here's a VLAN configuration screen in the UCSM GUI for a sample vNIC:

[![ucs_vlan](/assets/2013/07/ucs_vlan.png)](/assets/2013/07/ucs_vlan.png)

Check out the running configuration for this vNIC on the underlying NX-OS CLI.

    UCS-FI-A(nxos)# show run int veth782
    interface Vethernet782
      description server 1/7, VNIC BARE-IPST-PROD-A
      switchport mode trunk
      untagged cos 2
      no pinning server sticky
      pinning server pinning-failure link-down
      no cdp enable
      switchport trunk allowed vlan 370
      bind interface port-channel1290 channel 782
      service-policy type queuing input org-root/org-root/ep-qos-Silver
      no shutdown

As you can see, even though we have a single VLAN checked in the GUI, the vNIC is still a VLAN trunk, and simply prunes all other VLANs off of the trunk.

This also means...
    
    UCS-FI-A(nxos)# show int veth782 sw
    Name: Vethernet782
      Switchport: Enabled
      Switchport Monitor: Not enabled 
      Operational Mode: trunk
      Access Mode VLAN: 1 (default)
      Trunking Native Mode VLAN: 1 (default)
      Trunking VLANs Enabled: 370
      Administrative private-vlan primary host-association: none
      Administrative private-vlan secondary host-association: none
      Administrative private-vlan primary mapping: none
      Administrative private-vlan secondary mapping: none
      Administrative private-vlan trunk native VLAN: none
      Administrative private-vlan trunk encapsulation: dot1q
      Administrative private-vlan trunk normal VLANs: none
      Administrative private-vlan trunk private VLANs: none
      Operational private-vlan: none
      Unknown unicast blocked: disabled
      Unknown multicast blocked: disabled

the native VLAN for this vNIC is still 1, UNLESS you select one of the radio buttons.

You know....in case you haven't learned to double-check the underlying configuration when in doubt. Took me a while to learn that lesson.
