---
layout: post
title: 'Cisco ACI: As The Dust Settles'
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2013-11-11"
wordpress_id: 4965
slug: cisco-aci-as-the-dust-settles
tags: ['aci']
---


So, the industry is sufficiently abuzz about the Cisco ACI launch last week, and the stats on my [introductory series](https://oswalt.dev/2013/11/insieme-and-cisco-aci-part-2-aci-and-programmability/) I wrote tells me that, like it or not, this is having a pretty big impact.

The focus on the application is clearly the right approach - all of this talk about SDN and network virtualization is taking place because the current network model's complexity results in bad kluges and long provisioning times, and the applications folks are always waiting on the network to respond. So - any product in this space has to solve this problem first and foremost. Whether a hardware solution or a software solution, this is the use case.

The messaging around providing a "translation service" between the app people and the network people is nice to hear. I mean, I understand the value in being able to implement network policy using language that the application folks understand like "app tier is consumed by the web tier ". All of the network-specific policies are abstracted behind these app-friendly policies.

I think the most unspoken part of this paradigm is that this is actually a tool for the network team and the apps/server teams to work more closely together. The message around a product like NSX has been completely the opposite, that the server guys can work AROUND the network team (I know they'd argue with me on this, but that's just how it is). I am not getting that with ACI, but I want to caution those looking at this to use it as a tool to bridge the gap, not drive teams further apart. That part is still up to the human beings.

Take, for instance, the idea of setting up these network service profiles, which are constructs within ACI used to describe an application. This goes beyond simply creating network connectivity templates ahead of time - templates are traditionally very static, and you spawn instances of them. With this, you may define certain things statically (i.e. Web Tier is always consumed on TCP port 80 for instance) but that doesn't mean that you can't populate another field with an API call, in real time, every time a virtual machine moves, for instance.

[![diagram4](/assets/2013/11/diagram4.png)](/assets/2013/11/diagram4.png)

There's nothing that I've seen in ACI that will eliminate the need for collaboration betwen the apps team and the network team. However, that meeting can change it's format. Rather than defining literally everything every time a new app needs to get turned up, the two teams describe the framework for provisioning new applications, and build it out ahead of time. Both teams then are aware of the programmatic methods for bringing new applications into this framework.

This kind of policy creation **actually**** requires****** that the network team and the server team work in tandem. There still exists a field where you define the TCP/UDP port that the application works on, and the network team will have to fill that in. We have these conversations now when we want to build firewall rules. However, now we have the option to populate other fields with dynamic information. How about identifying an application based off of it's currently assigned subnet? That's a network function that can only be derived programmatically. If you've been looking for a use case for network engineers to learn a bit of code, it's with things like this.

Derick Winkworth of Plexxi teased this idea in [his presentation of their Data Services Engine](https://oswalt.dev/2013/10/plexxi-optimized-workload-and-workflow/) - that it's not that far-fetched to use a function call from Chef to populate an Access Control List dynamically.

Speaking of Plexxi, in terms of the technical vision of the product, I see a lot of similarities between Cisco ACI and Plexxi's affinity API. This is not a bad thing - thinking from an application engineer's mindset, the concept of creating application profiles using detailed identification mechanisms then linking them together with policies that are dynamic and programmable is the right thing to do.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/ka8QG7S8ir0" frameborder="0" allowfullscreen></iframe></div>

I'm apparently not alone:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I just finished a round of lectures and videos of Cisco <a href="https://twitter.com/hashtag/ACI?src=hash">#ACI</a>. I must be dumb but I just see Plexxi Affinity presented in a different way</p>&mdash; Daniel Rodriguez (@coolbomb) <a href="https://twitter.com/coolbomb/status/398571817788391424">November 7, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">All this talk of application affinity from Cisco. Interesting that <a href="https://twitter.com/Padma">@padma</a> is speaking in Plexxi&#39;s language. <a href="https://twitter.com/hashtag/clus?src=hash">#clus</a></p>&mdash; Shamus McGillicuddy (@ShamusEMA) <a href="https://twitter.com/ShamusEMA/status/349548663166611457">June 25, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Even Plexxi is aware of this comparison, but [they did it before it was cool](http://www.plexxi.com/2013/06/plexxi-on-cisco-application-driven-networking-is-the-new-black/#sthash.y4TneL5s.AebSL84E.dpbs).

I maintain that this idea is the right way of looking at application policies, so what if two vendor's implementations are similar? There are many aspects of the two solutions that are vastly different - I'm going to chalk it up to "great minds think alike". For me, the most interesting similarity between the Plexxi and Cisco ACI solutions is that both companies recognize and center their product around metadata - the gathering, normalization, and consumption of metadata to drive decisions in a way they've yet to be driven.

At the end of the day, the folks that are engineering the cloud or application infrastructure in software are interested primarily in speed of deployment. They probably don't care much about software-only vs hybrid solutions (i.e. NSX vs ACI) - what they care about is the ability to make application changes quickly, and with the programmability tools they're accustomed to.

> In [episode 12 of the Class-C Block podcast](http://classcblock.com/2013/11/06/show-12-insieme-and-the-nexus-9000/), I discussed this with James Bowling, who works with customers on their application and private cloud needs, and he emphasized the need for tools that simply get the job done, and quickly. Time will tell if the general VMware community is accepting of ACI.

This is a big reason why adding tools other than onePK was the right choice for ACI. Network folks are barely buying in to the onePK message - the idea that the DevOps/automation folks would buy into this as well would have been laughable.

Ultimately NSX is competing directly with ACI, not the Nexus 9000 solution. Cisco will make the argument that if you decide to go NSX, you should still go with the Nexus 9000 platform, because it's still an inexpensive, high-performance 40GbE fabric with programmability features to boot.

In conclusion, I am pleased overall. Though all of the features may not be available today, the framework to do it right is certainly there. I am very impressed/surprised with what they've done from a programmability perspective. I've been kind of in a strange place lately because I work for a VAR who partners with Cisco, among other vendors, and Cisco has traditionally not offered this. Being able to recommend Cisco even for the shops that build their own solutions is incredibly refreshing. This is what's given companies like Juniper and Arista so much market share - they've had these features  for some time. This step was a long time coming for Cisco to remain relevant in shops with mature automation skillsets.

And they're not keeping it back only for those that purchase ACI. Each Nexus 9000 switch has the full list of programmable features regardless of the presence of ACI.

So, here are a few things I think Cisco should focus on for the next few years regarding ACI. I already have posts in draft regarding these points:
	
  * **Cisco Application Virtual Switch** - this needs to do more than match the features of the Nexus 1000v. I think this is the general idea anyways, but a big argument against ACI will be the lack of any kind of service insertion in the hypervisor. OVS integration may be technically possible with ACI, but not directly - only through integration with other controllers that speak OVSDB. Though I (kind of) understand the political reasons why this is the case, it means that they need to get pretty similar in terms of features with the AVS, and soon.

  * **Unified Computing Integration** - We need to see the next generation of a UCS Fabric Interconnect integrate with ACI in some way. This will provide a ton of visibility all the way to the server nic (or to the virtual machine if you love Cisco enough to deploy VM-FEX). Since they're using the concept of service profiles in a different way for ACI, I can only assume this is on the roadmap.

> Disclaimer - This article was written as a follow-up to my two intial posts on the Cisco Nexus 9000 and ACI announcement, and this article in particular is purely my own opinions.
I attended the Cisco ACI launch event as a Tech Field Day delegate. Attending events like these mean that the vendor may pay for a certain portion of my travel arrangements, but any opinions given are my own and are never influenced in any way. ([Full disclaimer here](https://oswalt.dev/disclaimers/))
