---
layout: post
title: Spanning-tree Requirements for Cisco ISSU
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2012-09-19"
wordpress_id: 2458
slug: spanning-tree-requirements-for-cisco-issu
tags: ['catalyst']
---


I had a great conversation with a coworker regarding the requirements for the In-Service Software Upgrade (ISSU) feature on Cisco switches. For this post, I'm using Nexus 5548UP switches as a distribution layer to my Cisco UCS environment, and at the core is sitting a pair of Catalyst 6500s, set up in a [VSS pair](https://keepingitclassless.net/2011/10/virtual-switching-system-on-cisco-catalyst-6500/).

[![](/assets/2012/09/diagram2.png)](/assets/2012/09/diagram2.png)

For those unfamiliar with ISSU, it is a way for Cisco devices to upgrade their running firmware without the need for a disruptive reboot of the device, which is what has traditionally been used for upgrades to IOS, NX-OS, etc. This is obviously a good thing, since it eliminates the need to bring a switch down, which could be disruptive to network availability, either through the reduced bandwidth of what's usually an active/active setup, or (and more painfully) by revealing bad design or configuration that results in something being hard down during the upgrade (i.e. something that was not dual-homed appropriately)

However, ISSU has some requirements:
1. No Topology change must be active in any STP instance
2. Bridge assurance(BA) should not be active on any port (except MCT)
3. There should not be any Non Edge Designated Forwarding port (except MCT)
4. ISSU criteria must be met on the VPC Peer Switch as well

That list is generated when you run:

    show spanning-tree issu-impact

That command also runs through each item, and ensure the spanning-tree configuration validates for an ISSU.

Number one is fairly easy to validate. This will pass as long as your network isn't actively going through a topology change. It is common that a pair of 5Ks are set up in a vPC domain, and everything is dual-homed off of the vPC domain, so topology changes are extremely rare, if they occur at all.

Number two is also pretty straightforward. MCT stands for Multichassis Etherchannel Trunk, or more specifically known in a vPC design, the peer-link. Essentially this means that bridge assurance (BA) can't be configured anywhere except the peer-link. Bridge assurance is very similar to Unidirectional Link Detection (UDLD) in that it listens for the presence of BPDUs on a link. If BPDUs suddenly stop, it could indicate a failure to maintain a loop-free topology, and will put the link into a spanning tree inconsistent state, blocking the link and preventing a switching loop.

Number three is what got me, and likely what would get most engineers. Spanning tree has a mode called portfast, and in the newer (relatively speaking) spanning tree mode Rapid STP, they are called "edge ports". This prevents the ports from cycling through the various spanning-tree states, and simply begins forwarding traffic immediately.

This checks for the presence of designated ports that have not been configured as edge ports. This does not include root or blocked ports, so no edge configuration is needed for interfaces facing the spanning-tree root, which in my case is a pair of 6500s.

My UCS environment is set up in end-host mode, which causes the fabric interconnects to act like one big host NIC, so frames are not bridged between the ports on the device, they are forwarded on to their destination in a way where loops are not possible. The connectivity to UCS is accomplished using two vPCs, which is inherently loop-free because of the way spanning-tree works.

## Matt's View

All that to say, is it worth it? Since it is technically feasible to convert all downstream ports to edge ports, wouldn't this be worth doing in order to be able to perform upgrades without downtime?

Well, consider this. Spanning tree, though an aged technology to be sure, is there for a reason. It is and will continue to be in networking certification curricula for a long time. Why? Quite simply, it is the safety net against bad topologies. In the event of a bad cabling change, or a configuration change, or a failure that disables the loop-free capabilities of vPC or other MCE technologies, spanning-tree will help prevent a bad situation from getting worse.

That said, some environments simply can't take the bandwidth hit of taking down one side of a pair of switches. In many cases, this could represent a design that didn't account for the bandwidth requirements, but this does happen. As a result, ISSU may not be a matter of convenience, but simply a matter of preserving the overall bandwidth needed by the underlying server infrastructure.

That said, [it is a Cisco recommendation](http://www.cisco.com/en/US/prod/collateral/switches/ps9441/ps9402/white_paper_c11-623265.html) to use a port type of "edge trunk" when connecting a Nexus device to a UCS fabric interconnect, when those interconnects are in Ethernet end-host mode. This is so that traffic can immediately begin forwarding on the interconects when a device is brought up.

When making the decision to explore the possibility of ISSU, weigh carefully the impact of enabling edge ports  in your environment, and make the decision based completely around the requirements for the services that are using the network. There's a chance that a disruptive upgrade is perfectly fine.

## Links

* [ISSU overview](http://www.cisco.com/en/US/products/ps7149/products_ios_protocol_group_home.html)
* [Cisco's Nexus 5000 Upgrade/Downgrade Guide](http://www.cisco.com/en/US/docs/switches/datacenter/nexus5000/sw/upgrade/503_N1_1/n5k_upgrade_downgrade_503.html)
