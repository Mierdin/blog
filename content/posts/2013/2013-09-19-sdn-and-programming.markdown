---
layout: post
title: SDN and Programming (a.k.a. What The Heck is a REST API??)
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-09-19"
wordpress_id: 4626
slug: sdn-and-programming
tags: ['api']
---


Early on in my IT career I was fortunate enough to work with a few technologies and projects that forced me to get some decent experience writing code. While I've definitely moved into more of an infrastructure focus since then, this experience allowed me to get a firm grasp on good software development practices, and working with open communication formats between software systems.

If you're in networking, and have never heard of an API (Application Programming Interface) or haven't quite grasped the concept, it's quite simple. An API is essentially a definition of how software components can interact with each other. If your router or switch has "an API", it means that vendor has put into place some kind of mechanism where you can send it commands through more automated means than CLI (like a script). We're going to talk about one very popular type of API (REST) but first, let's clarify on what we get by abstracting APIs when it comes to SDN.

## The Benefit of API Abstraction in SDN

In this brave new world of Software-Defined Networking, it's clear that the crucial component of an SDN network is the communication between network elements - whether it's between a forwarding plane element and a controller, or between the controller and the applications or business logic.

Thanks to a ton of help from Brent Salisbury ([@networkstatic](https://twitter.com/networkstatic)), I've been exploring OpenDaylight, a project created to move SDN adoption forward by creating a modular framework where control functions and business logic can be used as needed to create an SDN solution. The following diagram from [the OpenDaylight site](http://www.opendaylight.org/project/technical-overview) presents the traditional 3-tier architecture that is usually seen when talking about SDN products (at least so far):

![](http://www.opendaylight.org/sites/www.opendaylight.org/files/pages/images/hydrogen_diagram_-_final_0.jpg)

### Southbound API

Let's say you have a few Open vSwitch instances, running OpenFlow. That's one way of communicating to network devices. How about some Juniper routers, with a puppet agent? You'll need to speak puppet to get those working. You may even want to scrape SSH commands to a device that doesn't really support much else (sucks, but at least it's something). The problem with this approach is that in order to do this, you need to build all of these "languages" into your business applications.

The benefit to a project like OpenDaylight is that all of these languages (and much more) are modularized, and placed in a repertoire of mechanisms that can be used to configure network devices. This device is your SDN controller, and these "languages" are commonly referred to as "southbound" APIs, because they are "below" the controller, which is an abstracted entity that sits above the physical or virtual infrastructure.

### Northbound API

You then need a way to interact with the controller, to instruct it how to configure these devices. Rather than knowing how to push SSH commands or OpenFlow entries, you are presented with a "northbound" interface or API, which provides a list of vendor-agnostic base network functions. You use these to configure your infrastructure, and the controller interprets into a language that each infrastructure node can understand. This API is commonly referred to as a "northbound" API, because it is the main way you communicate between the applications that run the business and your SDN controller. It's like a friendly interpreter!

This architecture is fairly common amongst SDN initiatives, and just as common is the reference to a REST API. Folks with decent software exposure may know what this is, but many of the users of an SDN solution probably don't. So what the heck is a REST API, and why do we need it?

## An object at REST...

Projects like OpenDaylight are getting so much attention right now because they represent a big effort in the SDN space to make things very modular and interoperable. Where one vendor's SDN controller may only work with their hardware/software platforms (because the controller is closed-source for instance), OpenDaylight has the potential to speak any language you want.

This interoperability is not always guaranteed, however. Some vendors have taken it upon themselves to present an API that's not really easy to use (aside from the fact that many times it's just really not well-documented)

A REST API, or an API that is RESTful (adheres to the contrains of REST) is not a protocol, language, or established standard. It is essentially six constraints that an API must follow to be RESTful. The point of these constraints is to maximize the scalability and independence/interoperability of software interactions. A no-brainer when it comes to SDN. I'm going to **attempt** to identify the constraints of REST while providing a translation of how each might help us with our SDN platform.

> The concept of REST was actually introduced by Roy Fielding [during his doctoral dissertation](http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm).

These six constraints are:

  1. **Client-Server** - This relationship must exist to maximize the portability of server-side functions to other platforms. With SDN, this usually means that completely different applications, even in different languages, can use the same functions in a REST API. The "applications" would be the client, and the controller would be the "server".

  2. **Stateless** - all state is kept client-side, the server does not retain any record of client state. This results in a much more efficient SDN controller.

  3. **Caching** - just like "cookies" in your web browser, it's a good idea for the client to maintain a local copy of information that is commonly used. This improves performance and scalability, because it decreases the number of times a business application would have to query the network's REST API. Some functions should not be cacheable, however, and it is up to the REST API to define what should be cached.

  4. **Layered System** - many times a system of applications is composed of many parts. A REST API must be built in a way that a client interacts with it's neighbor (could be a server, load-balancer, etc.) and doesn't need to see "beyond" that neighbor. This idea is evident in the three-tiered architecture I showed above. By providing a REST API northbound, we don't have to teach our applications how to speak southbound languages like SNMP, SSH, Netconf, etc. etc.

  5. **Uniform Interface** - no matter the information retrieved, the method by which it is presented is always consistent. For instance, a REST API function may return a value from a database. It does not return a database language, but likely some kind of open markup like JSON or XML (more on this later). That markup is also used when retrieving something ENTIRELY different, say the contents of a routing table. The information is different, but it is presented in the same way.

  6. **Code-on-Demand** - this is actually an optional constraint of REST, since it might not work with some firewall configurations, but the idea is to transmit working code inside an API call. If none of an API's functions did what you wanted, but you knew how to make it so, you could transmit the necessary code to be run server-side.

Again, the point of all of this is to maximize the usefulness of an API to provide services to a large number and variety of clients, which in the case of SDN is likely to be our business logic applications or cloud orchestration (like OpenStack).

When the rubber meets the road, a REST API can be no more than a simple web server that accepts HTTP POSTs, GETs, etc. Usually there's something inside these requests like [XML](http://www.w3schools.com/xml/), [JSON](http://www.json.org/), [SOAP](https://www.w3schools.com/xml/xml_soap.asp), or others, but that part isn't as important, since these are all open standards that are well understood at this point.

I hope I clarified REST for you and added some insight into what it means for tomorrow's SDN builders.
