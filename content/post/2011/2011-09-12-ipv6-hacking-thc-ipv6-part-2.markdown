---
layout: post
title: IPv6 Hacking - "thc-ipv6" [Part 2]
author: Matt Oswalt
comments: true
categories: ['IPv6']
date: "2011-09-12"
wordpress_id: 1150
slug: ipv6-hacking-thc-ipv6-part-2
tags: ['backtrack']
---


A while back I did a post called [IPv6 Hacking - "thc-ipv6" Part 1](https://keepingitclassless.net/2011/05/new-blog-location-ipv6-hacking-thc-ipv6-part-1/) - it was, in fact, the first post here on Keeping It Classless. That post focused on the flood_router6 script, which unleashed a flood of IPv6 Router Advertisements (RAs) on a layer 2 network segment, bringing vulnerable operating systems like Windows 7 to their knees.

![](https://siliconangle.com/files/2011/05/network-security-lock.jpg)

The "fake_router6" script is another member of the "thc-ipv6" suite that grants a powerful weapon to a would-be attacker. This script takes a bit more work to perform correctly, in addition to a basic understanding of the network on which the attack is being performed.

This attack works like a Man In The Middle attack on steroids. It takes advantage of the fact that operating systems like Windows 7 blindly accept router advertisements they receive, without requiring any form of authentication by default. An attacker will send out RAs and will try to establish their attacking PC as the default router for network devices. This will cause clients to send network traffic to the attacker, and the attacker only needs to open up a Wireshark capture to start sniffing all of those tasty packets.

## Preparation

For the attack to work, however, the victims should  have no idea that anything has changed. Thus, an attacker needs to be able to forward datagrams to and from a legitimate router that enables the victims to continue to use network resources.

Observe the network shown below:

[![](/assets/2011/09/diagram3.png)](/assets/2011/09/diagram3.png)

I set up a free IPv6 tunnel, [courtesy of Hurricane Electric](http://tunnelbroker.net/), and terminated it to a Cisco 2621 router. The "LAN" side of this router, connected via Fa0/1, contains a Windows Vista client, which represents the victim, and a BackTrack 5 client, which represents the attacker. The victim is using the 2621 router as it's default gateway, as a result of the router advertisements being sent from that router.

The "fake_router6" script essentially just sends out IPv6 RAs, and that's about it. Keep in mind that in order to perform a successful Man In The Middle attack, we need to keep the victim connected to network resources. Therefore, we need to turn our attacking device into a makeshift router, and we need to do it **before** we send out our RAs to direct traffic to us.

We will need to forward all traffic to a legitimate router so that connectivity to and from the victim is maintained and they continue to do business as usual. First, we need to enable IPv6 forwarding on our BackTrack machine. In a terminal window, the following command will do just that:

    sysctl -w net.ipv6.conf.all.forwarding=1

This results in IPv6 forwarding (not IPv4) to be enabled on the machine. Keep in mind that this change does not persist after a reboot, though for the purposes of this attack, that doesn't matter.

The 2621 router is our default gateway, and connects us to the internet, so we should forward traffic to that. Take a look at the diagram, and we'll find the link-local address of the router's Fa0/1 interface. Adding a route on the BackTrack 5 machine is pretty straightforward:

    ip route add default via fe80::c200:15ff:fe70:d68f dev eth0

Now, when we receive datagrams from the Vista client, we can forward them right back out to the Cisco router. Thanks to IPv6 neighbor discovery, the Cisco router will send all replies to the BackTrack "router", which delivers them back to the client, who is, by the way, **none the wiser that anything has happened**. As a result, we are able to capture packets in both directions, and we've got it made.

## The Attack

After the prep work, we're ready to start sending out our router advertisements, which will cause the clients' network traffic to be sent our way. In BackTrack 5, simply run the command:

    fake_router6 eth0 1::/64

(Note that on previous versions of BackTrack you might need to run from the directory "/pentest/spoofing/thc-ipv6")

This starts sending RA's out interface eth0 with our made-up prefix of 1::/64. You'll see some output notifying you that RA's are being sent out, and soon enough, the Vista client will pick up on it and change it's configuration to use the attacking device as the default gateway.

The RAs play a vital role in the attack, as they must force the clients to use the attacking device as opposed to the Cisco router. There's a field in IPv6 router advertisements that determines default router preference. First, by default, the Cisco router sends out RAs with the router preference set to "Medium":

[![](/assets/2011/09/packet1.png)](/assets/2011/09/packet1.png)

Our attacking machine will set this flag to "high", forcing clients to use it as their default gateway:

[![](/assets/2011/09/packet2.png)](/assets/2011/09/packet2.png)

Let's take a look at the results of the attack. First, a traceroute to Google's IPv6 address before the attack started:

    C:>tracert 2001:4860:800f::93
      1    <1 ms    <1 ms    <1 ms  2001:470:1f11:1240::1
      2    23 ms    23 ms    22 ms  2001:470:1f10:1240::1
      3    17 ms    16 ms    20 ms  2001:470:0:6e::1
    .......

And now during the attack:

    C:>tracert 2001:4860:800f::93
      1     7 ms    <1 ms    <1 ms  fe80::c200:15ff:fe70:d68f
      2    <1 ms    <1 ms    <1 ms  2001:470:1f11:1240::1
      3    23 ms    22 ms    22 ms  2001:470:1f10:1240::1
      4    23 ms    24 ms    23 ms  2001:470:0:6e::1
    .......

As you can see, the first trace shows that our first-hop is the Cisco 2621. The second trace shows an additional hop at the beginning - this is the attacking device's link-local address. The second hop in the list is the Cisco 2621, showing that we've successfully rerouted this client's network traffic through us, without interrupting connectivity.

At this point, the packets are flowing through the BackTrack PC, which allows us to simply open up Wireshark to sniff out all the clients' traffic.

## Defense Against the Dark Arts

I imagine you're now (painfully) aware of the inherent danger in an unprotected IPv6 network, and how easy it can be to perform a devastating MitM attack in such an environment.

As with many other IPv6-based attacks, the main target for fake_router6 is the access layer, where it can affect as many clients as possible. This attack is effective against all vulnerable clients in a layer 2 segment. Microsoft is aware of the fact that Windows will essentially blindly accept these Router Advertisements, and rather than acknowledging it as a vulnerability, they're saying it is performing by design. While there's more that Windows could be doing to help mitigate these types of attacks, there are effective ways to defend against them at the infrastructure layer.

Keep in mind that the "vulnerability" isn't really a vulnerability at all - both the Cisco router and the Windows client are operating as designed. The problem is that we're allowing end-user devices to inject rogue RAs into the network, and we're also not implementing any sort of mechanism to authenticate the sender.

[RFC3971](http://tools.ietf.org/html/rfc3971) details SEcure Neighbor Discovery, or SEND, as a way of authenticating legitimate Neighbor Discovery messages, such as router advertisements. These are options placed within the Neighbor Discovery packets that allows devices to ensure the RAs they're receiving are from legitimate senders. SEND includes fields like Cryptographically Generated Address (CGA), Certificate Path, and RSA Signature. For devices that support SEND operation, these fields allow for authentication of all Neighbor Discovery messages, which includes router advertisements.

[RFC 6105](http://tools.ietf.org/html/rfc6105) proposes a solution called "RA Guard" to be used when SEND is not an option on all network devices, but should be used whether or not SEND has been implemented. Rather than providing authentication, RA Guard is designed to provide protection where physical security is not assured, such as wireless networks. It is typically implemented on an access layer router or switch, and helps filter out router advertisements on interfaces that you as the network engineer deem shouldn't ever be sending them.

Cisco provides a document called [Implementing First Hop Security in IPv6](http://www.cisco.com/en/US/docs/ios/ipv6/configuration/guide/ip6-first_hop_security.html) that details configurations performed on access-layer Cisco devices to protect against a wide variety of IPv6-based attacks. The article goes on to describe the steps necessary to configure RA Guard on Cisco devices [here](http://www.cisco.com/en/US/docs/ios/ipv6/configuration/guide/ip6-first_hop_security.html#Configuring_IPv6_RA_Guard_in_Cisco_IOS_Release_12.2(33)SXI4_and_12.2(54)SG). If you've implemented Cisco equipment on your network, this document is a must-read in order to properly harden your IPv6-enabled infrastructure.

It's important to be aware of the new dangers present in IPv6 and be vigilant in protecting your environments from easy-to-execute hacks and exploits.

> For more info on "thc-ipv6", head on over to [http://www.thc.org/thc-ipv6/](http://www.thc.org/thc-ipv6/). That page details all of the tools in the "thc-ipv6" suite. Be sure to look around at THC's other projects!
