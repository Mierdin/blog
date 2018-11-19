---
layout: post
title: Intentional Infrastructure
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2018-02-04"
slug: intentional-infrastructure
tags: ['network', 'field', 'day']
---


I gave a presentation at the recent [Network Field Day 17](http://techfieldday.com/event/nfd17/) (on my 3rd day working for Juniper). My main goal for this presentation was just to get people excited about building stuff.

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/pHwkwjd2WtQ" frameborder="0" allowfullscreen></iframe></div>

We tend to focus on vendor-provided solutions in this industry, and there's a lot of good reasons for that, but it's also good to stay sharp and be able to build your own solution to fill gaps where necessary. One reason I joined Juniper is that much of what we offer is built on a highly programmable foundation. So you get the best of both worlds - high-level products to solve the hard problems, but you still have the ability to insert your own custom tooling at various points in the stack.

In the above video, I outlined a simple [Github-available demo](https://github.com/Mierdin/nfd17-netverify-demo) for applying policies to a vSRX based on the existing services running in Kubernetes, and then verifying those policies are actually working by again using Kubernetes to determine what applications should be available.

> [My demo](https://github.com/Mierdin/nfd17-netverify-demo) is designed to be self-sufficient, meaning you should be able to follow the README and get a working demo. Feel free to watch the above video first for context, then follow along on that repo to get it working yourself.

All of this was done in the context of discussing what "intent-driven" means to me, and I thought it important to summarize those thoughts here.

# What is Intent All About?

I think it's safe to say we're mostly past the Software-Defined Networking (SDN) hype cycle. And after the SDNocalypse, in retrospect, I think SDN didn't quite have the same direct impact many thought it would based on the hype. After the dust settled, the real impact was felt in the wildly different way we were talking about networking, and this was a very real impact.

Similarly, "intent-driven" is in full hype cycle mode right now, and it's easy (and prudent) to be skeptical about the whole thing. Again, however, once the dust settles, there will be very real lessons learned from all this, and I'd like to spend a little time talking about what I think this will (or at least should) be.

Just like what happened with SDN before it, the whole "intent-driven networking" thing has become all about network engineers; a.k.a. "What is the intent of the network engineer"? I've found most of these analogies to be fairly weak. Usually the examples provided are something along the lines of "I intend for the network to stay up and running". Well.....duh? I think everyone wants that. Let's not conflate "intent" with "competent operations". There are a number of tables stakes that must be accepted before we can move forward, and network reliability is one of them.

To me, the interesting intent - the thing that goes above and beyond "competent operations" - is on the applications side. Automation isn't just about configuring network boxes, it's about providing services to what's using the infrastructure - the applications. And no, this isn't just about the datacenter. Applications use your branch office networking and backbone just as much as the datacenter network. So we have to start thinking about the useful intent in these terms: "What is it that the applications are expecting from my network?" - not just as a transport, but also in terms of network services.

<div style="text-align:center;"><a href="assets/2018/02/makeitso.jpg"><img src="assets/2018/02/makeitso.jpg" width="500" ></a></div>

In 2018, we actually have it pretty good. The cloud-native wave has made application intent **way** more accessible, as applications deployed to platforms like Kubernetes are much more self-describing. Kubernetes offers its users primitives for declaratively describing what their applications need, and the underlying infrastructure "makes it so". Most Kubernetes users think of "infrastructure" as the compute node the kubelet is running on, or the virtual network between these nodes, etc - but it doesn't have to be limited to this. We can use this same source of truth to proactively enforce policies elsewhere. This original intent is an API call away in many cases. So we simply need to go get it.

# Proactively Seeking Out Intent

Let's talk about what it might take to design and build a bridge. I'm no expert, but I think it's fair to say that for most drivers, you just drive across it. You don't need to know the materials the bridge is made of, or call ahead to let the bridge people know you're thinking about driving across it, you just use the bridge. The engineers and architects that built the bridge recognize that this is the desired experience, and they take on the responsibility of researching and understanding the expected traffic patterns and types of vehicles that will use the bridge. They build a bridge that meets those requirements. They maintain the bridge over the long-term to ensure that this bridge continues to operate as desired.

<div style="text-align:center;"><a href="assets/2018/02/bridge.jpg"><img src="assets/2018/02/bridge.jpg" width="500" ></a></div>

At **no point** do these engineers need to have an ongoing conversation with the average driver. They know that they're relied on to provide infrastructure, so they proactively go out and get the information they need to provide this service.

Similarly, AWS doesn't make you, developers or SREs configure their network switches. AWS offers primitives and APIs for describing what you want, and all of their underlying infrastructure comes up to meet that requirement. Similarly, if you're running your own infrastructure, this is "the new normal".

It's no longer sufficient to make the network the center of the universe; it has to be 100% all about the applications, and we need to begin to focus on making the network an accessible service in order to even stay on par with what cloud services are providing. It doesn't matter that devs don't know how to subnet, or how OSPF works. They shouldn't. The network can and should stop being such a black box, and the only way this will happen is if the intent of the application is proactively sought out.

# Conclusion

Infrastructure operators are going to need to step up and reach outside their domain for this intent, and change their processes to make this the new center of the universe. Network automation in any form cannot become all about making the life of the network engineer easier. Yes, this is a very attractive and real benefit of automation, but it cannot be the end goal. It **must** be all about making the network more responsive to the applications that rely on it, and in order to do this effectively, automation workflows must interact with technology outside of networking.
