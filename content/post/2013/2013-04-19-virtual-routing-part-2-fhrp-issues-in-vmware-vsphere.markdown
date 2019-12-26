---
layout: post
title: '[Virtual Routing] Part 2 - FHRP Issues in VMware vSphere'
series:
- Virtual Routing
author: Matt Oswalt
comments: true
categories: ['Virtual', 'Networking']
date: "2013-04-19"
wordpress_id: 3510
slug: virtual-routing-part-2-fhrp-issues-in-vmware-vsphere
tags: ['csr1000v']
---


I was working on a topology for another post regarding interoperability between the recently released [Cisco Cloud Services Router (CSR 1000v)](https://oswalt.dev/2013/04/virtual-routing-part-1-csr-1000v-first-glance/) and Vyatta when I ran into an issue regarding vSphere network security policies and First Hop Redundancy Procotols (FHRP) such as VRRP.

This post will serve as a precursor to that overall post, but I want to point out a key configuration piece when performing redundant gateways with a FHRP like VRRP.

This lab topology is very much a work in progress (note the cross-over cable between the two hosts) and will change as my research for the next post continues, but the point I'm trying to get across does not require an elaborate setup. Observe:

[![Simple Lab Topology](/assets/2013/04/CSR2screen1.png)](/assets/2013/04/CSR2screen1.png)

So I configured the two routers in the manner shown above - a simple VRRP group with the priority set on the CSR so that it fulfilled the role of "master":

(CSR)

    CSR-1KV-A#show vrrp
    GigabitEthernet2 - Group 1  
      State is Master
      Virtual IP address is 192.168.123.1
      Virtual MAC address is 0000.5e00.0101
      Advertisement interval is 1.000 sec
      Preemption enabled
      Priority is 110 
      Master Router is 192.168.123.2 (local), priority is 110 
      Master Advertisement interval is 1.000 sec
      Master Down interval is 3.570 sec

(Vyatta)
    
    vyatta@vyatta:~$ show vrrp det
    --------------------------------------------------
    Interface: eth1
    --------------
      Group: 1
      ----------
      State:                        BACKUP
      Last transition:              12h47m48s
    
      Master router:                192.168.123.2
      Master priority:              110
    
      RFC 3768 Compliant
      Virtual MAC interface:        eth1v1
      Address Owner:                no
    
      Source Address:               192.168.123.3
      Priority:                     100
      Advertisement interval:       1 sec
      Authentication type:          none
      Preempt:                      enabled
    
      VIP count:                    1
        192.168.123.1/24


As you can see, the Vyatta router is plainly working correctly with the CSR just fine - it's taking it's role as backup, and acknowledging that the master is the CSR. However, though I can ping the actual IP addresses of each router, I cannot ping the virtual IP address of 192.168.123.1:

[![csr2screen3](/assets/2013/04/csr2screen3.png)](/assets/2013/04/csr2screen3.png)

It didn't appear to be any kind of Layer 2 problem, since I could ping the routers directly, and I was even getting the MAC address of all three addresses correctly via ARP:

[![csr2screen4](/assets/2013/04/csr2screen4.png)](/assets/2013/04/csr2screen4.png)

After some research (I even went so far as to scrap the Vyatta, spin up another CSR and just do HSRP - same results), [I reminded myself about a frequently overlooked feature in the vSphere standard switch - promiscuous mode. ](http://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.vsphere.networking.doc%2FGUID-74E2059A-CC5E-4B06-81B5-3881C80E46CE.html)If promiscuous mode is disabled, a frame will only get delivered to the exact virtual NIC that it is addressed to, so that other NICs on the vSwitch cannot see the traffic. Therefore, an ethernet frame will get dropped unless the **destination** MAC address is one of the following:
	
  * The exact unicast MAC address of the NIC itself
  * A Layer 2 broadcast (ff:ff:ff:ff:ff:ff)
  * A properly formed L2 multicast (With the seventh bit flipped)

Let's take a look at some traffic flow diagrams. First, when the two routers need to communicate, they use the destination MAC address of 0100.5e00.0012 - the very common VRRP multicast address (224.0.0.18 in the IPv4 multicast format). Since this is a properly formed multicast address destination, this traffic is allowed through perfectly fine. Note that the VRRP virtual MAC address (0000.5e00.0101), which is not recognized by vSphere, is the source address.

[![VRRP Hellos on VMware Standard vSwitch](/assets/2013/04/CSR2screen5.png)](/assets/2013/04/CSR2screen5.png)

However, as I mentioned before, any attempt to access the virtual IP address failed - even though the VRRP "neighbors" were seeing each other correctly. I was even getting an ARP entry for the virtual IP address, and it was correct! So what gives?

Keep in mind that the MAC address used for this virtual IP address is essentially made up. vSphere knows that the "hard coded" MAC addresses of all the vNICs, including those on the routers themselves, because that MAC address is configured in vSphere itself. So when traffic is sent to this virtual MAC address:

[![Traffic to Virtual MAC Address - Blocked by vSphere](/assets/2013/04/CSR2screen6.png)](/assets/2013/04/CSR2screen6.png)

The vSS will not forward this traffic to the router, because promiscuous mode is not enabled, and this traffic is destined for a MAC address the switch does not recognize. Essentially what happens is the traffic is forwarded out the uplink, which is the other host. Since that MAC address isn't recognized on that vSwitch either, the traffic dies. Either way, the traffic does not get delivered to the correct NIC, because the MAC address is an unknown unicast address.

As most network-savvy virtualization admins know, a standard vSwitch does not do MAC address learning in the same way a physical switch does. The hypervisor has authoritative knowledge of both the switch, and the NICs connecting to it - so there is no need for this. What this means is that if a frame comes in destined for a MAC address that vSphere knows does not exist, it drops the frame. Again, this is standard behavior with promiscuous mode turned off. Promiscuous mode is known commonly to be used so that if a VM (usually a virtualized IDS or something similar) needs to sniff traffic that wouldn't otherwise get delivered to it. However, this mode also enables traffic destined for an essentially unknown MAC address to get delivered properly, and not sent out the "I don't know what this is" link.

I enabled promiscuous mode on the standard vSwitches on each host, and I was immediately able to get routed out using the virtual IP address.

[![CSR2screen7](/assets/2013/04/CSR2screen7.png)](/assets/2013/04/CSR2screen7.png)

So, in summary - you might want to consider enabling promiscuous mode or a similar policy if you plan on running these FHRP protocols within your virtual environment.

Now - for bonus points. Promiscuous mode is set to "Reject" by default, which is why we ran into this problem. The default for the other policies is "Accept". Try setting the security policy for "forged transmits" to "reject", which is NOT the default. This will not only break our VRRP setup, but in a different way. Because of the fact that frames to an unknown **destination** were mistreated, having promiscuous mode disabled prevented us from sending traffic to our made up MAC address, but it did not prevent the VRRP "neighbors" from seeing each other. If you have "forged transmits" set to the non-default of "reject", the hellos sent between the routers won't even reach their destination, resulting in both routers thinking they are the VRRP master.
