---
layout: post
title: How Taco Bell Taught Me About Converged Networks
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-05-22"
wordpress_id: 3760
slug: how-taco-bell-taught-me-about-converged-networks
tags: ['converged']
---


I would make the argument that the term "converged networks" is not really a buzzword the way it used to be, since the world now generally understands the concept. Rather than have isolated physical networks, lets make a very popular network topology more robust in terms of capacity, but also features. After all, the networks and protocols we're combining have some pretty stringent requirements, and we want to make sure that this transition actually works.

When I first heard the term quite a few years ago, I found that fast food soda machines are a perfect analogy of this idea.

[![oldnozzles](assets/2013/05/oldnozzles.png)](assets/2013/05/oldnozzles.png)

For each type of soda being served in a restaurant, a completely separate dispenser assembly must be made. A new nozzle, a new lever, a new plastic housing. While is true that many of these dispenser assemblies are similar, especially in purpose, they are not the same. We have dedicated a slot for each type of soda. This is the unconverged network.

Move to that fateful day at Taco Bell when I went to grab a cold glass of Baja Blast and - voila!

[![Pictured: FCoE](assets/2013/05/tacobell2.jpg)](assets/2013/05/tacobell2.jpg)

 The idea of using these dedicated nozzles was not good enough for Pepsi, and they moved towards a strategy of building - more complicated (and probably expensive) nozzles, yes, but far fewer of them. Simply provide an easy mechanism so that each soda flavor can utilize the same infrastructure, and you have yourself a soda machine that does not compromise on it's ability to deliver soda, yet it does so in a more efficient way.

Moving out of analogy and into the real world; one of the first big examples of this in the technology realm (at least as long as I've been around) is the consolidation of hundreds, or even thousands of dedicated voice circuits at branch offices:

[![voipPreConverge](assets/2013/05/voipPreConverge.png)](assets/2013/05/voipPreConverge.png)

onto the WAN, where they're carried via IP (VoIP):

[![voipPostConverge](assets/2013/05/voipPostConverge.png)](assets/2013/05/voipPostConverge.png)

No longer is there a need for dedicated connectivity at each remote site - a costly endeavour that's been in place for so long we've forgotten what it was to spend money on anything else. Nonetheless, as WAN providers started to offer more features that gave the network and telephone admins the warm and fuzzies that the WAN could handle the convergence of VoIP, which is arguably one of the most sensitive traffic types out there, the convergence happened, and VoIP is enjoying widespread adoption in such a scenario, where before it was only accepted on the easily controlled environment that is the Campus LAN.

Focusing specifically on Data Center now, the same has happened but even more recently with storage networks. While there is still (and maybe always will be) a use case for the dedicated storage network, carrying nothing but transport for block storage:

[![DCPreConverge](assets/2013/05/DCPreConverge.png)](assets/2013/05/DCPreConverge.png)

...it's starting to make a whole lot of sense to utilize the great advances made in technology like FCoE (and yes, even NFS and iSCSI) - no doubt given new life thanks to 10/40/100GbE - to create a single fabric that does not care whether the traffic is a write request for a disk somewhere in the fluffy clouds, or your ePayment for that latest eBay purchase.

[![DCPostConverge](assets/2013/05/DCPostConverge.png)](assets/2013/05/DCPostConverge.png)

Networks that are intelligent enough and sized well enough to handle the needs of today AND tomorrow is clearly where these last few years have created for us to operate.

For those that have been reading me long enough know this isn't the first time I've brought up this topic, though my daydreams probably focus more on the "people" side of things. Network convergence is old news - I didn't write this post to inform the world that this is around the corner, clearly it's happening. I did write it to point out how it originally started clicking for me back then, as well as serve for a gentle reminder that the technology is moving in this direction, and those pursuing the [Unified Skillset](https://keepingitclassless.net/2013/01/the-unified-skillset/) will no doubt be the network rockstars of tomorrow.
