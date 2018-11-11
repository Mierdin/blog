---
layout: post
title: '[CCIE] Spanning-Tree Part 1 - Nerd Knobs'
author: Matt Oswalt
comments: true
categories: ['My', 'CCIE', 'Journey']
date: "2013-06-27"
wordpress_id: 4099
slug: ccie-spanning-tree-part-1-nerd-knobs
tags: ['ccie']
---


I wrote this post not only to put out some information on one of the least-understood facets of networking (especially in data center, as most technology today is aimed at making STP irrelevant) but also to help get something on paper for me, seeing as I am going down the CCIE path full force now, and this has always been a weak area of mine. This post will assume you have CCNP-level knowledge about Spanning Tree Protocol (STP).  It will also not explore the basics of 802.1D STP as a traditional form of the protocol. This post will explore some of the enhancements and features you'll need to learn (some for the first time) in order to pass the CCIE R/S Written Exam. Hope this post aids you in your quest for numbers!

## Topology Changes

Topology changes can take place on a switched LAN any number of ways. With respect to spanning tree, this means the consistent receipt of BPDUs has changed or ceased, or a direct link failure was observed. In either case, the switch that observes the failure sends out it's own BPDU out it's root port with the "TCN" bit set. These TCN BPDUs are aimed at notifying the root bridge that a topology change has occurred - this drives faster reconvergence. Each bridge sends these TCN BPDUs up the tree (once every hello time) until it is acknowledged by the bridge above it. Eventually, the root learns of this topology change and sets the TC flag on the next several hellos that it sends out, which notifies the entire tree that a change has occurred. All switches that hear this BPDU uses the short timer (equivalent to Forward Delay) to time out all CAM entries, and places previously blocked ports into the listening state to once again determine if there are loops.

## Advanced Features

These STP features (some of which are Cisco proprietary) are actually not too difficult to configure (usually one-liners), but can be a little dicey when it come to conceptualizing their operation. Let's do a little exploration of each.

**PortFast** - This is a pretty well-known feature but also widely used. This is enabled on an interface to essentially disable spanning-tree on the interface. If the interface is up, then it is forwarding. PortFast interfaces bypass the listening and learning states. Obviously this means you should only enable this feature on interfaces that you know won't cause loops.

> On a Cisco switch, PortFast can be enabled on a per-interface basis, or globally on the switch.

**UplinkFast** - This  is primarily used for enhancing convergence time when there are uplink failures on the access layer switches. Good design dictates that these should not be spanning-tree root switches, or be used to get to the root. The access layer is the "end of the line" (or beginning, depending on where you started). So, in order to converge quickly when an uplink fails, UplinkFast will increase the root priority to 49,152 (very undesirable as priorities go), and it will set all port costs to 3000. Both of these will help prevent it from being used as a transit switch, or the root bridge itself. It will also track alternate root ports (similar to RSTP), which are ports that were blocked because they were redundant, less preferable paths to the root, but still viable. So, if the primary path goes down, the secondary path can be brought up immediately. Finally, UplinkFast will flood a multicast frame for every MAC address in it's CAM table, with each MAC as the source address of the frame, so that all other switches in the topology update their CAM tables immediately.

> UplinkFast is configured globally on a switch.

**BackboneFast-** This tool is all about _indirect_ link failure. (When a direct link failures occurs, the Max Age timer is essentially irrelevant, since the switch knows a failure happened right away.) However, if a failure produces no link-down event, and other switches don't send a TCN BPDU to the root for whatever reason, then each switch has to age out the old BPDUs before it knows anything happened (by default, 20 seconds). BackboneFast solves this problem by using something called a RLQ or Root Link Query.

An RLQ is sent to the upstream switch (meaning the port used to get there was/is a root port) when one BPDU is missed, on the link where the BPDU was expected. This RLQ is aimed at asking the upstream switch if a link-down event was detected. If it was, then the switch experiencing the indirect failure is notified using another RLQ, and does not need to wait for the Max Age timer to expire.

BackboneFast is configured globally on a switch, and must be configured on every switch in the topology in order to work properly, since it works on a request/response basis from switch-to-switch.

## Protecting the Spanning Tree

There are also some additional STP features that are used to help protect the logical topology from doing things that it shouldn't. We'll explore these below:

**BPDUGuard** - this is pretty simple. Let's say you've configured an interface for PortFast, and you're worried that someone is going to plug in their own little managed switch and cause issues for you, the administrator. You can enable BPDUGuard on any interface, and if a BPDU is received, then that interface disables itself (the status becomes err-disabled). You can shut/no shut to bring the port back up (after a stern lecture at the offender, for sure) or you can configure err-disable timers globally on the switch that allow err-disabled ports to come back online after a certain period of time.

**BPDUFilter** - this is similar to BPDUGuard but without disabling the port. This feature simply drops all BPDUs that enter the port, and it also prohibits the switch from sending BPDUs out that port.

**Root Guard** - this feature allows you to ensure that superior BPDUs from a root bridge are only received on ports you desire. For instance, if you know that a port is connected to an access switch, which should never be a root bridge, then you can enable root guard on that port to ensure that the port will never become a root port. If a superior BPDU is received on a root port, then that port is placed in a root-inconsistent state, and begins discarding traffic, but continues to relay BPDUs, much like a port in the discarding/blocking state. Unlike BPDUGuard, such a port can re-enable itself and does so after it is no longer receiving superior BPDUs.

**UDLD (Unidirectional Link Detection)** - with copper-based cables, the incidence of unidirectional traffic flows due to specific pin failures is quite low. However, when fiber is used, the likelihood is much higher, since they are not as durable, and generally more prone to breaks because of cable kinks, etc. If a fiber cable has one of it's strands break, but the other strand still works, then a switchport may transition out of blocking and into forwarding when it shouldn't. If the receive strand on a switchport breaks, then BPDUs will no longer be received and the switchport will think that it is now able to bring the switchport up without loops. However, the transmit side is still active, and a loop will be created in that direction when the port begins forwarding.

UDLD operates in two modes. In traditional UDLD mode, the switchport will detect the loss of BPDUs and use Layer 2 messaging to decide when a partial link failure has happened. If a unidirectional failure is detected, normal mode will not disable the port, but will generate a syslog message to be acted upon by an administrator, and label the port as "undetermined".

UDLD can also operate in aggressive mode, whereas the switch detecting a possible failure sends 8 messages to the other switch, and if it does not receive a response, this port is placed into err-disabled state.

UDLD is aimed at solving a problem most prevalent with fiber optic cabling. As a result, it is not enabled for switchports with copper cabling (i.e. Cat6), though it can be enabled in some cases. When configuring UDLD globally, it can only apply to fiber-optic ports.

**Loop Guard** - this is aimed at solving the same problem, but it does so in a little bit different way. It detects the loss of BPDUs on blocked links and will disable that link on a per-VLAN basis if this happens. See the table below, taken from [Cisco's site](http://www.cisco.com/en/US/tech/tk389/tk621/technologies_tech_note09186a0080094640.shtml), for the main differences between the two.

<table cellpadding="3" width="100%" cellspacing="1" border="3" bgcolor="#F0F0F0" >
<tbody >
<tr >
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">Functionality</td>
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">Loop Guard</td>
<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" style="font-weight:bold">UDLD</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Configuration
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Per-port or Globally
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Per-port or Globally (global only applies to Fibre Optic Ports)
</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Action granularity
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Per-VLAN
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Per-port
</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Autorecover
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes, with err-disable timeout feature
</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Protection against STP failures caused by unidirectional links
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes, when enabled on all root and alternate ports in redundant topology
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes, when enabled on all links in redundant topology
</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Protection against STP failures caused by problems in the software (designated switch does not send BPDU)
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >No
</td>
</tr>
<tr >

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Protection against miswiring.
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >No
</td>

<td height="" colspan="1" rowspan="1" width="" bgcolor="#FFFFFF" >Yes
</td>
</tr>
</tbody>
</table>


I have also posted a video on pretty much all of what this post has explored, and I welcome constructive feedback as I am not only trying to get back into the screencasting stuff but also I'm learning this material as I go.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/ctUCkXm_k88" frameborder="0" allowfullscreen></iframe></div>

You may have wondered why I've gone on and on about Layer 2 logical configuration and haven't said anything about port security. While port security can be a very useful tool in protecting the L2 topology, it is another topic entirely and is best kept for another post.
