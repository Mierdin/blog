---
layout: post
title: vSphere Network Security Policies
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-02-11"
wordpress_id: 2918
slug: vsphere-network-security-policies
tags: ['nexus']
---


The idea of security in a vSphere vSwitch is a concept not usually discussed in vSphere peer groups or curricula. They are somewhat specialized features that are normally either not used, or irrelevant due to the presence of another switching architecture  such as the vDS (including the Cisco Nexus 1000v) or VM-FEX, where these policies also exist and are much more feature-rich. Thus, the idea of performing these functions on a native vSwitch is usually not talked about. I'd like to briefly explain each feature and talk about situations in which you may or may not use them.

## Inheritance

All security policies can be defined at either the vSwitch itself, or the subordinate port groups. By default, a port group will inherit the value configured at the vSwitch, but can also be manually configured to override this default behavior. The default for all policies is "reject", meaning that you have to explicitly enable these policies on either object before you can use their features.

## Promiscuous Mode

This mode is essentially the same as setting up a port mirroring session on a physical switch. All traffic that occurs on the switch is copied to the port groups that are configured in "promiscuous mode", regardless of where the traffic was sourced or destined.

[![screen1](/assets/2013/02/screen1.png)](/assets/2013/02/screen1.png)

This is a great way to set up a virtual IDS, as long as the systems being monitored are on the same vSwitch as the IDS, since this policy does not span multiple vSwitches.

By the way, this concept applies to port groups, vmkernel interfaces, and (if you haven't upgraded in a while) service console interfaces.

Finally, it should be stated that [the Cisco Nexus 1000v provides this functionality using ERSPAN](http://www.cisco.com/en/US/docs/switches/datacenter/nexus1000/sw/4_0_4_s_v_1_3/system_management/configuration/guide/n1000v_system_9span.html), which takes mirrored traffic and wraps it in a tunnel that is then sent to the routed destination of your choosing. This is definitely preferable, because it doesn't require that you have a VM on each vSwitch in your environment to do IDS captures - you can simply SPAN all traffic to a physical device like a physical Nexus switch.

It is also a configuration you'll need to make if you're running [nested ESXi](http://www.yellow-bricks.com/2012/06/12/creating-a-nested-lab/).

## Forged Transmits

This is a pretty easy one - when a typical machine (physical or virtual) boots up, it looks for the burned-in address of it's NIC(s), and assumes them. While it's true that nearly every operating system is capable of sending traffic using any addressing information it wants, it's a decent practice to respect the burned-in MAC address of the hardware being presented. In a vSphere environment, the hardware may be virtualized, but it's still presented to the OS the same way, with a "burned-in" MAC address.

[![screen2](/assets/2013/02/screen2.png)](/assets/2013/02/screen2.png)

[![screen3](/assets/2013/02/screen3.png)](/assets/2013/02/screen3.png)

This policy - when set to "Reject", means that the underlying OS will be restricted from sending traffic using a source address other than the one that vSphere suggested to it. Setting this to "Accept" disables this restriction.

## MAC Address Changes

This is commonly confused with "Forged Transmits", and the effect is the same, except that when you set this policy to "Accept", you are permitted to change the MAC address in vSphere from within the guest OS itself.

For more information on vSphere security, see the VMware documentation:

[http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.networking.doc%2FGUID-74E2059A-CC5E-4B06-81B5-3881C80E46CE.html](http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.networking.doc%2FGUID-74E2059A-CC5E-4B06-81B5-3881C80E46CE.html)
