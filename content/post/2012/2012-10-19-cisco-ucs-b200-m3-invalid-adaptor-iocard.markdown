---
layout: post
title: 'Cisco UCS B200 M3: "Invalid Adaptor IOcard"'
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2012-10-19"
wordpress_id: 2496
slug: cisco-ucs-b200-m3-invalid-adaptor-iocard
tags: ['blade', 'servers']
---


I received two brand spanking new B200 M3 blade servers for a new project. These bad boys are packing 393GB of RAM and two Intel Xeon E5-2680 2.7GHz 8-core processors each.

[![](/assets/2012/10/2012-10-19_11-03-47_903.jpg)](/assets/2012/10/2012-10-19_11-03-47_903.jpg)

I wanted to get these installed as soon as possible, so I could make sure the firmware was up to current (they came with 2.0(3c), which is what I'm running) and apply service profiles to them.

At the end of the initial deep hardware discovery, I received a strange error in UCSM - "Invalid Adaptor Iocard":

[![](/assets/2012/10/iocard.png)](/assets/2012/10/iocard.png)

This surprised me, and made me instantly concerned that there was a hardware issue on these brand new blades. However, the other M3 was also having the same error.

There's a bit of different hardware in the back of a typical M3 blade. Most of the blades in my infrastructure are B200 M2 single-width blades with the M81KR converged network adapter in the back.

[![](/assets/2012/10/2012-10-19_13-52-25_681.jpg)](/assets/2012/10/2012-10-19_13-52-25_681.jpg)

Instead, the B200 M3 servers I'm working with have the VIC 1240 installed:

[![](/assets/2012/10/2012-10-19_11-02-21_122.jpg)](/assets/2012/10/2012-10-19_11-02-21_122.jpg)

You'll notice that there is an additional card on top, sitting to the right. This is a fairly new concept for some, as the B200 M3 has an additional Modular LOM slot for compatible cards to provide at least 2 x 10Gbit of bandwidth (this includes both regular ethernet and FCoE) to each chassis IOM (fabric extender). The VIC 1240 sits directly in this slot, and is (right now) the only card able to do so.

[![](/assets/2012/10/slot_diagram.png)](/assets/2012/10/slot_diagram.png)

From ["Cisco UCS B200 M3 Blade Server Installation and Service Note"](http://www.cisco.com/en/US/docs/unified_computing/ucs/hw/chassis/install/B200M3.html)

The mezzanine slot is where traditional UCS adaptors like the M81KR would sit in. Since the VIC 1240 sits in the dedicated mLOM slot, the mezzanine slot can then be used for other things.

[![](/assets/2012/10/2012-10-19_11-08-20_131.jpg)](/assets/2012/10/2012-10-19_11-08-20_131.jpg)

There are quite a few options, but the card shown in the picture above is a Cisco VIC 1240 port expander, which can be used to light up an additional two paths, one to each IOM. This means that the two can be used to provide a total of 40Gbit/s to the blade. See the table below for all current "mix-n-match" capabilities.

[![](/assets/2012/10/compatibility-matrix.png)](/assets/2012/10/compatibility-matrix.png)

From [ Cisco UCS B200 M3 Spec Sheet](http://www.cisco.com/en/US/prod/collateral/ps10265/ps10280/B200M3_SpecSheet.pdf)

If you read the spec sheet (click link at bottom of table) you'll read that the 2104XP is not compatible with anything plugged in to the mezzanine slot.

Unfortunately, this was the cause of my problem - the expanders enabled an additional 20Gbit bandwidth to each blade but in order to take advantage of it, I had to use newer chassis IOMs like the 2204XP or 2208XP. Nevertheless, in this environment, 20Gbit/s to the blade is sufficient, and this obstacle has been identified.

The fix was to simply remove the expander card, shown in the last image a few paragraphs up. I set these aside until I could figure out a way to upgrade the fabric extenders in my environment. After I did this, the servers were instantly recognized.

If you have 2104XP fabric extenders in your environment, note this incompatibility, because Cisco's newer blades will likely be driving more towards this hardware architecture. The 2104XP is by no means old, so I am not sure I feel happy about it, but at least 20Gb is sufficient (for now).
