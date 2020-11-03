---
layout: post
title: 'Redundancy Protocols vs Stacking: Pros and Cons'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-12-12"
wordpress_id: 1826
slug: redundancy-protocols-vs-stacking-pros-and-cons
tags: ['3750']
---


I was recently asked whether or not I preferred to use a router redundancy protocol like HSRP, VRRP, or GLBP, or stack switches together to form a sort of "virtual router", and use that for redundancy. Just like anything else, the immediate answer is "it depends", but there are a few things to remember when considering a redundant design with your routers or Layer 3 switches.

First, redundancy protocols can be found nearly everywhere. Cisco's proprietary HSRP and "everyone else's" VRRP are pretty similar in concept, and with tweaking, perform nearly exactly the same. Either can allow for sub-second failover between routing platforms in the event of a failover. VRRP is also found on Cisco platforms which, interestingly, can allow for multiple-vendor routing platforms to be used in a failover pair, though that's obviously not common. The bottom line is that protocols like this are quite common, and a GREAT tool to know well, since it's likely to be found in many different places.

GLBP is a similar protocol that is Cisco proprietary that came out around 2005, but with the exception of being able to perform active-active load balancing, rather than it's active/passive ancestors HSRP and VRRP.

Stacking (known in the Cisco vernacular as StackWise) is a different beast altogether. Rather than a configurable protocol, stacking is done by linking switches together to form a "virtual switch". Think of it in the same way that you've heard is possible via VSS, which I [explained in a previous blog post](https://oswalt.dev/2011/10/virtual-switching-system-on-cisco-catalyst-6500/). The only difference here is that the protocol does not operate over the network media but over large stacking cables affixed to the back of each switch. Failover at the microsecond-level is enabled with this, and just like VSS, all switches in a stack can be managed via a single IP address, and all interfaces are configurable from the same point.

Some have cited problems with stacking technology, such as with the 3750 platform. I personally have not run into any in my implementations but it looks like [Cisco is starting to record some troubleshooting steps on their site](http://www.cisco.com/en/US/products/hw/switches/ps5023/products_tech_note09186a00807ccc79.shtml#stack). Have you experienced problems with stacking on this or any other platform? Let me know in the comments.

Buggy implementations aside, stacking's biggest hurdle by far is cost. Platforms that use stacking technology are much more expensive, as it requires a specialized hardware architecture to implement, whereas router redundancy protocols just operate over the common media between them, such as Ethernet.

## Matt's Mind

I personally will go for stacking whenever possible. Most of the customers I implement for have the cash to front for a better redundancy solution, and stacking hasn't let me down thus far. I respect protocols like HSRP and I will continue to implement them where it makes sense, but stacking seems to be the way to go if kicking out a little extra money is not a problem.
