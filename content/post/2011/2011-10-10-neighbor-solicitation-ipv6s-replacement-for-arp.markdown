---
layout: post
title: Neighbor Solicitation - IPv6's Replacement for ARP
author: Matt Oswalt
comments: true
categories: ['IPv6']
date: "2011-10-10"
wordpress_id: 1585
slug: neighbor-solicitation-ipv6s-replacement-for-arp
tags: ['cisco']
---


![](assets/2011/10/noarp.png)

Like most others that start tinkering with IPv6, I quickly learned that there was no such thing as broadcasts on v6 networks. Since I thought that was a pretty revolutionary concept, I started thinking about all the protocols that until now have relied upon the ability to send via broadcast. The first that came to mind was ARP, which resolves known IP addresses to unknown MAC addresses by sending to the Layer 2 broadcast address of FF:FF:FF:FF:FF:FF. It wasn't thought of as a big deal when TCP/IP was first invented, but now it's rather pesky, as each broadcast, ARP included, must be  processed by every device on the segment.

I concluded, and quickly confirmed that **there's no such thing as ARP in IPv6** - so how do hosts find each other on a network? During the course of my studies, I learned that many functions like this were wrapped under the umbrella of IPv6 Neighbor Discovery, which runs on ICMPv6. The function of ARP is replaced in IPv6 by Neighbor Solicitation messages. I'd like to deep dive for a minute or two and explain exactly how this works.

Today's example carries a simple network topology - remember that we're focusing on the ability of one router to find the other using IPv6 Neighbor Solicitation. Both devices are Cisco 2691 routers.

![](assets/2011/10/diagram.png)

The only thing I've set up at this point is IPv6 addressing. I haven't tried to initiate any kind of communication between the routers, so there shouldn't be existing neighbor entries, but a quick check to confirm couldn't hurt:

    R1#show ipv6 neighbors
    R1#

This is analogous to looking at the ARP table in IPv4. R1 hasn't been given a reason to attempt communication with R2 at this point so there's no neighbor entry.

If for some reason you see entries here, try disabling anything that may reach out to R2, and run the command "clear ipv6 neighbors" at privileged exec mode. Since this is a lab, I found it best to start with blank configs.

I started a quick wireshark capture on R1, then issued a ping from R1 to R2:
    
    R1#ping 2001:db2::1F5C:7A92
    
    Type escape sequence to abort.
    Sending 5, 100-byte ICMP Echos to 2001:DB2::1F5C:7A92, timeout is 2 seconds:
    !!!!!
    Success rate is 100 percent (5/5), round-trip min/avg/max = 16/23/44 ms

Because there is no existing IPv6 neighbor entry, R1 will need to send an IPv6 neighbor solicitation, just like it would need to send an ARP message - in either case, the link-layer address needs to be resolved from a known network address.

Now, we should be able to see a new entry in the IPv6 neighbor table of R1:
    
    R1(config-if)#do show ipv6 nei
    IPv6 Address                              Age Link-layer Addr State Interface
    2001:DB2::1F5C:7A92                         0 c003.2168.0000  REACH Fa0/0

This is fairly similar to what we'd see in the ARP table in the IPv4 world, but lets dig into the details of how R1 got this information.

We had a packet capture running, so lets take a look at the first neighbor solicitation sent from R1:

[![ipv6screen1](assets/2011/10/ipv6screen1-1024x340.png)](assets/2011/10/ipv6screen1.png)

I'd like to compare and contrast this a bit with what an ARP message would look like. First, at the very bottom of the packet, you'll see the IPv6 address that R1 is looking for. R1 has no ARP entry for 2001:DB2::1F5C:7A92, and therefore must ask who has this address. This is much the same as ARP, this just says:

> "Hey guys, this is the IP address I'm looking for, now who has it?"

Now, point your attention to the Layer 3 header. This is another big difference with ARP, which didn't even have a Layer 3 header. Take a look at the destination IPv6 address. It starts with "FF02", so we know it's multicast. The specific prefix I would like you to notice is:

    FF02::1:FF00:0/104

You'll noticed that I specified a prefix length of "104". In the packet capture, there was some stuff in the remaining 24 bits as well - we'll get to those in a bit.

This prefix is the beginning of a special type of IPv6 Multicast Address called a "[Solicited Node Address](http://tools.ietf.org/html/rfc4291#section-2.7.1)". The "FF" indicates that the address is a multicast address. The "02" indicates it is a link-local address. The remaining portions of the prefix shown above indicate that this address is a solicited-node address. These are used to send traffic to the host being searched for.

However, as stated before, the idea behind limiting broadcasts is so that not every device on the segment needs to process the packet, so there needs to be a way to send the packet to the host device being searched for, without first knowing the device's Ethernet address.

This is accomplished by taking the 104 bit prefix shown above and appending the last 24 bits of the known IP address to it. Since the known IP address of R2 is 2001:db2::1F5C:7A92, our solicited-node address becomes:

    FF02::1:FF5C:7A92

So, we have our solicited-node addresses, but how does this limit the amount of devices unnecessarily bothered by the traffic? Multicast is built upon the idea that devices join "multicast groups", designated by their own special addresses, and if the device is in that particular group, it processes the frame. If not, it is immediately discarded.

Starting to get it? This is super cool - let's look at the interface details for Fa0/0 on R1:
    
    R1#show ipv6 interface Fa0/0
    FastEthernet0/0 is up, line protocol is up
      IPv6 is enabled, link-local address is FE80::C200:1BFF:FEA0:0
      Global unicast address(es):
        2001:DB2::7729:C0AD, subnet is 2001:DB2::/64
      Joined group address(es):
        FF02::1
        FF02::2
        FF02::1:FF29:C0AD
        FF02::1:FFA0:0
      MTU is 1500 bytes
      ICMP error messages limited to one every 100 milliseconds
      ICMP redirects are enabled
      ND DAD is enabled, number of DAD attempts: 1
      ND reachable time is 30000 milliseconds

According to the output, we have joined an IPv6 multicast group address that is equivalent to the solicited-node address that we saw earlier. The router derived this address from an assigned IP address on its Fa0/0 interface, and joined the multicast group for that address. As a result, it will receive frames that are sent to that address, and since no other host has that IP address, it is the only host that will receive these frames.

In addition, you could use IGMP within a broadcast domain to really prune where these messages go. Totally impossible with IPv4 and ARP.

Look back at the packet capture for the solicitation message, and you'll notice a similar trait in the destination Ethernet address:

     33:33:ff:5c:7a:92

Wireshark tells us that the first 24 bits, "33:33:FF" is the prefix to indicate the encapsulated packet is an IPv6 multicast. However, you'll notice that the last 24 bits is the same last 24 bits as both the IPv6 address on R2's Fa0/0 interface, and the resulting solicited-node address.

Now that we've identified the mechanism used to limit broadcast frames, which is pretty cool in my opinion, we can finally see the response from R2 in the form of a Neighbor Advertisement message:

[![ipv6screen2](assets/2011/10/ipv6screen2-1024x344.png)](assets/2011/10/ipv6screen2.png)

 Note that, much like ARP, the advertisement is sourced from the actual unicast Ethernet address of the host we're trying to reach, and we can now send traffic to it normally.

As a result of this feature, we've successfully discovered the host we intend to send traffic to, and we don't have to bother ever device on a broadcast segment in order to do it.
