---
layout: post
title: What's New in vSphere 5.1 Networking
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-08-28"
wordpress_id: 2369
slug: whats-new-in-vsphere-51-networking
tags: ['1000v']
---


I attended the VMworld 2012 session that covered the new features in vSphere 5.1 with regards to networking. Many features were rolled out to both VDS and the standard switch, and other features just had improved functionality.

First off, apparently it's now VDS, not vDS. This announcement came hours after the announcement that VXLAN was being changed to vXLAN. Um...okay, I guess?

Anyways - The speaker pointed out at the beginning that a big change was that many of these features were being rolled out to both the standard and distributed switches. Many of these advanced networking features are typically only applied to the VDS, so this was a welcome change.

He overviewed virtual distributed switching - centralized control plane, but packet switching is still local to each host. No changes here. You add a host to the VDS, and all configurations get pushed to each added host from vCenter. One datacenter-wide switch to manage. This all holds true to both the 1000v and the VMware VDS.

He touched on VXLAN, and that it is supported in the current and future versions of the VDS. Not much here, he pointed out that there were other sessions that dived deep into VXLAN. However, he did point out that VXLAN helps overcome the 4000 VLAN limitation in big implementations where 4000 may not be enough. I will be attending a deep-dive on VXLAN later today.

The enhancements in 5.1 focus on four key areas:

  * Managability	
  * Performance and Scale
  * Visbility and Troubleshooting
  * Security

## Network Health Check

The first tool that was talked about was this idea of a Network Health Check. This detects common configuration errors at the physical-virtual boundary such as MTU or VLAN misconfigurations, or problems with teaming/port channels, such as wrong hashing mechanisms being used. He did not explore the way that any of this worked, just that it worked. I would be extremely interested in seeing how these tests work, although it seemed to work pretty well in his demo.

## Config Backup

Currently, in version 5.0, we can't recover the VDS from vCenter's database due to corruption or bad configuration. We also can't replicate or publish the configuration to do proper config backups or use the configuration to consistently set up the VDS in various environments.

In 5.1, you can now take a snapshot of the current vDS configuration. You can right-click on the datacenter and essentially import a distributed switch.

## Automatic rollback

If you were to make a change that broke management connectivity to your hosts, you would currently have to restore the standard vSwitch on each host to even get to the point where you can restore the configuration. This has been a big reason why many orgs haven't gone to VDS or 1000v.

I have always recommended by default that the management not be placed in the VDS or 1000v. By doing so, you're not gaining anything by doing so, and you run into things like this. Most of the time, management doesn't NEED to be in the VDS or 1000v.

In vSphere 5.1, by default, the system will now roll back to the previous configuration if it detects a connectivity loss for more than 30 seconds. This is extremely useful if you do have management in the VDS.

He made a good point at the end of this - if you make a local change on the ESXi host, to fix a problem or not, ensure that you resync vCenter with ESXi. Otherwise, vCenter will be unaware of the change you applied at a host level.

## LACP

VMware has FINALLY implemented LACP support in vSphere 5.1

Why have we asked for this? Well, for one, any link failures can be picked up instantly by both ends of the port channel. This also helps with misconfigurations, and is likely the mechanism by which many of the new health check features are able to detect problems, such as mismatched hashing algorithms. Also, a static etherchannel can cause issues during PXE boot process.

There are some limitations. First, only IP hashing is supported.  In addition, you can only have one LACP group per VDS, and only one LACP group per host.

## BPDU Filter

Virtual switches don't run the Spanning Tree Protocol, so they don't generate BPDUs. If they receive them, they just drop them. Best practice is to turn on portfast and BPDUguard at the physical switch. This is the boundary of the spanning tree domain (as it should be). This prevents BPDUs from making their way into the virtual environment, and it ensures that no VM is sending BPDUs.

With this configuration, if a VM for whatever reason starts sending BPDUs, the uplinks will get blocked because of BPDU Guard. The VM will be moved from uplink to uplink and host to host, and all will be disabled because of the BPDUguard configuration at the switch.

BPDUs can be filtered at the vSwitch/vDS level in vSphere 5.1. This prevents the "DoS" attack of bringing down all the uplinks, but still doesn't stop any potential bridging loops. This basically just makes sure BPDUs don't get to the uplinks. Good, but not best.

In my opinion, this should eventually include BPDUguard, so that downstream ports can block the offending VM, effectively restricting that which is the problem. No reason to simply filter the BPDUs, though it does prevent the uplinks from going err-disabled at the switch level, but if my VMs are sending BPDUs, something is seriously wrong. I want my virtual environment to block those VMs right away and notify me. VMware, I really appreciate the fact that you're rolling these features out, it's a great start. In 5.2 or 6.0 or whatever, consider giving us the ability to block VM ports using functionality like BPDUguard.

## Monitoring

In vSphere 5.1, SNMP/RSPAN/ERSPAN have all been implemented, and Netflow support has been updated to v10. To be honest, this is nice but I've been spoiled by the 1000v, which already supports the majority of these features. However, it's nice to know that these are now available to customers that don't dish out for the 1000v.

## Scale

The capabilities of the VDS have nearly doubled:
<table style="width: 100%; border: 1px solid black;"> 

<tr style="background-color: lightgray;">
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">VDS PROPERTIES</td>
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">5.0 LIMIT</td>
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">5.1 LIMIT</td>
</tr>

<tbody >
<tr >

<td style="border: 1px solid black;">Number of VDS per vCenter Server
</td>

<td style="border: 1px solid black;" >32
</td>

<td style="border: 1px solid black;" >128
</td>
</tr>
<tr >

<td style="border: 1px solid black;" >Number of Static Port Groups per vCenter Server
</td>

<td style="border: 1px solid black;" >5,000
</td>

<td style="border: 1px solid black;" >10,000
</td>
</tr>
<tr >

<td style="border: 1px solid black;" >Number of Distributed Ports per vCenter Server
</td>

<td style="border: 1px solid black;" >30,000
</td>

<td style="border: 1px solid black;" >60,000
</td>
</tr>
<tr >

<td style="border: 1px solid black;" >Number of Hosts per VDS
</td>

<td style="border: 1px solid black;" >350
</td>

<td style="border: 1px solid black;" >500
</td>
</tr>
</tbody>
</table>
From: [What's New in VMware vSphere® 5.1](http://www.vmware.com/files/pdf/techpaper/Whats-New-VMware-vSphere-51-Performance-Technical-Whitepaper.pdf) - page 12

## Elastic port groups

Port groups now shrink/expand dynamically based on use. You should use static port groups, this is enabled by default, and is the best utilization of ports on a host. Dynamic is going away, and should not be used.

## Netdump

This helps dump vmkernel core to a server on the network. Very useful when esxi has no local storage. I install a lot of Cisco UCS, and I'll admit that most installs still have local storage, but this is a nice feature to have going into 5.1, where boot-from-SAN and Autodeploy are gathering more popularity.

Which features are you most excited about? I would like to do a deep-dive into one of these sections when I can get all of this set up in a lab - what would you like to see? Let me know in the comments, [or on twitter](https://twitter.com/mierdin).
