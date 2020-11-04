---
layout: post
title: That Ole Familiar "Network" Command
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-07-31"
wordpress_id: 4316
slug: that-ole-familiar-network-command
tags: ['bgp']
---


A basic concept, but one that is consistently the cause of confusion even in the most learned technical circles within Cisco networking, is the specific role that the "network" command plays in various routing protocols. The reason for this confusion? The use of the word "network" itself. Let's explain.

## The Problem

Let's say you had a shiny new Cisco router, and that router had 4 networks you wished to advertise (I used loopbacks for simplicity):
    
    R1#show ip int br
    Interface                  IP-Address      OK? Method Status                Protocol
    FastEthernet0/0            1.1.1.1         YES manual up                    up      
    Loopback1                  172.16.0.1      YES manual up                    up      
    Loopback2                  172.16.1.1      YES manual up                    up      
    Loopback3                  172.16.2.1      YES manual up                    up      
    Loopback4                  172.16.3.1      YES manual up                    up

Those networks are AWESOMELY (and rarely) contiguous and they start with the lowest subnetwork, so we want to summarize these four networks into one network when we inject them into EIGRP.

So, we heard from a Cisco-savvy colleague that you can advertise networks into EIGRP using the "network" command. We use our recently acquired ninja wildcard-masking skills to create the following:
    
    R1(config)#router eigrp 10
    R1(config-router)#no auto
    R1(config-router)#network 172.16.0.0 0.0.3.255

Notice that we also disabled auto-summarization. Jeremy Cioara has made it clear that we auto-not do auto-summary, so we turn that knob right off. We'd rather use our own carefully crafted summary, which encompasses only these four networks, rather than assume a classful mask (/16) at the classful boundary (which in this case would happen, since the interface connecting to our neighbor is a Class A address).

After a while, we realize that we aren't connecting to our neighbor router, so we decide that it must be because we haven't advertised the network that sits between us. We run the "network" command on both R1 and R2, and this time we omit the mask, since we don't want to summarize.
    
    R1(config)#router eigrp 10
    R1(config-router)#network 1.0.0.0
    *Mar  1 00:12:46.971: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 10: Neighbor 1.1.1.2 (FastEthernet0/0) is up: new adjacency

As you can see, the neighbor came up, and life is good. Or is it? (Dum, dum DUM!!!) Let's look at the routing table on our neighbor router.

    R2#show ip route eigrp
         172.16.0.0/24 is subnetted, 4 subnets
    D       172.16.0.0 [90/156160] via 1.1.1.1, 00:03:06, FastEthernet0/0
    D       172.16.1.0 [90/156160] via 1.1.1.1, 00:03:06, FastEthernet0/0
    D       172.16.2.0 [90/156160] via 1.1.1.1, 00:03:06, FastEthernet0/0
    D       172.16.3.0 [90/156160] via 1.1.1.1, 00:03:06, FastEthernet0/0

We can see all four of our networks advertised. That's not right! We should only be seeing a single 172.16.0.0/22 network!

## The Truth

Hopefully you can tell by now that I'm being facetious- truth be told, the mistake we've made is a result of Cisco's usage of the word "network" in this case, which doesn't really do a good job of describing exactly what that "network" command does, and more importantly, does NOT do.

Cisco does offer a brief description of the "network" command in their [IOS command reference for EIGRP](http://www.cisco.com/en/US/docs/ios/12_2/iproute/command/reference/1rfeigrp.html#wp1031063) (similar can be found for RIP and OSPF):


> To specify a list of networks for the Enhanced Interior Gateway Routing Protocol (EIGRP) routing process, use the network command in router configuration mode. To remove an entry, use the no form of this command.

So, the "network" command, by definition is merely responsible for enabling EIGRP on a network. These networks will have a 1:1 relationship with a router interface, since a Cisco router won't let you have the same network on two different interfaces, so the end result is that if you use the command:

    network 172.16.0.0 0.0.3.255

you'd see that our four loopbacks in the prior example perfectly fit into this mask. This doesn't mean that this wildcard mask (/22) is used when advertising these networks, it just encompasses the IP addresses you wish to check against when looking for interfaces on which to run the EIGRP process. This is why the command:
    
    network 0.0.0.0 255.255.255.255

enables EIGRP on ALL interfaces, since it essentially means "run EIGRP on all interfaces with any IP address". Does this mean those networks will be advertised with a mask of /0, which this wildcard seems to imply? Absolutely not.

Adding to the confusion, the below command:

    network 0.0.0.0 0.0.0.0

is actually acceptable, since IOS assumes you meant "0.0.0.0 255.255.255.255" and changes it to the correct wildcard mask as a result, without telling you that the wildcard mask you entered would otherwise result in NO interfaces running EIGRP, which is obviously not what we wanted.

Now - while the network command does enable EIGRP on an interface, which results in hello messages being sent, and neighbor relationships being established, it also advertises the networks of each EIGRP-enabled interface. This is why I'm saying the "network" command doesn't directly advertise networks - it enables the EIGRP process on all matched interfaces, and as a result, EIGRP advertises each network, **using the interface's prefix length, not the one configured under the "network"**** command.**

Thankfully, when you move to IPv6 (just one more reason), this process becomes a little more straightforward. We don't actually configure EIGRP interfaces under the global process using "network" commands, we simply go under each interface we wish to run the protocol and enable it:

    interface Loopback0
     no ip address
     ipv6 address 1010:AB8::/64 eui-64
     ipv6 enable
     ipv6 eigrp 1
    !
    interface Loopback1
     no ip address
     ipv6 address 2020:AB8::/64 eui-64
     ipv6 enable
     ipv6 eigrp 1
    !
    interface Loopback2
     no ip address
     ipv6 address 3030:AB8::/64 eui-64
     ipv6 enable
     ipv6 eigrp 1

> We still have a global configuration mode for EIGRP and other IGP in IPv6, but we use it for stuff that truly is global, such as setting the router ID or enabling/disabling the EIGRP process on the router.

Now - the point of all this was to summarize our four loopbacks into a single /22. Don't get me wrong, this is still very possible, just not with the "network" command. Manual summarization is different with every routing protocol, but with EIGRP it's done on a per-interface basis. Thus, using the single command (keeping in mind this command will reset our neighbor relationship):
    
    R1(config)#int Fa0/0
    R1(config-if)#ip summary-address eigrp 10 172.16.0.0 255.255.252.0 
    *Mar  1 00:46:46.807: %DUAL-5-NBRCHANGE: IP-EIGRP(0) 10: Neighbor 1.1.1.2 (FastEthernet0/0) is resync: summary configured

results in the routing table on R2 looking exactly like we want it to:
    
    R2#show ip route eigrp
         172.16.0.0/22 is subnetted, 1 subnets
    D       172.16.0.0 [90/156160] via 1.1.1.1, 00:00:40, FastEthernet0/0

Perfect! We have the summary route we want, and life is grand. So, with the use of the "network" command AND the "ip summary-address" command on the desired interfaces, we're summarizing away!

Fortunately, though the details behind summarization are different, all IGPs generally use the "network" command in the same way. What a relief - for a moment I thought there was going to be some routing protocol out there that breaks this blog post -

## BGP BREAKS THIS BLOG POST

See, I spend an hour going through the fine details of how IGP's deal with the "network" command, and BGP comes in and wrecks the  party!

When running BGP, the usage of the "network" command is actually very different. In BGP, this command is used exactly for what you would assume it does just by looking at it - it advertises networks! It doesn't enable the BGP process on an interface, it advertises the network you list in the command!

There are a few caveats - first, you should know that there are quite a few ways to get a route into BGP, the "network" command being one of them. Also, the "network" command will only advertise a route into BGP if that route already exists in the routing table, with the exact prefix length that you specify in the "network" command. So, if we have a directly connected interface (which would be in the routing table already) then we just need to enter a "network" command into the BGP process that matches the IP subnet on this interface.

Be aware of the big differences between BGP and the other IGP routing protocols, especially when preparing for the CCIE. I found the Cisco Press certification guide for the CCIE Written to cover the caveats of the "network" command fairly well.
