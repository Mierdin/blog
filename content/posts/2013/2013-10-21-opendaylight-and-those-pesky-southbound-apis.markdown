---
layout: post
title: OpenDaylight and Those Pesky Southbound APIs
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-10-21"
wordpress_id: 4751
slug: opendaylight-and-those-pesky-southbound-apis
tags: ['code']
---


In case you've noticed I've been pretty quiet - I'd be lying if I said my day job wasn't at least partially to blame. However, a good chunk of my free time has also been spent jumping back into the software development game. I was never really a "programmer" in the common sense - I've always written code strictly as part of an infrastructure effort. My first "job" that involved writing code was on a VoIP team for a retail company, creating web service-type applications that interacted with the voice infrastructure; think "IVR" on steroids.

In the past 4 years since then, I've rarely used that skillset, writing the occasional script, but on the whole being an "infrastructure guy". After all, there was a lot to learn. The OpenDaylight Project, however, was just interesting enough to me that I decided to put off my networking studies for just a little longer to get back into really **writing code**. And let me tell you....using the two skillsets together feels really good.

As I've mentioned before, the [OpenDaylight Project](http://www.opendaylight.org/) (ODL) is an open source project aimed at providing an common framework for doing SDN. This means that we don't have to choose OpenFlow, or onePK, or SNMP, or Netconf, etc. as the end-all be-all API for programming our infrastructure. Instead, all of these are abstracted behind generic network logic, and OpenDaylight translates between the two. This means you don't have to teach your applications how to speak OpenFlow, or anything like that. One common framework to interact with the network that isn't restricting you to one or a few southbound APIs.

[![](http://www.opendaylight.org/sites/www.opendaylight.org/files/pages/images/hydrogen_diagram_-_final_0.jpg)](http://www.opendaylight.org/sites/www.opendaylight.org/files/pages/images/hydrogen_diagram_-_final_0.jpg)

Most of the contributors to the ODL project work for vendors like Red Hat, Cisco, etc. but the project is still completely open. I'm just some guy that happens to know infrastructure and code, so I reached out to see where I could help, and a few days later, I made my[ first commit to the project](https://git.opendaylight.org/gerrit/#/c/1919/).

My initial contribution to the OpenDaylight project is through the module that allows ODL to speak OVSDB - a JSON-RPC based language that allows you to configure the database on top of Open vSwitch. Brent Salisbury has a great post on [how you can get involved with ODL and OVSDB](http://networkstatic.net/getting-started-ovsdb/).

Kyle Mestery has put forward a [blueprint for OpenStack Neutron](https://blueprints.launchpad.net/neutron/+spec/group-based-policy-abstraction) that really simplifies the existing network provisioning model. Instead of worrying about network-specific things like subnets, routers, and networks, the application developers specify things like application relationships, and general policies - which is all they care about. Neutron then works with an external entity like ODL that takes care of the network-specific stuff. I've [written in the past about the benefit of abstraction](https://oswalt.dev/2013/09/sdn-and-programming/) like this.

There's a few examples of this today - think about port profiles in VMware vSphere, or virtual NIC templates in Cisco UCS -  the details concerning the network connectivity aren't important to those consuming these policies - they just want to be able to select them from a drop-down. That's essentially what we're getting, only with this, we're abstracting the entire network and the services it provides.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/jamesurquhart">@jamesurquhart</a> <a href="https://twitter.com/mestery">@mestery</a> <a href="https://twitter.com/alagalah">@alagalah</a> I totally agree. Dev requests a simple abstraction of service. Neutron / ODL implements that</p>&mdash; Colin McNamara (@colinmcnamara) <a href="https://twitter.com/colinmcnamara/status/390956420255870977">October 17, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I refuse to get into a religious argument about whether or not OpenFlow is the future, or if it's crap, because those are absolute statements. In networking, or IT generally, there are really no absolutes. IT almost by definition is a hodge-podge of systems that we integrate togther with protocols and features. Therefore, any solution that is so broad as SDN or SDDC, should focus on including as many tools in the toolchest as possible, then abstracting the use of these tools behind a single, common framework. For me, OpenDaylight is really the first framework that does this, because it's built from the ground up to be modular, not single-solution.

SDN is not defined by OpenFlow. It's not defined by onePK. It's not defined by Open vSwitch. It's not defined by Insieme. It's not even defined by Open Daylight. Software-Defined Networking is a popular topic only because some folks got together and started talking about ways to solve some pretty huge looming issues with network provisioning and management. Getting bogged down in all of the tools is missing the point. SDN is defined by how you're solving the problem of managing your network, with respect to providing your applications with the resources they need. If you wanted to write an application that effectively "screen-scraped" SSH sessions to all of your network devices and call it SDN - I might challenge you and say that there's an easier way to do it, but if you've effectively improved the provisioning time for your applications, who am I to say that isn't SDN if is provides the solution you needed?

## On a lighter note....

Every once in a while, I feel jealous of those that got to build the first ever networks that made up the internet. To be back in those "golden years" would have been an extremely awesome opportunity. However, I have these thoughts less and less these days. While it's true, the marketing engines are still firing on all cylinders, the emphasis on community-based development has never been higher, and networking is receiving it's first innovation shot-in-the-arm in....well, a long time. The golden years that started the internet are long gone, but the golden years that will define the next few decades of networking are happening right now.
