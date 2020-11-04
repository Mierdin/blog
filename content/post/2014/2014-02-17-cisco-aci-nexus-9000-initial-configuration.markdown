---
layout: post
title: Cisco ACI - Nexus 9000 Initial Configuration
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-02-17"
wordpress_id: 5517
slug: cisco-aci-nexus-9000-initial-configuration
tags: ['aci']
---


I was fortunate enough to be given access to a pair of Nexus 9Ks in our lab, and I want to give a brief overview of the initial configuration process, and a brief introduction to some of the features initially presented to us on the switch platform.

Here are a few summarized thoughts:
	
  1. Calling it a switch is actually kind of funny to me. All ports are routed and shutdown by default, and though you can obviously "no shut" them, and you can convert to a switchport, the switch is clearly built for all-L3 operations. There are no advanced L2 features like FabricPath or vPC, so it's either all L3 or run spanning-tree again.
	
  2. Neither the NXAPI or the Bash shell appear to be a licensed feature, though you do have to enable the feature through a single command.
	
  3. From an NXOS perspective, there's really nothing beyond the bash shell or the API that will catch any seasoned Nexus veteran off guard. This was a very familiar interface and experience, and it truly felt like another Nexus device (with no L2 features, of course)

I'll have more thoughts later and on the Twitters, but for now, I'm pleased to present a 30 minute video introducing the Nexus 9508 switch and performing an initial configuration.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/Sj3nQlS3oS4" frameborder="0" allowfullscreen></iframe></div>

Thanks!
