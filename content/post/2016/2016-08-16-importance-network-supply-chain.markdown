---
layout: post
title: The Importance of the Network Software Supply Chain
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2016-08-16"
slug: importance-network-supply-chain
tags: ['nfd12']
---


At [Networking Field Day 12](http://techfieldday.com/event/nfd12/), we heard from a number of vendors that offered solutions to some common enterprise network problems, from management, to security, and more. 

However, there were a few presentations that didn't seem directly applicable to the canonical network admin's day-to-day. This was made clear by some comments by delegates in the room, as well as others tweeting about the presentation.

# Accelerating the x86 Data Plane

Intel, for instance, [spent a significant amount of time](http://techfieldday.com/appearance/intel-presents-at-networking-field-day-12/) discussing the [Data Plane Development Kit (DPDK)](http://dpdk.org/), which provides a different way of leveraging CPU resources for fast packet processing.

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/t9AERPGqEvQ" frameborder="0" allowfullscreen></iframe></div>

In their presentation, Intel explained the various ways that they've circumvented some of the existing bottlenecks in the Linux kernel, resulting in a big performance increase for applications sending and receiving data on the network. DPDK operates in user space, meaning the traditional overhead associated with copying memory resources between user and kernel space is avoided. In addition, techniques like parallel processing and poll mode drivers (as opposed to the traditional interrupt processing model) means packet processing can be done much more efficiently, resulting in better performance.

This is all great (and as a software nerd, very interesting to me personally) but what does this have to do with the average IT network administrator?

# Pay No Attention to the Overlay Behind the Curtain

In addition, Teridion spent some time discussing their solution to increasing performance between content providers by actively monitoring performance on the internet through cloud-deployed agents and routers, and deploying overlays as necessary to ensure that the content uses the best-performing path at all times.

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/gkKrfT99ctI" frameborder="0" allowfullscreen></iframe></div>

In contrast to the aforementioned presentation from Intel, who have been very clear about the deepest technical detail of their solutions, Teridion was very guarded about most of the interesting technical detail of their solution, claiming it was part of their "special sauce". While in some ways this is understandable (they are not the size of Intel, and might want to be more careful about giving away their IP), they were in front of the Tech Field Day audience and using terms like "pixie dust" in lieu of technical detail is ineffective at best.

Despite this, and after some questioning by the delegates in the room, it became clear that their solution was also not targeted towards enterprise IT, but rather at the content providers themselves.

Like the technologies discussed by Intel, the Teridion solution has become one of the "behind the scenes" technologies that we might want to consider when evaluating content providers. As an enterprise network architect, I may not directly interface with Teridion, but knowing more about them will tell me a great deal about how well a relationship with someone who __is__ using them might go. When someone isn't willing to share those details, I ask myself "Why am I here?".

# Caring about the Supply Chain

When I walk into the supermarket looking for some chicken to grill, my thoughts are not limited to what's gone on in that particular store, but also with that store's supply chain. I care about how those chickens were raised. Perhaps I do not agree with the supermarket chain's choice in supplier; that will drive my decision to stay in that store, or go down the street to the butcher.

__In the same way__, we should care about the supply chain behind the solutions we use in our network infrastructure. It's useful to know if a vendor chose to build their router on DPDK or the like, because it means they recognized the futility of trying to reinvent the wheel and decided to use a common, optimized base. They provide value on top of that. Knowing the details of DPDK means I can know the details of all vendors that choose to use that common base.

> It's clear that solutions like what were presented by these two vendors is targeted - not at the hundreds or thousands of enterprise IT customers but rather on a handful of network vendors (in the case of Intel) or big content providers (in the case of Teridion). It obviously makes sense from a technical perspective, but also from a business perspective, since acquiring those customers means Intel and Teridion get all __their__ customers as well.

Another good example is a [Packet Pushers podcast we recorded at Network Field Day 11](https://www.youtube.com/watch?v=ufGolasNmak), where we discussed the growing trend of network vendors willing to use an open source base for their operating systems. This is a __good thing__; not only does it help us as customers immediately understand a large part of the technical solution, it also means the vendor isn't wasting cycles reinventing the wheel and charging me for the privilege.

When companies are unwilling to go deeper than describing their technology as "special sauce", it hurts my ability to conceptualize this supply chain. It's like if a poultry farmer just waved their hands and said "don't worry, our chickens are happy". Can you not _at least_ show me a picture of where you raise the chickens? It's not like that picture is going to let me immediately start a competing chicken farm.

When the world around networking is embracing open source to the point where we're actually building entire business models around it, the usage of terms like "pixie dust" in lieu of technical detail just smells of old-world thinking. I'm not saying to give everything away for free, but meet me halfway - enable me to conceptualize and make a reasonable decision regarding my software supply chain.

> I attended NFD12 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
