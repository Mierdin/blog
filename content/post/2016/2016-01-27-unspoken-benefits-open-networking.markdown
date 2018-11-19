---
layout: post
title: The Unspoken Benefits of Open Networking
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2016-01-27"
slug: unspoken-benefits-open-networking
tags: ['networking']
---


[I have noticed](https://twitter.com/Mierdin/status/691183445083422720) a lot of very premature dismissal of a growing trend in the networking industry, which is the rise of open network operating systems. Nearly every post-announcement discussion that I hear among peers tends to sound something like this:

> I am not Facebook or Google. I don't want to install third-party software on my switches, so this "open networking" movement is not relevant to me or my organization.

I believe this sentiment is based on an incomplete understanding of all of the benefits of open networking. I'd like to bring up some additional points that aren't being discussed as much as others, as it pertains to open network operating systems. I believe these additional benefits apply to a very large spectrum of organizations, not just the top 1% webscale companies.

This is not to say that closed-source operating systems do not have a place anymore, or that the current participants in the open networking ecosystem are perfect, or that we have anything but a long road ahead of us in this journey...my point in writing this post is simply to illuminate parts of the conversation that deserve more attention.

We discussed open operating systems in a recent video-enabled [Packet Pushers Podcast](http://packetpushers.net/podcast/podcasts/show-272-bleeding-edge-nfd11/), immediately following [Network Field Day 11](http://techfieldday.com/event/nfd11/) (starts at 16:50)

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/ufGolasNmak" frameborder="0" allowfullscreen></iframe></div>

# Abandoning "Special Snowflake" Code

Right now, what's happening is that the software layer in networking is really starting to be commoditized. This kind of thing always starts at the bottom, and travels up the stack. Merchant silicon started this process at the hardware layer, and we're now seeing those parts of the operating system that each vendor implements in their own special way (for very little reason) become commoditized as well. Most vendors leverage Broadcom chipsets in at least part of their products; did this make the sky fall? Of course not - it is an acknowledgement that vendors don't need to do their own thing for the simple stuff. Extending this idea into the operating system layer is a natural next step of that evolution.

The question "would you position this software at the core of your network" is the wrong question for a few reasons. The first reason is a simple one - you should be running exhaustive tests on ANY infrastructure (HW and SW) that you place into a mission-critical role. That aside, it actually makes MORE sense to put widely used open source software into the core of my network than it would to use software that was made by a handful of engineers behind closed doors. If you think about this long enough, you begin to wonder how we've tolerated the existing network software model for so long. The linux community is **way bigger** than a small group of engineers working on a closed OS. It is worth taking advantage of this.

> Note that for this point, I am speaking mostly of platforms that don't require crazy features. The argument for specialized software makes more sense with  systems like load-balancers that require very specific optimizations (for instance a custom TCP stack) - though we're seeing alternative designs that erode even this model.

Dell recently announced their OS10 operating system, which is essentially Debian (Jessie) with some extra software installed. They took care to mention that they made no modifications to the provided kernel, and are providing value purely on top of this fundamental base.

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/iza1xF9Le0I" frameborder="0" allowfullscreen></iframe></div>

This model is extremely common amongst open NOS projects (i.e. [Cumulus](https://cumulusnetworks.com/), [OpenSwitch](http://www.openswitch.net/), [Open Network Linux](https://opennetlinux.org/)). It's worth mentioning that none of these projects started with a previously closed-source, specialized operating system. By and large, the trend seems to be that vendors are starting with a known base (i.e. Debian), and are building on top. This just makes much more architectual sense than the specialized, closed path.

# Modular == Stable, and Cost-Effective

Modularity in networking is currently an extremely underrated design criteria. Vendors have - for some time - operated in a model that more or less forces you to buy in to their model fully, unless you're willing to dumb your network down to the very small number of common features that vendors share between them. Vendors are also reinventing quite a few wheels when producing their closed network operating systems, and this effort is baked into the cost of their products. Starting with a common base means this doesn't need to keep happening.

In the video [shown previously in this post, where Dell discussed their OS10 announcement](https://www.youtube.com/watch?v=iza1xF9Le0I), I asked several questions about the architecture, and I was pleased to see that they built things in a modular way that doesn't force customers to follow a certain path. Instead of telling customers that they have to use the Dell SDN applications, they're building those applications as a simple app that sits on top of the switch OS - an app that you can use, or not use. If you wanted to go in a different direction, and install something else (i.e. Bird, Quagga), you could do that.

But, you say:

> I don't care what's under the hood, I am not a webscale company and do not need Linux on my switch.

This kind of thinking is second-nature to us, since we're still in the very early stages of this new model. However, if you think about it, this is not unlike someone that frequents McDonalds or Burger King. They don't care what they eat, or where it came from - just that it tastes good. You **really** should care at least a little bit about where our software comes from, especially as stewards of production infrastructure. Even if you don't have an immediate need for a bash shell on your switch, there are production pipeline benefits to be seen as well.

One of the biggest things that these open source network operating systems have in common is that they all use some kind of software application that runs in userspace (for the most part) and configures the kernel. Right now, in order to jump from one vendor's paradigm to another, we can just reinstall a new OS. In the future, (hopefully), even this will be unneccessary, as the OSs consolidate, and the vendor differentiation occurs in that userspace app. Migrating from one vendor's network to another will be as simple as uninstalling one vendor's "agent", and installing another. This is yet another step in the natural evolution. We're some time away from this becoming a reality, but I point this out to illuminate that it's not the operating system where the vendor provides value.

# Not Just Datacenter Technology

Many of the conversations I've heard about open networking center on the data center, and I think this is because of the tendency to talk about the big webscale companies when discussing this topic. There's also the undeniable fact that this trend has exploded, in no small part thanks to those webscale companies. However, I believe that once we've reached critical mass on a handful of choices, this technology can extend to other areas of the network as well.

The campus is an easy one - similar to the data center, those network devices do not require a huge feature set, so the hardware requirements are also not as high as, say, the WAN edge.

We have a lot of time before this becomes a reality, but I would just like to point out that there's not some kind of dealbreaker that prohibits open networking from penetrating the campus, or even the WAN, given enough time.

# Operational Flexibility

This is the one more-or-less "known" benefit, but worth mentioning anyways, because even this benefit is widely misunderstood. Yes, right now you may be thinking "I don't want to install something on my switch", but I think this could easily change in the next 5 years, as these NOSs become more popular.

I'd like to make two points here:

**Point One - Open networking does NOT implicitly mean that you have to change network operations in a radical way.** We're already seeing vendors build apps on top of an open base in order to ensure that customers have a seamless migration to the open platform. I have seen a lot of fear that with an open OS, suddenly network engineers have to configure switches through a bunch of text files.

You totally don't need to be forced to set up interfaces the Linux way. Vendors can build an "industry standard" interface on top of all this - and the [Quagga](http://www.nongnu.org/quagga/) project is a great example of this. Do not confuse good fundamental software design with an operational end-user interface. 

JUNOS is another great example of a neteng-friendly interface on top of a well-understood, base (FreeBSD). The idea that - just because you have an open NOS - you **have** to revolutionize the way you do networking in your organization, is absolutely false.

> In short, open networking vendors are not throwing you in the deep end and saying **"good luck with iproute2 noob!"**. They are still building a turnkey product for those that need this.

**Point Two - Guess What? The current operational models have huge faults.** Using the same tools to manage both your servers and the network switches is a good thing. Those workflows are several years more advanced than those used in networking. I would like to say that there are some very legitimate reasons for this - running a network is a totally different beast to running a fleet of servers. Nevertheless, some catch-up is warranted - and this new model is a great way to get there.

The idea that this operational flexibility only applies to those that have thousands of switches is based off of the (totally incorrect) idea that only those environments could benefit from network automation.

# Cost

I don't want to talk too much about this, since a lot of this depends on who you are, and what you're working with. Also, I'm no expert on the financial side of things. I would simply like to point out that the disaggregation of the OS from the hardware is really only possible when both components are produced in a low-cost fashion.

I've seen price comparisons, and I would encourage you to look into open networking, if only to see these numbers yourself.

# Conclusion

I think this is a very interesting time to be involved in networking. Clearly this is the direction that vendors want to go in, so I feel strongly that now is the time to learn new skills to become a [next-generation network engineer](https://keepingitclassless.net/2015/12/training-next-generation-network-engineer/).

> I attended Network Field Day 11 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
