---
layout: post
title: IPv6 Next-Hop Best Practices
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-03-21"
wordpress_id: 3299
slug: ipv6-next-hop-best-practices
tags: ['ipv6']
---


The concept of a link-local address is new to some, seeing as the term is not widely talked about in IPv4 circles, despite the fact that some folks see them daily. In IPv4, the range 169.254.1.0 through 169.254.254.255 has been reserved for this purpose. You may see this in the "ipconfig" output of a windows host that failed to pull a DHCP address.

In IPv6, fe80::/10 is reserved for this purpose, though link-local addresses are always configured with a fe80::/64 prefix. The concept of a link-local address is much more heavily used in IPv6, and one very popular use case is in next-hop determination. While it's possible to use Global Unicast addresses, such as anything in the 2000::/3 block, it's also a very popular use case to use link-local addreses to get packets to a next-hop router.

There's an IETF draft that will expire in a month titled "[Design Guidelines for IPv6 Networks](http://tools.ietf.org/html/draft-matthews-v6ops-design-guidelines-01)" that explores the concept of using link-local addresses in IPv6 for next-hop information, at both the access and core, vs. using globally routable addresses. I recommend a read, because it mirrors the views that I've heard throughout the industry from those implementing IPv6 networks.

Most routing protocols use the link-local address for a next-hop, as do hosts configured via SLAAC. Take, for instance, the sample topology below:
[![ipv6nexthop](/assets/2013/03/ipv6nexthop.png)](/assets/2013/03/ipv6nexthop.png)

OSPFv3 has been configured on all links, and everything's in area 0 for simplicity. From R1's perspective, both of the remote networks are available through R2 as expected, but via R2's link-local address.
    
    R1#show ipv6 route ospf
    IPv6 Routing Table - 6 entries
    Codes: C - Connected, L - Local, S - Static, R - RIP, B - BGP
           U - Per-user Static route
           I1 - ISIS L1, I2 - ISIS L2, IA - ISIS interarea, IS - ISIS summary
           O - OSPF intra, OI - OSPF inter, OE1 - OSPF ext 1, OE2 - OSPF ext 2
           ON1 - OSPF NSSA ext 1, ON2 - OSPF NSSA ext 2
    O   2001:1234:5678:2::/64 [110/2]
         via FE80::CE0B:20FF:FEA0:0, FastEthernet0/0
    O   2001:1234:5678:3::/64 [110/3]
         via FE80::CE0B:20FF:FEA0:0, FastEthernet0/0

Traffic from R1 to R4 will still result in a neighbor solicitation to the next-hop address in the routing table, and since that address indeed belongs to R2, R1 will be able to get R2's MAC address and switch the packet in that direction.

The Layer 3 addresses used on each link are link-local addresses, which means they have only local significance. A link local address on the link between R1 and R2 would have no knowledge of the address on the link between R2 and R3. It's link-local. The interesting thing here is that this has no bearing on traceroutes, or destination IP addresses for packets. Those always get the Global Unicast addresses.

Ironically enough, many network administrators are using Global Unicast addresses for next-hop addresses, especially when configuring static routes. As the draft states, the RFC for [Neighbor Discovery in IPv6](http://tools.ietf.org/html/rfc4861#section-8) makes it abundantly clear:

    A router MUST be able to determine the link-local address for each of
       its neighboring routers in order to ensure that the target address in
       a Redirect message identifies the neighbor router by its link-local
       address.  For static routing, this requirement implies that the next-
       hop router's address should be specified using the link-local address
       of the router.  For dynamic routing, this requirement implies that
       all IPv6 routing protocols must somehow exchange the link-local
       addresses of neighboring routers.

However, the draft brings up another point. When redistributing static routes into a routing protocol, using a link-local next-hop simply does not work. I decided to try this out by disabling OSPFv3 between R3 and R4, and adding static routes everywhere necessary to make it work. I also redistributed this route into OSPF on R2 so that R1 would get this external route:
    
    R2(config)#ipv6 route 2001:1234:5678:3::/64 Fa1/0 FE80::CE03:16FF:FEC0:10

    ---

    R1#show ipv6 route ospf
    
    O   2001:1234:5678:2::/64 [110/2]
         via FE80::CE02:16FF:FEC0:0, FastEthernet0/0
    OE2  2001:1234:5678:3::/64 [110/20]
         via FE80::CE02:16FF:FEC0:0, FastEthernet0/0
    
    R1#ping 2001:1234:5678:3:CE00:16FF:FEC0:0
    
    Type escape sequence to abort.
    Sending 5, 100-byte ICMP Echos to 2001:1234:5678:3:CE00:16FF:FEC0:0, timeout is 2 seconds:
    !!!!!
    Success rate is 100 percent (5/5), round-trip min/avg/max = 48/57/76 ms

R1 received the route from R2, but the link-local address specified is the address of R2, not the original link-local address specified in the static route. Finally, I ran a test to make sure it worked.

Not to discount the authors of the draft, but perhaps there's another scenario in which link-local addresses are not advisable, but until I get there, I'll probably use them.

As a side note - since link-local addresses are only locally significant, you could use something like fe80::1 pretty much everywhere for simplicity. A good example would be the virtual IP address for a first-hop redundancy protocol like HSRP or VRRP. Just food for thought - those addresses aren't looking so long anymore, eh?
