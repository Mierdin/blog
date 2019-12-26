---
layout: post
title: Pinging a Firewall - Is It Up Or Down?
author: Matt Oswalt
comments: true
categories: ['Security']
date: "2012-12-18"
wordpress_id: 2654
slug: pinging-a-firewall-is-it-up-or-down
tags: ['arp']
---


Let's say you're trying to find a free IP on a network so you can assign one to your PC to do some work. First off, shame on you for not using proper addressing design with an IP address manager software. Second, you might use basic ping tests to properly identify alive hosts vs. dead hosts (free IP addresses). Most do. In fact, you can use nmap to do simple ping sweeps of entire subnets. You see what IPs aren't responding to pings and there you have it, those IP addresses are free.

However - are these IPs truly not in use? Are we content with seeing that the IP simply doesn't respond to pings in order to feel comfortable using it ourselves? What if that IP address is actually in use, and just isn't responding to ICMP? This is extremely common with host-based firewalls, or intermediary firewalls that don't allow ICMP. How then, do we accomplish the task of identifying free IP addresses?

Getting "no response" can manifest itself in a few ways. First, you could get ICMP unreachable messages, which can happen if the device is not permitting ICMP and is configured to respond with the ICMP equivalent message of "no, you can't do this".

    R2#ping 192.168.1.1
    Type escape sequence to abort.
     Sending 5, 100-byte ICMP Echos to 192.168.1.1, timeout is 2 seconds:
     U.U.U
     Success rate is 0 percent (0/5)

Of course, you could always just get timeouts the entire time:
  
    R2#ping 192.168.1.1
    Type escape sequence to abort.
     Sending 5, 100-byte ICMP Echos to 192.168.1.1, timeout is 2 seconds:
     .....
     Success rate is 0 percent (0/5)

So, you see the problem. The solution is simple - although it is common for some device to restrict ICMP traffic, they still must use Address Resolution Protocol to resolve IP addresses to MAC addresses (Yes this is not the case if you do static ARP but no one does that so shut it).

    R2#show ip arp 192.168.1.1
     Protocol Address Age (min) Hardware Addr Type Interface
     Internet 192.168.1.1 0 cc00.31f4.0000 ARPA FastEthernet0/0

You see that although this device did not respond to pings, it DID still respond to the ARP request that was sent out originally, and we know that it is still alive on the network.

Unfortunately, if you were to run a simple ping scan with a tool like nmap, it does not take ARP into account, so it will still report the IP as down. I have not found another ping sweep tool that changes this. If you want to be more accurate, you'll have to do more than a simple ping sweep.

It should also be said that this is an IPv4 concept only - not just because [ARP is gone in IPv6](https://oswalt.dev/2011/10/neighbor-solicitation-ipv6s-replacement-for-arp/), but also because outright disabling ICMP in IPv6 is just a bad idea. Many of IPv6's new features are built directly into ICMPv6, like neighbor discovery, router advertisements, and more.

Here, we've disabled (blocked with an access list) ICMPv6 altogether, and we are unable to discover IPv6 neighbors entirely. This doesn't just mean we can't ping the device, it means we can't resolve a MAC address either, so communication doesn't happen.

    R2#show ipv6 neighbors stat
    IPv6 ND Statistics
     Entries 0, High-water 1, Gleaned 0, Scavenged 0
     Entry States
     INCMP 0 REACH 0 STALE 0 GLEAN 0 DELAY 0 PROBE 0
     Resolutions (INCMP)
     Requested 3, timeouts 9, resolved 0, failed 3
     In-progress 0, High-water 1, Throttled 0, Data discards 2
     Resolutions (PROBE)
     Requested 0, timeouts 0, resolved 0, failed 0

We aren't there yet, but as IPv6 adoption increases, and security folks (inevitably) start balking about things, firewalls will need to be more granular in what specific types of ICMP messages are allowed, and not allowed. We have a few of these features now, but these capabilities will grow as time goes on.