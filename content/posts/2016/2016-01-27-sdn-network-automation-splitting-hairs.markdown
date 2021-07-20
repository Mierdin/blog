---
layout: post
title: 'SDN and Network Automation: Splitting Hairs?'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2016-01-27"
slug: sdn-network-automation-splitting-hairs
tags: ['networking']
---


At the recent [Network Field Day 11](http://techfieldday.com/event/nfd11/), there were several discussions at the Cisco offices after the Cisco folks left the room. One of these discussions, led by Terry Slattery, was centered around SDN, and I think it's worth a listen/watch (only about 20 minutes):

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/yRVN7o21_4s" frameborder="0" allowfullscreen></iframe></div>

In this video, I made the argument that SDN should be limited to a very specific definition, which eliminates the management plane from the conversation entirely (around 5:40). 

I am in full agreement that the term SDN, or "software-defined ____ " is at this point totally meaningless. It means so many things to so many different people, and predictably, this conversation ended with just as much confusion about SDN as when we started. So, to try to "define" SDN seems pointless, and smells of hair-splitting, but I do this for a very specific reason.

# Splitting Hairs

To me, SDN and network automation are two totally different things, yet they almost always get lumped together in conversations. Normally I wouldn't try to remedy this, but since one of these things is *a practical thing to do for many organizations*, I want to offer up a different way of thinking about this.

First off, **you do not have to go buy a shiny new product, or hire a bunch of developers, in order to improve network operations with automation**. [I am working with some good friends in the community to make this even more approachable to everyone](https://oswalt.dev/2015/12/training-next-generation-network-engineer/). Network automation is not some lofty goal that only the top webscale companies have any business even looking at. This can (and should) be done at any scale. Because [network automation isn't just about speed](https://oswalt.dev/2014/12/automation-isnt-just-speed/).

Network automation is not just a technology, but more a methodology - a journey that anyone can and should embark on to improve network operations, regardless of scale.

To me, SDN is a very specific thing. It could be a product, or a project, but either way it is a very tactical idea. A tool to be used to solve a problem that frankly does not exist for many small-to-medium businesses. However, network automation **is actually within our grasp** because it's something we can do ourselves, today, regardless of our organization's size.

Do not assume that since you aren't Google or Facebook that learning automation is not valuable. Many companies have development teams and/or are moving towards an in-house software development model, so now the right time to begin to build a more flexible, programmable infrastructure. Even if this is not the case, the vast majority of network problems in my experience have stemmed from either inconsistent configurations, or improper testing. Automation can and should help with both of these, regardless of scale.

# Conclusion

Please, please, please, do not write off anything to do with automation because the vendors and the tech journalists have beaten the term "software-defined" to the point where it's meaningless. There is some good stuff here, and you'd be best served to look into it.

I encourage you to reach out to me, or to some other great folks in the community ([Jason Edelman](https://twitter.com/jedelman8), [Scott Lowe](https://twitter.com/scott_lowe), and many others) for any questions about how to get started. A lot of this stuff is within our grasp today.

> I attended Network Field Day 11 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://oswalt.dev/disclaimers/))