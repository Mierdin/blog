---
layout: post
title: Converging Skillsets With Technology
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-12-10"
wordpress_id: 5169
slug: converging-skillsets-with-technology
tags: ['convergence']
---


I saw this Engineers Unplugged video today and was reminded of a viewpoint I've been slowly developing over the last two years or so:

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/c26Agxv9Q_E" frameborder="0" allowfullscreen></iframe></div>

Essentially the discussion is about convergence technologies like FCoE, where we rid ourselves of a completely separate network, and converge FC storage traffic onto our standard Ethernet network. With this technology shift, how does this impact the administration of the technology? Do the teams have to converge as well? Or is it just the tool that needs to change?

Cisco has RBAC built in to many of their platforms. DCNM is an example that they gave in the video. I'd also contribute that UCSM is built this way as well. Not all folks administering UCS want to play around with service profiles. Maybe I'm purely a network guy and my role is to build vNIC policies that determine things like VLAN, QoS properties, etc. These products as well as many other vendor products have existed for a while that support this model.

Even if both teams are using the same tool, this doesn't address the problem of communication. I see this all the time with my customers; they may have a network team using the same tool as another team, but that doesn't mean that the developers, server guys, etc know how to use what the network team has provisioned. It also doesn't mean that the network guys know what to provision in the first place. It still comes down to a problem of communication.

By the way - where the rubber REALLY meets the road in terms of communication is during times of troubleshooting. Let's say you're getting issues connecting to a storage array via FCoE. 90% of the time, if there are two engineers (or two teams, whatever) on a FCoE-capable switch like the Nexus 5000, there's going to be a finger-pointing war. The network guys are not super familiar with how FC works, so all they tend to look at are simple constructs like making sure the VLAN is right, etc. They may not understand things like lossless Ethernet, and what it takes to provide that. The storage guys also are incredibly untrusting of Ethernet (largely because the network guys still just aren't used to providing block storage over Ethernet). Without a significant amount of cross-over between these two skillsets, it won't matter if the two teams are using the same tool.

> I'll admit that there are surely plenty of organizations that don't always reflect this - I've worked in the VAR space for quite some time now and these opinions are simply a result of what I've seen.

The real solution remains that both teams or individuals absolutely must acquire both skillsets. There's no way around it. You may specialize in storage or networking, but it goes beyond just learning the todo list of what features to enable to make X happen. This is truly a Unified Skillset - where the technology has converged, and changed the game as a result. It will take both teams to learn this converged solution together. The network team then specializes in the areas of the network where the storage team does not work, such as campus LAN or WAN, and the storage team specializes in the areas the network team does not work. Say....the storage array itself.

If you've read my blog before, you know I've been an evangelist of my "[Unified Skillset](https://oswalt.dev/2013/01/the-unified-skillset/)" theory, which essentially describes this model. As technology converges, so must the engineers administering the technology. This is the path of least resistance when it comes to remaining agile as a business and not making the technology strategy worse when you converge two networks onto each other.

Starting at about 7:00 into the video above, Andrew alludes to the cause for my point. The current model doesn't really work because the network team is used to running a lossy Ethernet network. The FC mindset of providing a lossless fabric absolutely has to make it's way in there.

In terms of what teams get what roles, it obviously all depends on skillsets. The move to VoIP is a good example. A very gross oversimplification would be to say that voice and storage are pretty similar from an ethernet network perspective. They are both essentially just applications on the network, each with specific requirements. Did all PBX/TDM voice engineers lose their job when VoIP happened? I'm sure that there were some who didn't want to learn and were phased out as a result, but most moved into administering voice servers, instead. Their skillsets evolved as the technology model evolved. They took charge of VoIP as an application, not as a standalone network.

Storage is happening much the same way. And just as with voice, if the teams are to converge, then the engineers need to understand the full stack. I'd argue that there are plenty of folks out there willing and able to do this, but not all. There's a jack-of-all-trades vs specialist argument somewhere in here, and [I've already had that discussion.](http://classcblock.com/2013/02/10/show-9-jack-of-all-trades-or-master-of-none/) My answer to that discussion is just that I strongly believe it's possible to be a master of many, and some models call for it.

Ultimately, it comes down to the staff available. Are they able to take on this second role, without simply learning the bare minimum? If so, pay them well. If not, then spend the time forming those lines of communication ahead of time between teams or individuals. When something goes wrong, what do we check? What are the list of common causes of problem on converged networks like FCoE? How can we initially troubleshoot a problem before escalating to the other team? Answering these questions ahead of time will allow you to work well with these converged technologies. If you can solve that platform, the tool itself doesn't matter nearly as much.

[![Also, a "Unified Unicorn" happened.](/assets/2013/12/unicorn.png)](/assets/2013/12/unicorn.png)
