---
layout: post
title: 'NFD6 Vendor Preview: Plexxi'
author: Matt Oswalt
comments: true
categories: ['Tech', 'Field', 'Day']
date: "2013-09-04"
wordpress_id: 4396
slug: nfd6-vendor-preview-plexxi
tags: ['nfd5']
---


Plexxi was first involved with Network Field Day about 5 months ago at Network Field Day 5. There, they demo'd their very unique approach to networking.

You won't hear about Plexxi without hearing about their WDM-based optical network design. You may even hear it referred to unofficially as Layer 1 SDN - and that's a pretty apt description. Plexxi uses special

From a logical perspective (kind of semi-logical and semi-physical) I think it's great. While the cabling may be a ring, the Photonic Switching allows them to connect two physical switches together that aren't directly connected, allowing us to come up with some pretty cool logical topologies.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/HUA7hp6A9Fo" frameborder="0" allowfullscreen></iframe></div>

Oh and by the way, the recent discussions regarding VXLAN Tunnel End Points (VTEPs) where a VXLAN "tunnel" terminates in a hardware appliance, providing an integration point is really relevant here, because the Plexxi switch is powered by the [Broadcom Trident II](http://www.broadcom.com/products/Switching/Data-Center/BCM56850-Series), which includes VXLAN support, among other things. This gets interesting considering the logical topologies that Plexxi can create is almost a Layer 1 version to what we've been discussing in overlay networking - so I'm interested to see how they view the two integrating in the future.

Finally,I'm interested in hearing how their journey towards market penetration has gone. The Plexxi design is pretty different from what you'd typically find in a datacenter, so I'm eager to hear how the customers that they have won over to this new topology in the little bit of time since we saw them last are using its features.

See below for some articles from other NFD delegates. I'll be reading these and more to prepare for Plexxi's second appearance at NFD6.

Past NFD Articles of Note:
	
  * [Jason Edelman](https://twitter.com/jedelman8) - [Plexxi Affinities Part 1](http://www.jedelman.com/1/post/2013/08/plexxi-affinities-part-1.html) and [Part 2](http://www.jedelman.com/1/post/2013/08/plexxi-affinities-part-2.html)
	
  * [Anthony Burke](https://twitter.com/pandom_) - [Plexxi Switch](http://blog.ciscoinferno.net/plexxi-switch)
	
  * [Packet Pushers Podcast](https://twitter.com/packetpushers) - [Show 126 - Plexxi Affinity Networking with Marten Terpstra (Sponsored)](http://packetpushers.net/show-126-plexxi-affinity-networking-with-marten-terpstra-sponsored/)
	
  * [TechFieldDay.com](https://twitter.com/techfieldday) - [Plexxi Presents at Networking Field Day 5](http://techfieldday.com/appearance/plexxi-presents-at-networking-field-day-5/)

  * [Tom Hollingworth: The Networking Nerd](https://twitter.com/networkingnerd) - [Plexxi and The Case For Affinity](http://networkingnerd.net/2013/04/08/plexxi-and-the-case-for-affinity/)
	
  * [Jon Langemak](https://twitter.com/blinken_lichten) -  [Plexxi: Layer 1 SDN](http://www.dasblinkenlichten.com/plexxi-layer-1-sdn/)
	
  * [Paul Stewart](https://twitter.com/packetu) - [Affinity Networking Takes Center Stage](http://www.packetu.com/2013/04/09/affinity-networking-takes-center-stage/)

  * [John Herbert](https://twitter.com/mrtugs) - [http://lamejournal.com/2013/03/13/smart-optical-switching-your-plexxible-friend/](http://lamejournal.com/2013/03/13/smart-optical-switching-your-plexxible-friend/)
