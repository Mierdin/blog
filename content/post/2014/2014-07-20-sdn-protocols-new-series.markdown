---
layout: post
title: '[SDN Protocols] - New Series'
series:
- SDN Protocols
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2014-07-20"
wordpress_id: 5890
slug: sdn-protocols-new-series
tags: ['protocols']
---


The networking industry in the last few years has seen an explosion in buzzwords, slide decks, new technologies, and SDN product announcements.  The honest truth is that the networking industry is still in a great state of flux, as we collectively discover what SDN means to us.

There's a lot of new terms floating around, and what makes things even harder to keep up with, the marketing engines are alive and well - muddying the waters, and making it nearly impossible to get technical facts straight. I'm fortunate enough to know a few people that remind me that what matters most is when the rubber meets the road (which usually manifests itself in "shut up and code").

![SDN cat](assets/2014/07/52770151.jpg)

To that end, I am kicking off a series that will be completely dedicated to explaining the various protocols and technologies you might encounter in researching SDN.

## Who Can Use This Series?

If you're into open source implementations, all of this will be immediately relevant. Much of what I'll be exploring pertains to the nitty-gritty under-the-covers operation of these protocols, and will often use real-world examples rooted deeply in open source, such as Open Daylight, and Open vSwitch.

However, If your experience is/will be limited to closed implementations like NSX or Cisco ACI, this knowledge is still valuable, because these "building blocks" all fit into the bigger picture that is SDN. These building blocks will allow you - the engineer or administrator - to make better decisions about what technologies are best suited for your business needs.

## Leaving SDN Extremism at the Door

Occasionally, someone will ask me what I think about some SDN product that a vendor recently announced. Without getting into the technical details, my response is usually something like "it's a tool". This is because each of these products (and the protocols I'll be discussing in this series) make up only one piece of the greater puzzle. The networks of tomorrow may heavily utilize these technologies, but one thing will remain the same - each network will be different, and each organization will have different requirements.

There's been quite a bit of "protocol wars" in recent years - as vendors vie for potential SDN market share, a few marketing machines have been on full blast, usually making some factually incorrect statements in order to make what might have otherwise been a valid point. While this certainly doesn't describe every vendor, nonetheless, I'm writing this series with the simple motivation of achieving technical accuracy, and highlighting the key points for readers who are looking to implement these technologies now or in the future.

As a result, this series will **not** contain any sort of "protocol wars" talk. I will simply highlight some potential strengths and weaknesses where relevant.

## Let's Go!

As always, I strive to make my motivation for writing nothing more than a simple desire for factual accuracy. I try to  establish the relevancy of a particular piece of technology to the real "boots on the ground" in today's industry. To that end, if you discover any factual errors in any of these posts (or, as usual, any of my posts), feel free to point it out in the comments section below and I'll be happy to make sure technical accuracy is preserved.

These are all just tools. My goal is to illuminate the technology itself, and provide a clear perspective on how it works under the covers. As a result of this clarity, I believe purchasing decisions (or the decision to build it yourself) will be much clearer; you'll be properly armed to cut through the marketing sludge that has unfortunately permeated our industry as of late.
