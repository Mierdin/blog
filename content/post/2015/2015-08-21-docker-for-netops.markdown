---
layout: post
title: Docker for NetOps
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2015-08-21"
slug: docker-for-netops
tags: ['nuage']
---


I have been spending this week in Silicon Valley at [Network Field Day 10](http://techfieldday.com/event/nfd10/). One of the announcements struck a chord with me, as this year has marked some significant career changes for me: specifically an uptake in involvement with containers and software development.

My good friend Brent Salisbury once wrote about the idea of [using Golang for Network Operations tooling](http://networkstatic.net/golang-network-ops/). While I've continued (and will continue) to build my Python skillset, I've also been getting more and more experience with Golang and with some of the great software projects created by it, such as Docker, and Kubernetes.

Brent has also more recently written about using [Docker to build network tools](http://networkstatic.net/building-network-tools-using-docker/), and I'd like to use this post to say I agree with this sentiment. Network Operations can really do more with container technology to accelerate what has traditionally been a pretty stagnant silo.

Fundamentally, the concept of application of containers is not that new, and admittedly, network engineers have not been required to think of them. I mean network operations is only _now_ getting accustomed to delivering network services in form factors like virtual machines. It's important to remember that solutions like Docker have provided application developers with an consistent format for packaging what they produce. In network operations, we can take advantage of this same tooling - instead of asking our network vendors to make sure Python is installed on our switches, we need them only to support Docker.

# "Docker is in the Network!"

At NFD10, we saw a few real-world examples of leveraging existing network infrastructure for deploying tools quickly using Docker.

<iframe width="560" height="315" src="https://www.youtube.com/embed/uhz1qtGFTdY" frameborder="0" allowfullscreen></iframe>

A few notes here:

- Though many of the demos and ideas floating around were network-centric, that doesn't mean only network tools can/should run on a branch router. Concievably, others would be useful as well ([Larry Smith](https://twitter.com/MrLESmithJr) brought up local PoS transaction processing in case of a WAN outage). There's some benefit here; if the branch router is powerful enough to run both network and business applications, the need for local dedicated compute resources is diminished.
- My question on schedulers didn't quite get answered in the session, but I was able to get more information afterwards. In essence, Nuage isn't using anything like Swarm or Kubernetes (currently) but instead is sending commands down to each individual branch device, and that device will do a "docker pull" locally. This can be done to Docker Hub, or a private Docker registry. Admittedly there are a lot of orchestration tools out there, so this will undoubtedly take some time to integrate.
- There is a huge use case for network agents to run on individual branch devices to simulate network traffic and provide enhanced visibility into WAN performance. I've had a lot of ideas on this topic lately and hope to share more with the community in the months to come.

I also think it's worth mentioning that this kind of statement from a network vendor is - from my perspective - unprecedented.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">The statement that Nuage is making that containers will be a big part of network operations future....that&#39;s gotta be unprecedented. <a href="https://twitter.com/hashtag/nfd10?src=hash">#nfd10</a></p>&mdash; Matt Oswalt (@Mierdin) <a href="https://twitter.com/Mierdin/status/634539879813259265">August 21, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

We've known for a while that virtual machines have placed unprecedented demand on the network, and that the density enabled by moving to containers will multiply this problem. I know it, you know it, and all of the SDN vendors have had this statement in their briefings from the early days. However, the idea of explicitly leveraging containers for network operations is a **big deal**, and something that we as an industry should be paying attention to.

All of this is compelling in no small part to the fact that these branch devices are running on standard x86 platforms, which means that I can get all of the SDN-WAN functionality Nuage excels at, and I may not have to invest in separate hardware for my local branch applications.

# Conclusion

I think it's important to take this as just another example (see [my previous one](https://oswalt.dev/2015/01/continuous-integration-pipeline-network/)) proving that network operations is moving to a software-centric model. Some of this will involve changes in technology, but also lots of changes on the people and process side. The idea of using Docker for network operations isn't just about a shiny new tool, it's more about what that tool implies - dealing with your network tooling in bite-sized chunks (don't make me say microservices) and thinking about that tooling in the same way that developers think of their repository artifacts.

The future is here. The time is now to evolve your skillset to leverage the advanced in network and automation tooling to help your network infrastructure become more transparent and enable the business better.

> I attended Network Field Day 10 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://oswalt.dev/disclaimers/))