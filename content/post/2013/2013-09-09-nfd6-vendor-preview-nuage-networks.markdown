---
layout: post
title: 'NFD6 Vendor Preview: Nuage Networks'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-09-09"
wordpress_id: 4605
slug: nfd6-vendor-preview-nuage-networks
tags: ['nfd6']
---


Nuage Networks is making an appearance at both [Network Field Day 6](http://techfieldday.com/event/nfd6/) and the [Software-Defined Datacenter Symposium](http://techfieldday.com/event/sddc-symposium/) the day before.

Nuage is new to me, but after perusing some of their literature, I was very comfortable with some of the concepts. First, you'll recognize the three-tier architecture that's being used in most SDN discussions in most of their visuals (data plane / controller / NB API)

Nuage uses an product called the VSD (Virtual Services Directory) to define network policies and business logic integration. The VSD communicates to SDN controllers called VSCs, which then use OpenFlow to communicate flows to the network hardware or software below.

In my digging, I also found some references to MPLS and BGP for larger, perhaps multi datacenter designs. I'd like to hear more about both, but I can tell that BGP is used for both outside peering and communication between VSCs. Finally, overlays like VXLAN can be used to communicate between hypervisors.

I would like to point out that, though there are a lot of similarities with other products like VMware NSX, I'll be content to get the deep-dive from Nuage on this and get their sense for why they think this architecture is the future of networking, especially in the data center.

See [http://www.nuagenetworks.net/solutions/](http://www.nuagenetworks.net/solutions/) for more info from Nuage. I also recommend [this slightly more technical paper](http://www.nuagenetworks.net/wp-content/uploads/2013/03/2013-03-28_Nuage_DS_r3.pdf) on Nuage VSP, and this excellent whitepaper on the product created by the Packet Pushers.
