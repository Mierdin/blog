---
layout: post
title: 'KIClet: SDN - Pick Your Poison'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-04-15"
wordpress_id: 3460
slug: kiclet-sdn-pick-your-poison
tags: ['kiclet']
---


I keep having to remind myself that SDN is more about solving a policy problem than a transport problem. This is why the answer to the question "Will SDN solve all of our networking problems?" is always NO. Truth be told, SDN has been around for a while (see SNMP, Perl, Netconf) in various forms, but it's receiving a lot of attention right now because the mechanisms are starting to mature and frankly, the networking industry hasn't really seen a lot of groundbreaking innovations lately.

While the debates behind which SDN mechanisms are best rage on, the choice of where the control plane abstraction should take place is really the least interesting conversation to be having right now. Use case doesn't always come first, but in this case, it's fun to throw a few examples up where SDN might provide some benefit, and THEN decide what level of abstraction is necessary.

For instance - maybe we don't like the way that standard IP routing works - maybe it doesn't provide us with the application-level awareness that we need. Of course, SDN on a high level sounds like a good solution, but what kind? Some vendors have promised a simple API to existing network devices (see [onePK](http://www.youtube.com/watch?v=92ihQW82tzQ)), others have created (or allowed for) mechanisms for directly influencing TCAM tables (see [OpenFlow](http://networkstatic.net/openflow-proactive-vs-reactive-flows/)). The former won't really change the paradigm of how IP routing takes place, we'll still be required to configure BGP at some point in our networks. The latter will allow us to begin the hard work of defining our own methods of routing flows through our networks, based on attributes that we define and deem important.

It seems like the most attention from the community is being given to "open" solutions like OpenFlow, most notably manifested in the recently announced [OpenDaylight](http://blog.ioshints.info/2013/04/the-first-glimpse-of-open-daylight.html) project. This project is really the first sign of a legitimate application for OpenFlow-based SDN where the higher-level functions have been developed already. This project more or less represents an (attempt at an) encapsulation of all potential SDN approaches, which is kind of cool. I'll be looking into OpenDaylight further in my secret lab.
