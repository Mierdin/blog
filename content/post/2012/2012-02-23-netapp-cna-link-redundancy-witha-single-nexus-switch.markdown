---
layout: post
title: Netapp CNA Link Redundancy with a Single Nexus Switch
author: Matt Oswalt
comments: true
categories: ['Storage']
date: "2012-02-23"
wordpress_id: 1984
slug: netapp-cna-link-redundancy-witha-single-nexus-switch
tags: ['FCoE']
---


I ran into a configuration recently where I had a Netapp storage array with the UTA cards installed, so there two CNA ports on each filer for a total of 4 ports. However, instead of a dual-switch design, there was only a single Nexus 5000, and therefore, no vPC configuration. I needed to achieve some level of redundancy on an interface level, but ran into some problems which I'll discuss.

My topology looks like this:

[![](/assets/2012/02/topology3.png)](/assets/2012/02/topology3.png)

As you can see, there's only one Nexus 5K, shown at the bottom. The two Netapp FAS3240 filers are connected via each Converged Network Adapter to a different Ethernet port on the Nexus.

Normally, e1a and e1b on each filer would be configured in a LACP ifgrp (essentially a port-channel for all you fellow networkers), which would be split over two Nexus switches in a vPC configuration. Unfortunately, since we have only one Nexus switch, we arent running vPC so we cannot do this.

The Netapp filer CNAs are used for running FCoE, which means that vFC (Virtual Fibre Channel) interfaces are required on the Nexus switch. These vFCs are bound to the port that will be carrying FCoE traffic and will provide a bridge from the Ethernet network to the Fibre Channel functionality of the switch.

In a normal dual-switch design with vPC, you'd bind it to the port-channel on the switch that's participating in the vPC domain:

    interface port-channel2
     switchport mode trunk
     speed 10000
     vpc 2

    interface vfc4
     bind interface port-channel2
     no shutdown

However, in this design, we have only one Nexus 5K. Under normal circumstances, I would expect that I could still use a port channel and bind the vFC to it in this way, the only difference is that "port-channel 2" has more than one link as a member instead of one, which is in a vPC configuration. Either way, the configuration above should hold true.

Not so, my faithful reader. When you use this configuration and the members of the port channel are plugged into the same switch, the vFC will NOT log in to the SAN (try "show flogi database"). The way the vFCs are supposed to work, if there's more than one link being bound to a vFC using a port channel like shown above, the vFC will not come up, meaning that your target adapters will be unable to log in to the SAN.

## Non-Preferred Solution

I'm running both FCoE and NFS on these adapters, which is a common configuration. I'm not allowed to aggregate these links in a port channel, since the act of binding a vFC to a port channel with multiple links in it will cause this problem, however I could just break the ifgrp on the Netapp side and simply run two independent links on each filer. I would have a total of 4 WWPNs and 4 NFS IP addresses.

I don't believe there's any sort of reliable NFS multipathing solution as of yet, which means that if you have a failure, you have to redirect your VMware (and anything else that uses NFS) traffic to a new datastore, mounted using the other IP address. Not exactly ideal. So if you're using NFS, this is not the design for you.


## Preferred Solution

I was directed to a different ifgrp configuration on the Netapp side by a colleague, and I found that it works extremely well in this situation. There are a few options when running the "ifgrp" command. Using the "lacp" command sets up a port channel and uses LACP for negotiation. The "multi" keyword will do the same, only it will disable the use of a negotiation protocol.

There is a third option that often goes unnoticed, and that is the "single" keyword. This will  still set up an ifgrp, meaning that the links are bundled together on the Netapp side, but it will act in an active/passive manner. The following commands will set this up, and I've also shown that you can still perform configurations directly on the VIF. This could be a valid configuration for setting up a VIF for say, NFS, while provisioning two other VLANs for management and FCoE.
    
    ifgrp create single internal -b ip e1a e1b
    vlan create test 10 20 30
    ifconfig test-20 192.168.0.5 netmask 255.255.255.0 mtusize 9000 partner 192.168.0.6

This will allow you to set up the Nexus side as simple ethernet ports. No port-channels, just regular switchports. The VFCs are then tied to each port on a one-to-one basis, meaning we have four VFCs:

    interface vfc2
      bind interface Ethernet1/15
      no shutdown

    interface vfc3
      bind interface Ethernet1/16
      no shutdown

    interface vfc4
      bind interface Ethernet1/17
      no shutdown

    interface vfc5
      bind interface Ethernet1/19
      no shutdown

Both this design and the design I talked about in the last section are virtually the same from a FCoE perspective, since every port is active with a unique WWPN. Your FC zoning takes care of making sure the servers have access to each port. Something to think about.

Finally, take all of this with a grain of salt. I know that my circumstances did not allow me to use a dual-nexus design so I was absolutely forced to make it work like this. These are not cheap switches - if someone's buying one they're likely supporting something important enough to warrant two. A design using vPC is not only more stable, but more supportable, and to be blatantly honest, more googleable. I wrote this article so that those in my place would have a possible solution if they're forced to make this work.
