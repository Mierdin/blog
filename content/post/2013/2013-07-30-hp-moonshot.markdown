---
layout: post
title: HP Moonshot
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2013-07-30"
wordpress_id: 4266
slug: hp-moonshot
tags: ['big', 'data']
---


Despite my humble beginnings as a network engineer, I'm almost always including servers/virtualization/storage in my day-to-day work. If you're not into building servers from scratch (not a bad venture) then the leaders in the server space might be a good fit for you - most are doing some pretty interesting things in the battle for the top spot in this space. Most folks would agree that HP is still the number one leader, even if only considering pure volume (I see c7000 chassis EVERYWHERE). Cisco UCS adoption has shot WAY up in it's brief existence, in many ways pushing Dell and IBM away from a good chunk of their market share, and challenging HP.

Compute is pretty much a commodity at this point - every vendor is putting more and more resources into a smaller form factor, and the methods by which you manage the compute platform, and how well it integrates with the data and storage networks in the data center become the key differentiators between solutions.

HP doesn't want to give up it's top spot easily, so their latest effort to maintain their title as the king of servers is called Moonshot. They're taking a step back from the traditional x86 blade or rack server discussion (i.e. scale up design, big-ass servers for hypervisor or bare-metal workloads) and focusing on a pretty niche industry segment which I'm sure you'll see in the paragraphs and videos to come.

I wanted to see what the hubbub was all about, so I went over to the Moonshot page and was presented with this:


Frankly, given the nature of the video (lots of inspirational music, not so much technical stuff) they probably could have just gone with this:

http://www.youtube.com/watch?feature=player_detailpage&v=lEOOZDbMrgE&t=95

All kidding aside, it's clear through the marketing messages that the primary objective with Moonshot is to create a way to provide a more capable compute platform, in a smaller package, that uses less power. Feel free to head over to the Moonshot site for a high-level overview. I'd like to dive a little deeper here.

## Overview

HP is positioning Moonshot as a way to get a larger number of compute nodes in a smaller space, with much less power consumption. A single HP Moonshot 1500 chassis has room for 45 hot-pluggable cartridge-based servers in a 4.3 rack unit form factor.

[![serverpicture](assets/2013/07/serverpicture.png)](assets/2013/07/serverpicture.png)

Moonshot introduces the concept of cartridge-based computing. Again, smaller nodes, but more of them. They use less than 6W per cartridge, through the use of the Intel Atom chipset. The first iteration makes use of the S1200 Centerton processors, which provides the desired compute power in a lower form-factor and with less power consumption.

[![cartridgepicture](assets/2013/07/cartridgepicture.png)](assets/2013/07/cartridgepicture.png)

As a result, Moonshot is not really positioned the same as the traditional servers in a typical enterprise datacenter for virtual or physical workloads. You wouldn't go out and buy this for your new vSphere deployment. This is more of a scale-out approach, providing smaller, more efficient compute nodes, and more of them per RU. A good example would be a massive web server deployment, or big data.

The following video is a decent overview of the hardware of the product. Brief explanations of the physical attributes of the chassis are given, as well as a short mention of the various cartridge types.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/21pIQUYMY1E" frameborder="0" allowfullscreen></iframe></div>

## Cartridge Types

If you look at the video above, you'll notice that the lady from HP's lab had three distinctly separate types of cartridges out of the chassis, described by use case:
	
  * Direct Hosting (standard, vanilla cartridge)
  * Storage
  * Multi-Node

[![cartridges](assets/2013/07/cartridges.png)](assets/2013/07/cartridges.png)

Right now, the only available cartridge is the standard Direct Hosting model with 8GB RAM, the Atom Processor, and a single hard drive (can be SATA or SSD). New cartridges should be on the market soon, such as those built on the ARM processor, as well as additional network switch modules.

## Management

At the end of the day, I want to know what makes this product manageable. Compute is becoming so much of a commodity that my priority when looking at these products is finding out how I'm going to be able to manage these compute pools, and how it integrates with my data and storage networks.

So what separates Moonshot from a rack made of Legos full of Raspberry Pi units?

[![raspberry-pi-supercomputer-1-620x465](assets/2013/07/raspberry-pi-supercomputer-1-620x465.jpg)](assets/2013/07/raspberry-pi-supercomputer-1-620x465.jpg)

Well there may not be that many features, but it does use the iLO management module that most HP server admins have become very familiar with. Using this you can get to any server cartridge and install an operating system, as well as perform some basic configuration changes on the system. Not a lot of bells and whistles here.

## Networking

One of my biggest grievences with the c7000 chassis is that the network switch architecture in the back can easily result in really messy and unnecessary cabling. HP would do well to make this easier on their customers in future products, Moonshot and otherwise.
That said, the networking in the Moonshot chassis is actually not too bad. There are some familiar aspects to this design if you've worked with HP products in the past, but it would take another blog post to cover this in detail. Suffice it to say I recommend you head over to the Moonshot site and take a look, and check back here for a link to a future post where I cover the Moonshot networking in a little more detail.

## Software Defined?

Fair warning - if you do any research on this product, you're going to hear the term "Software-Defined Server" more than once. Frankly I think this is a little much. When I think of Software Defined Servers, really the only thing that comes to mind is Greg Ferro's example in [Packet Pushers Episode 151](http://packetpushers.net/show-151-defining-software-defined-whatever/) - something like VMware vCenter, which allows us to move workloads around using software, based on what our compute needs are, essentially abstracting the workload from the physical server. Does this mean that Software Defined Servers == Virtualization? Not necessarily, but it's a compelling example, isn't it?

Is the Internet of Things a reality? Yes. We love our connected devices. Is a new style of IT needed to make this happen? Well, yeah for part of the industry but that's a pretty broad focus. I'd agree with the statement that the applications that power the IoT movement could use some specialized architecture, since you are often talking about global scale. Being able to scale efficiently using tiny little Atom servers but a whole lot more of them is a good idea for this use case. But what makes them Software Defined?

The part that really gets under my skin is that of the many times HP and others slap the "software-defined" label on this product with LITERALLY NO explanation of what that means to them shows me that they have no idea what their own message needs to be and that the term just sounded cool. If you want your product to be taken seriously, have a substantial explanation for any sort of broad term you throw at your audience.

> The title of [this whitepaper](http://h20000.www2.hp.com/bc/docs/support/SupportManual/c03728406/c03728406.pdf) from HP (HP's site was down for me, [here's ](http://webcache.googleusercontent.com/search?q=cache:dNjRr3koCw0J:h20000.www2.hp.com/bc/docs/support/SupportManual/c03728406/c03728406.pdf+&cd=1&hl=en&ct=clnk&gl=us)the Google cached version. Maybe they're using Moonshot for the web page. :) )  is "HP Moonshot System - The World's First Software Defined Servers". I've read it a few times now, and there's literally no explanation of this claim.

At the end of it all, I'd rather not use an overdone term like Software Defined _____ to describe this concept, and even if I did, Moonshot doesn't seem to fit the description, it just seems like HP wanted to have a "Software Defined" label, so they just slapped it on there. I realize there's no "official" definition for software-defined anything these days, so I like to throw out my own personal definition given the context of the discussion. I just think HP should do the same.

## Conclusion

Most of the whitepapers and laughably biased industry articles like to throw around the terms "gamechanger" and similar. I think that the idea of scale-out architectures for specialized workloads is starting to catch on but probably not the way a lot of folks would have expected. There is a large amount of effort being invested in other approaches and those approaches are actually defined in large part by software, leaving us with Moonshot, which is NOT software-defined anything.

The more ironic part in my mind is that the hardware architecture smells of Facebook or Google styled approaches, in that the choice for smaller commodity gear is used on the physical layer, leaving space for ultra-customized voodoo magic to be built on top. Does that mean that everyone that buys Moonshot will do that? Probably not, but the option exists. I think Moonshot will do great for the specific use cases that it states like hyper-scale web services or similar like Big Data, since it is obviously built to do just that, but not much else.
