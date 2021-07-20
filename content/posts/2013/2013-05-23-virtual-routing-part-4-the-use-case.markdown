---
layout: post
title: '[Virtual Routing] Part 4 - The Use Case'
series:
- Virtual Routing
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-05-23"
wordpress_id: 3746
slug: virtual-routing-part-4-the-use-case
tags: ['cisco']
---


Moving along in my "Virtual Routing" series, I'd like to switch gears and talk a little more "big picture". In the previous posts, we've discussed a few different things:

  1. [Part 1](https://oswalt.dev/2013/04/virtual-routing-part-1-csr-1000v-first-glance/) - A first look at the CSR 1000v from Cisco
	
  2. [Part 2](https://oswalt.dev/2013/04/virtual-routing-part-1-9-fhrp-issues-in-vmware-vsphere/) - An examinations of using FHRPs in a virtual environment
	
  3. [Part 3](https://oswalt.dev/2013/05/virtual-routing-part-2-router-redundancy-in-vmware-vsphere-2/) - A comparison of virtual routing redundancy options

Seeing as these were all pretty technical configuration-oriented posts, I wanted to take a step back and think about some of the reasons why one would want to perform routing in a virtual environment. Clearly, the main focus is Data Center, where you get the most bang for your buck. While it's true that companies like Vyatta can be offered in a physical form factor, the vast majority of those looking to perform x86-based routing will do so in the context of a hypervisor, where the virtual router can enjoy the reliability and mobility that comes with today's virtual and cloud infrastructures.

## Architectural Considerations

First - as I've said before - the concept of performing virtual routing is done on a per-tenant basis. Each tenant gets their own routing instance (or pair of instances if you're doing VRRP, etc). That instance can announce a prefix using an IGP or BGP, and voila - you have the ability to make the vast majority of the connectivity northbound of the hosts L3.

[![CSRscreen2](/assets/2013/04/CSRscreen2.png)](/assets/2013/04/CSRscreen2.png)

The big idea here is that north-south traffic that for so long has been hairpinned at the physical core switch no longer has to do so. The only traffic that needs to flow north-south is nonrouted traffic between hosts, or traffic leaving the hosts and going somewhere completely different, such as out of the data center. Traffic between tenants or between VLANs on the same tenant can be localized as much as possible.

Cloud providers can either integrate this into their product offerings, meaning that the customer provisioning process includes the provisioning of a device like this, and the connectivity offerings into the customer's cloud are tightly integrated with the feature sets of the router provided. Users of Openstack could allow Quantum to interact with a virtual router so that the customer is not aware that the routing is being done virtually, and this extra virtual machine does not count against their purchased space.

## Connectivity

As depicted in the above diagram, VPN can now be terminated directly into the virtual environment. Without it, we normally would terminate VPN connections to a large router or firewall near the DC edge, and interpret these to VLANs (and then likely some kind of overlay segment) to get into the tenant's environment.

Vyatta is known to support IPSEC/SSL secure VPNs now. The CSR 1000v does have a few more options, ready to support MPLS and DMVPN (the latter of the two arguably is proprietary).

On Cisco's FAQ page on the CSR 1000v, they specifically call out the idea of using the CSR as a customer edge device to terminate an MPLS VPN. This produces more control over this connectivity, and allows for some additional per-tenant flexibility. On the other hand, IPSEC and SSL based VPNs are much more widely accepted VPN solutions, and it's hard to say if this will get any immediate traction.

I also want to remind folks that OTV is among the features included in the CSR. I don't want to get into a feature set comparison in this post (especially since OTV is proprietary), but it warranted  a mention. I think we're going to see some interesting OTV topologies if we can now do it directly out of the hypervisor.

## Security / SMT

I'd like to differentiate Virtual Routing from Virtual Security. VMware's vCloud Networking and Security (new version of vShield), Juniper's vSG, Cisco's VSG and now ASA 1000v - all completely different from virtual routing products like the CSR 1000v and Vyatta. It should be stated that Vyatta takes a more "swiss army knife" approach, providing firewall and VPN functionality using more of a L3 approach. Cisco would say that the CSR 1000v provides these features, which is true, but they'd also point out that the ASA 1000v is what would be proposed as more of a secure multi-tenant solution.

Now, the routing is recommended from both companies to be performed per-tenant, and the idea that VLANs (or VXLANs if you're bigger) can be used to segment traffic is not a foreign concept to most.

## SDN

Ah, yes - that acronym again. SDN is a powerful use case for this concept but let me be clear - the fact that these solutions run as virtual devices does not make it SDN, and all leading products in the virtual routing space do not currently offer control plane abstraction at present. Yes, they have APIs, so do other solutions. I'm looking for centralized control, and my point in bringing up SDN at all is that x86 based solutions are showing to be easier points of entry for SDN these days.

Cisco has yet to really push the big red SDN button with the CSR (not that I haven't heard it thrown around a little bit) but it's clear that Brocade intends to wield the great sword that is Vyatta into the SDN space. Because of the fact that Brocade has yet to announce what that really means, it has contributed to the notion that Vyatta itself is SDN, which of course is false.

I think right now Brocade is weighing it's next move very carefully with Vyatta. They're involved with OpenDaylight and have shown no hesitation in support of OpenFlow. Let us not forget that just prior to the acquisition, Vyatta was cooking up something in it's evil lab called [vPlane ](http://www.vyatta.com/technology/vplane)- still not a shipping product yet, but it's possible that Brocade is incubating this idea just a little more. Who knows what we'll see, but I would expect something from Brocade soon, probably in tight integration with OpenDaylight. Again, performing networking and firewall functions in x86 is not SDN, just more conducive to SDN.

## More To Come

I won't get into features or performance in this post. I have just one more post to come in this series concerning an apples to apples comparison of the products that are out there, and I hope that this series continues to spark the conversation.

No doubt - those that have been doing x86 networking for a while will have no problem with this idea. Vyatta is not new like the CSR is, so there are shops out there that have been doing this, both in the hypervisor and in bare-metal applications. I'm reminded by this wave of activity of all the college kids that spent the last few years spinning up linux-based firewalls for their home or small office use for some time (that work really really well), and those geeks are now out in the industry (I'll raise my own hand on this one).

Should ASIC-based networking go away? Of course not - there are different benefits to that approach. For now, we can agree that this concept is certainly gaining momentum because of the rapid adoption of cloud technologies, and the identification of virtual routing as a realistic need in the near future.
