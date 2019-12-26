---
layout: post
title: Management VLAN Best Practices in ESXi and Cisco UCS
author: Matt Oswalt
comments: true
categories: ['Virtualization']
date: "2012-05-01"
wordpress_id: 2186
slug: management-vlan-best-practices-in-esxi-and-cisco-ucs
tags: ['cisco']
---


If you've set up an ESXi host, you've likely seen this screen:

[![](/assets/2012/05/screen1.png)](/assets/2012/05/screen1.png)

This allows you to configure which VLAN is used for management. But what does this really **do?** Time after time I run into very smart engineers that primarily work on virtualization and not as much on the physical networking side - and they miss a few of the networking fundamentals that those of us that were brought up in ROUTE/SWITCH know and love.

Most immediately say that a VLAN trunk is an interface that allows multiple VLANs. In order to set the mood for the article, I'd like to start by offering my official definition for a VLAN trunk.

A VLAN trunk is an interface that allows frames in that have an 802.1q tag on them, and does not strip this tag on frames leaving the interface.

This is the truest definition for a VLAN trunk I can offer. For instance, an access port will strip the 802.1q tag normally on a frame, because most PCs don't recognize this tag and will drop a tagged frame by nature. A trunk can certainly allow multiple VLANs - most do. However, it doesn't have to. Take a look at the following Cisco config:
    
    switch(config-int)# switchport mode trunk
    switch(config-int)# switchport trunk allowed vlan 50
    switch(config-int)# switchport trunk native vlan 50

This interface is absolutely a trunk. If you run "show int trunk" it will show up. By definition, all frames that come in without an 802.1q tag will be placed in VLAN 50. According to our definition, this interface is still a trunk - tagged frames will be sent and received from this interface. However, it's just allowing the single VLAN (50). Only frames in VLAN 50 will leave the interface, and only frames tagged with that VLAN will be allowed to enter, all other tagged frames will be dropped.

This is an important concept to understand, even when configuring something as simple as ESXi management. Again, lets look at the VLAN configuration page for ESXi:

[![](/assets/2012/05/screen1.png)](/assets/2012/05/screen1.png)

Many times, a virtualization engineer will hear from their ROUTE/SWITCH counterpart that "the ESXi management VLAN is 2148" - and this language immediately becomes scripture. Without even thinking of what this configuration actually produces on the "wire", they set the management VLAN here because that's what the management VLAN is.

Setting this option in ESXi (and it is optional - for a reason) will do one very important thing. Very similar to a Cisco switch trunk port, it will simply insert an 802.1q tag in all management traffic. Our management vmkernel port is now, by strict definition, a trunk - one that allows only VLAN 2138.

Is this best practice? I'm doing this in a UCS blade but the same applies for physical servers that are plugged in to a physical switchport. In my case, the UCS vNICs are the "switchports" for our host, and the VLAN configuration is changed here.

[![center](/assets/2012/05/screen5n.png)](/assets/2012/05/screen5n.png)

When setting the VLAN tag as shown previously, the above config will not work. Doing this essentially places the vNIC into "access mode". Remember that we are sending tagged frames from the ESXi host now, and access ports by nature drop all tagged frames. Thus, we will not be able to connect to our host. In order to make this work, you can do one of three things.

> EDIT: This statement is actually not entirely true. I recommend checking out [a more recent post](https://oswalt.dev/2013/07/cisco-ucs-vnic-switchport-mode/) of mine that explains the trunk nature of UCS vNICs.

The first option is to select another VLAN. It can be a dummy VLAN, or another management VLAN you wish to expose to that interface on the ESXi host. It's not uncommon to use the main vSwitch for other network connectivity purposes besides management, so this is a viable option.

[![](/assets/2012/05/screen3.png)](/assets/2012/05/screen3.png)

The second option is to unset the VLAN ID in ESXi.

[![](/assets/2012/05/screen2.png)](/assets/2012/05/screen2.png)Doing this will require you to configure the UCS vNICs as an access port. The configuration shown previously where only one VLAN is selected will accomplish this. This is my personal preference, since it doesn't require any VLAN tagging, and it's pretty simple to implement. I typically have vNICs allocated to management and only management, so I don't mind restricting this to a single VLAN. Understandably, this becomes more difficult with physical NICs that are limited in quantity, so the first option may be preferred there.

The third option is something I stumbled across when exploring the other options. You can keep the VLAN "not set" in ESXi but configure the UCS vNIC as a trunk that only allows that VLAN, similar to the Cisco switchport config shown earlier.

[![](/assets/2012/05/screen4.png)](/assets/2012/05/screen4.png)

Remember that the native VLAN is where untagged frames that enter a trunk are placed. This will take the frames that enter from the ESXi host - untagged - and place them into VLAN 2148 as intended.

This is one of those cases where bridging the gap between the network and the server is crucial - this doesn't just apply to simple management traffic, it represents a unified understanding of Datacenter as a whole, including both networking and virtualization, not either one by themselves.
