---
layout: post
title: Open Source Switching
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-05-09"
wordpress_id: 3719
slug: open-source-switching
tags: ['facebook']
---


There's been a ton of attention lately around the concept of using commodity hardware in an area of the industry that is currently dominated by proprietary ASIC-based solutions - networking. When it comes to crossing paths between open source and networking, the obvious low-hanging fruit has been software-based switching solutions like [Open vSwitch](http://openvswitch.org/), or cool ways to make virtual switching do bigger, better stuff for cloud providers like [Openstack Quantum](https://wiki.openstack.org/wiki/Quantum) (awesome, by the way). For those that follow me online at all, you know I've been on a virtual routing kick lately - just another sign that performing network functions in an x86 context is starting to look like it makes sense.

At some point, however, the network has to go physical. Until the first World as a Service (Wait, that spells WaaS....ugh) comes out and we all plug into the Matrix, we need to have some kind of physical topology that allows us to connect physical servers together, or at the very least, get packets from point A to point B.

Facebook announced at Interop and on the [Open Compute project site](http://www.opencompute.org/2013/05/08/up-next-for-the-open-compute-project-the-network/) that they were developing an open Top of Rack switch, designed to allow networking to move past this "appliance model", and simply produce a network infrastructure that is agile, and designed to exactly fit the needs of the applications using it.

Other areas of the industry have benefited from the concept of[ "open" hardware](http://en.wikipedia.org/wiki/Open-source_hardware), that is - hardware that is based upon an industry-accepted standard and is widely understood - not specific to a particular vendor. Stacy Higginbotham [puts it best](http://gigaom.com/2013/05/08/heck-yeah-facebooks-open-compute-project-is-making-an-open-source-switch/) - networking really is the last part of the industry where the majority of customers are content with running extremely proprietary solutions on little more basis than _it's just been the norm for so long._

That article also mentions an important point. This is not an SDN play - just a good attempt to break out of a proprietary hardware model. However, proliferation of SDN will certainly benefit from such an approach (and OpenFlow support on such a platform is pretty likely).

## My Take

Selfishly? I want one. I want ten. I want the ability to throw some standards-based hardware into the top of my lab at home, and do networking my way for a fraction of the cost.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Mierdin">@Mierdin</a> that works for me. I despise anything that doesn’t let me in the guts. Especially if I can do it better on my own for 1/10th the $</p>&mdash; Ryan M. Adzima (@radzima) <a href="https://twitter.com/radzima/status/332342763679014913">May 9, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I want to be able to spin up cool stuff like OpenDaylight and OpenFlow and run networking in my organization the way I want it to be done. I want to be able to take my learned experiences from customer needs over the years and apply it to a system that I helped design. While the customer base for closed systems like Cisco will undoubtedly be around for years and years, having the option to present some flexibility in physical networking is very appealing.

I find it to be EXTREMELY interesting that the OpenDaylight project, which is composed in part by leading closed-source switching vendors (Cisco, Juniper, Brocade to name a few), is cited to be one of the big participants in the project to develop this open source switch. I know all of these vendors have tried their level best in the past 6 months that SDN has lit up the Twittersphere to redefine themselves and really push the software solutions (that don't exist yet) but they are ALL way too invested in what is essentially an appliance-based model of doing networking right now.

[![The "Network Appliance" In Your Datacenter](/assets/2011/10/switch1.png)](/assets/2011/10/switch1.png)

It will be interesting to see how their indirect involvement in this project will impact their current strategies, and participation in things like OpenDaylight.

This also represents a pretty big opportunity for integrators to take charge and roll SDN solutions combined with open hardware switching like this into their portfolio of offerings. Most VARs define their existence by attaching to one or more vendors. While this works well for obvious reasons, there's no reason why a capable VAR couldn't work on their own self-validated design involving this kind of infrastructure. Maybe that's a pipe dream, but I say there's an opportunity there.

So Facebook - hurry up on this thing, I have money to throw at you.