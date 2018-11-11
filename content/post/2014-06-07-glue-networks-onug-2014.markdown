---
layout: post
title: Glue Networks at ONUG 2014
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2014-06-07"
wordpress_id: 5856
slug: glue-networks-onug-2014
tags: ['glue', 'networks']
---


Glue Networks had a presence at the last ONUG, where Tom Hollingworth was able to get an overview from Glue's founder, Jeff Gray:

<iframe src="https://player.vimeo.com/video/80380278" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

As you can see, Glue's product targets the WAN, and specifically addresses the difficult provisioning tasks that most shops do manually. These include but are not limited to:

  * Provisioning (and deprovisioning) of QoS resources for various applications like SAP and Lync based off of need and time of day.
  * Bringing up remote sites in a standardized, cookie-cutter manner	
  * Creating and changing PfR (performance routing) configurations on the WAN.

Jeff visited our Tech Field Day round table at ONUG 2014 and gave us a more detailed introduction to the product:

<iframe src="https://player.vimeo.com/video/94543395" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

First, some things I think this product does (or will do) well. The configuration of PfR or QoS en masse is a low-hanging use case I've mentioned before and even if I can do it using scripts today, having a single tool that does it in a simple way will provide value. These specific configurations are difficult and error-prone, so anything that tackles this is going to be useful.

I also did enjoy hearing about the options for getting the config onto the device. Jeff listed three options for getting a Cisco router to hook into the Gluware engine:

  1. You can order the box to have the outside interface enabled, and with DHCP - that has it's own SKU. You'd have to use Glue's tool to do some magic, but that's one option.
	
  2. Option two is a small bootstrap config on the USB drive in the router, which calls home and you go from there. No blue cables.
	
  3. Option three almost sounds like Glue is working with Cisco to get a small agent baked into IOS. (How about you instead get Cisco to properly support something like NETCONF? Just saying.) This is not available yet.

On the other hand, there were a lot of things about this product that did not jive with me. From a programmability perspective, Jeff said that they do it the hard way today (SSH, SNMP, TICL, EEM), and in the future they're going to try to work with Cisco's APIC-EM (which from my understanding will be entirely based on onePK). None of this impresses me - we need better programmability options, and Glue seems content with "barely usable".

One of the first slides mentions an "open system with northbound and southbound API's for 3rd party integration" but to be honest, this just sounds like gratuitous use of buzzwords. Jeff didn't mention anything regarding an abstraction layer that would normalize REST calls to various southbound calls, which would mean that I will need to use Cisco CLI syntax in my REST calls to Gluware. Not exactly that much better.

Jeff also mentioned their software does some kind of configuration error checking, but I failed to ask how this is being done. I would be glad to hear from someone in the comment section below on this topic, since there could be quite a bit of value here.

I get that it's easy to speak negatively about the use of scripts that are "on engineers' laptops" - but I didn't see how Glue goes beyond this, other than the pretty GUI. To me, this looked like a product that threw most of it's design into the pretty visuals and animations. I classify what I saw as "unidirectional automation" - configuration elements get thrown onto the boxes, but little to no feedback is provided to drive the next system. I honestly believe most savvy engineers could do this with a few well-designed [Jinja2 ](https://keepingitclassless.net/2014/03/network-config-templates-jinja2/)templates and a web framework like Django. And many already are.

This is a typical example where the "software-defined" label is just slapped on the side of a product. Good unidirectional automation, yes, but I didn't see anything that I could rely upon to make application-level decisions based on network activity or changes. So in summary, if you're doing little to no automation at all on your network, and you have a WAN use case that requires en masse changes of the things Glue is able to demonstrate today, such as PfR or QoS, then Glue sounds like a solid option. My opinion is that my current toolkit can get the job done.

> I attended ONUG as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
