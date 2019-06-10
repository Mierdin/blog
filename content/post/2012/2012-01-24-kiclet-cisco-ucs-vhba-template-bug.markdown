---
layout: post
title: 'KIClet: Cisco UCS vHBA Template Bug'
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2012-01-24"
wordpress_id: 1895
slug: kiclet-cisco-ucs-vhba-template-bug
tags: ['cisco']
---


I found a bug in the vHBA Template creation screen on Cisco UCS 2.0.

It's not too bad, but still a little annoying, and can cause you to have some problems depending on how you have your VSANs set up.

If you notice, the default VSAN is selected for my vHBA template. I have named my VSANs "fabric-a" and "fabric-b". If I drop down the VSAN selector, I have the ability to select the VSAN I have associated with fabric A:

[![](/assets/2012/01/ucsglitch1.png)](/assets/2012/01/ucsglitch1.png)

However, once I've done so, and I change to fabric B, I drop down the selector again, and I now am able to select both VSANs:

[![](/assets/2012/01/ucsglitch2.png)](/assets/2012/01/ucsglitch2.png)

Looks like this is a good reason to name the VSANs according to the correct fabric, otherwise you might associate the wrong fabric ID with the wrong VSAN, since I seem to be able to select Fabric ID A and VSAN B.

Not really a critical bug - I've named my VSANs correctly enough to get around this, but I figured I'd bring it to the public attention.
