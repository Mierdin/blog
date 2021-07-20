---
layout: post
title: 'Cisco UCS: Crossing the Streams'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-10-10"
wordpress_id: 4755
slug: cisco-ucs-crossing-the-streams
tags: ['cabling']
---


Apparently you can cable the A-side Fabric Interconnect to the right IOM in a chassis, and it works just fine.

[![ucs_cross](/assets/2013/10/ucs_cross.png)](/assets/2013/10/ucs_cross.png)

You can even look at the DCE interfaces on a VIC in this chassis and see that the paths have been flipped:

[![ucs_cross2](/assets/2013/10/ucs_cross2.png)](/assets/2013/10/ucs_cross2.png)

This is not true for the "correctly" cabled chassis, where the A-side traces occupy the first two slots:

[![ucs_cross3](/assets/2013/10/ucs_cross3.png)](/assets/2013/10/ucs_cross3.png)

The first two interfaces will always go to the left IOM because the backplane traces are cabled that way. However, the IOM is aware of what FI it's connected to:

[![ucs_cross4](/assets/2013/10/ucs_cross4.png)](/assets/2013/10/ucs_cross4.png)

The DCE interfaces receive this information from the IOM they connect to, and as a result, the VIC knows to pin A-side vNICs to the right traces. We've "crossed the streams" as it were, but nothing north of the Fabric Interconnects would know this.

So while there's certainly an argument for cabling things straight-down to lessen any confusion, it's interesting to see that there's absolutely no such thing as an A-side or B-side IOM or IOM slot. Both IOMs are identical, and the slots are treated the same way. They just assume the fabric identity of the FI they're connected to.

I'm up late staging some UCS gear and just wanted to share.
