---
layout: post
title: Useful OpenFlow Resources
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-09-15"
wordpress_id: 1089
slug: useful-openflow-resources
tags: ['onf']
---


![](/assets/2011/09/openflowlogo-300x289.png)

I wrote a [post](https://oswalt.dev/2011/06/introduction-to-openflow/) a while back introducing OpenFlow, and I informed you of my thoughts concerning this relatively new technology. Regardless of your need for a programmable network, the concept is certainly interesting and warrants some tinkering. It's important to remember that OpenFlow itself is just a protocol definition, and until recently, there wasn't a lot of software available that implemented it, and thus, no in-home tinkering. I'd like to point out a few new projects that are implementing OpenFlow and making it relatively easy to implement on your own.

## OpenFlow

If the OpenFlow specification had a home, this would be it. The OpenFlow specification is hosted at this site, which is run by the Open Networking Foundation. These guys created the OpenFlow specification back in 2008. If you're just learning about OpenFlow and want to go over the basics, this is your first stop.

The OpenFlow site can be accessed at: [http://www.openflow.org/](http://www.openflow.org/)

For more information on the Open Networking Foundation: [https://www.opennetworking.org/](https://www.opennetworking.org/)

## OpenFlow Hub

OpenFlow Hub is an organization responsible for the creation and maintenance of several new projects related to OpenFlow. The site lists a few:
	
  * Beacon - Java-based OpenFlow controller	
  * RouteFlow - provides virtualized IP routing services over OpenFlow-enabled devices.
  * Indigo - Open Source switching firmware that's OpenFlow-friendly.
  * SNAC -An easy to use OpenFlow controller with a graphical user interface

These projects form a portfolio of technologies that can be used to get an OpenFlow network up and running. I would recommend this site to anyone that has read the OpenFlow specification, and has a basic understanding of it, and wants to move to the next step and implement it.

For those looking to do some tinkering, I would recommend SNAC. This is a software package that allows you to set up an easy to use OpenFlow controller with a graphical user interface. I will likely try to get some time to work with this and post some details in a future article.

For more on this and the other projects by OpenFlow Hub: [http://www.openflowhub.org/](http://www.openflowhub.org/display/Home/Home)

## NOX

NOX is an OpenFlow controller that's slightly more complicated than the previously mentioned SNAC. NOX is more of a framework, as it allows you to write network control software yourself in C++ or Python. For those who want even more granularity, this is for you.

For more information on NOX: [http://noxrepo.org/wp/](http://noxrepo.org/wp/)

I included these three because I wanted to give one for those just getting into it, those wanting to tinker, and those wanting to actually write network control software. These tools should get you going in the right direction. If I missed a resource you feel warrants mention, let me know in the comments.
