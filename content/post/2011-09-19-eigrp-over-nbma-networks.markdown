---
layout: post
title: EIGRP over NBMA Networks
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-09-19"
wordpress_id: 1366
slug: eigrp-over-nbma-networks
tags: ['cisco']
---


Commonly used routing protocols like OSPF and EIGRP utilize multicast addresses to distribute hello messages, and routing information. In a broadcast-capable layer 2 network like Ethernet, EIGRP will send a packet containing a hello message to the address 224.0.0.10, which results in a corresponding layer2 destination 01:00:5e:00:00:0a.

Something I used to wonder about all the time is how routing protocols work over Non-Broadcast Multi-Access networks like Frame Relay. In these networks, there are no broadcasts or multicasts. With Frame Relay, a service provider will set up PVCs  for an organization which act like virtual layer 2 point-to-point connections. Each PVC will be set up  between two participating routers, and each endpoint will be configured with a DLCI, which could be loosely considered as the frame relay equivalent to Ethernet's MAC address.

Consider the following example diagram:

[![](assets/2011/09/diagram5.png)](assets/2011/09/diagram5.png)

In this model, I've configured frame-relay in a "multipoint" fashion, which means every frame-relay connected router is on the same subnet:

    interface Serial0/0.1 multipoint
     ip address 172.16.124.1 255.255.255.248
     no ip split-horizon eigrp 25
     frame-relay map ip 172.16.124.2 102 broadcast
     frame-relay map ip 172.16.124.3 103 broadcast

Note the broadcast keyword at the end. This allows us to specify that whenever broadcasts (for the purpose of this article, broadcasts and multicasts are treated the same) need to be sent, they can be "pseudo-broadcast" along this PVC. Both PVCs are included, denoted by both the remote IP address and the DLCI for each, which means that for this particular instance, all relevant broadcast/multicast traffic will be also sent to our remote routers. 

You're probably asking what I meant by "pseudo-broadcast". To make sense of it, you should look at a sample Hello packet being sent out of a FastEthernet interface on R1:

![](assets/2011/09/packet_eth.png)

As you can see, the IP Multicast address for EIGRP, 224.0.0.10 has been associated with the corresponding ethernet multicast address, which results in actual multicast traffic.

However, as I mentioned before, there is no such thing as multicast/broadcast in frame relay, so while the IP multicast address remains the same, the DLCI remains the same as if the traffic was good ol' unicast:

![](assets/2011/09/packet_fr.png)

This DLCI represents the PVC between R1 and R2, and while the IP layer believes the packet to be multicast in nature, it is not. The "broadcast" keyword shown in the configuration example above simply takes the layer 3 multicast and encapsulates it in a single unicast frame destined for each remote router specified by a "frame relay map-ip" command. The IP header is able to keep the multicast address in its destination field, and has no idea that the entire frame is just unicast traffic.

Now, if only we could find a suitable therapist for the IP header's feelings, which we have clearly hurt by lying to it.
