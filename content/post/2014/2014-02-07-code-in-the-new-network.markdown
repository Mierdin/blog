---
layout: post
title: The Role of Code In "The New Network"
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-02-07"
wordpress_id: 5456
slug: code-in-the-new-network
tags: ['automation']
---


I was inspired by many little things over the past few days to begin writing a post about this whole "writing code" thing that network engineers the world over have been asking about.

I've said before I know that most network engineers already write some kind of code - even if it's as simple as a snippet of VBA in an Excel spreadsheet to automatically convert a spreadsheet of configuration options into an actual running configuration. I believe I also said I thought that was pretty boring.

The big gaping hole I intentionally left in my post last week titled "[Why Python?](https://keepingitclassless.net/2014/01/why-python/)" is going to be addressed in this post. What does the network engineer of the future - empowered with a brand new software-defined network infrastructure - look like?

This post is aimed primarily at discussing the changes that will come about in the next 5 years or so - not a far-fetched distant future conversation. I've been told on many occassions from close friends and colleagues that a lot of the discussions around SDN don't seem very relevant to the here and now. Hopefully after this post you'll have a better sense for the options we have (or will soon) to choose from when it comes to networking, automation, orchestration, and BREAKING DOWN THOSE UGLY SILOS!

## 1. Policy or Workflow Engine

In this model, actually writing any form code is optional. I have come across this method in several forms now: Plexxi's Affinity API and Cisco's ACI come to mind. These products will form a framework where a network engineer can go in, declare what they believe a single application should be able to do (simple things like addressing and security policies), then also configure linkages between those declarations to also state how those applications (or tiers/segments of a single application) should interact.

I've done plenty of posts on both of these specific implementations, so the point I'm trying to make is that these engines will be fairly easy to use, in that the network engineer is not going to be wholly responsible for ensuring that policy is applied in the right places anymore. What we've been hearing from the server admins is that they want the network to be a consumable resource - well this does just that. The network guy will go in and define a profile

By the way, this isn't really new - we've been doing this for years with a little concept called "port groups" or "port profiles".

    1KVVSM# show run port-profile NFS

    port-profile type vethernet NFS
      vmware port-group
      switchport mode access
      switchport access vlan 260
      service-policy input TAG_COS_2
      no shutdown
      max-ports 96
      state enabled

These new concepts don't change that model at all - however the scope of where these policies can be applied and the functionality abstracted behind them is orders of magnitude more powerful (hopefully something beyond "let me apply a port group so you can get a 802.1q tag - yay me!")

I also included the term "workflow" in titling this section because - while it is by no means the definition of SDN - the concept of automation is a big part of it. Workflow engines have been around for quite some time, and I think they have a big place in the future of not only networking but the entire data center. If you're using change management at your company, there's a pretty good chance there's a workflow engine behind it. Something that tracks where in the process a certain change request is, gets approvals from those in charge, send emails to notify the various teams, etc.

VMware has a leg up in this respect - while every vendor has something similar, vCenter Orchestrator has existed for quite some time, and I've found it to be very feature-rich and stable. Most assume that vCO is something you have to use with vCenter, but it's not (bad product naming from VMware - shocker). vCO is actually a really powerful standalone workflow engine. You don't even have to use it to automate virtualization tasks - you could use vCO for the change management concept I gave earlier - because it's just a workflow engine. You should be able to use tools like this to automate various network tasks, even if it's as simple as SSH scraping:

[![vco2](/assets/2014/02/vco2.png)](/assets/2014/02/vco2.png)

> That's a real screenshot of a default workflow in vCO - I didn't even have to modify the workflow but could if I wanted to. Was surprised to see this - this kind of workflow could easily be used to make quick network changes.

It's quite possible that "programming" the new network could happen using tools like these - policy-driven software or workflow engines that support designed policies by network engineers, and the consumption of those policies by everyone else. However, this method has a pretty big caveat - you're still on the hook for the vendors to get you the functionality you need.

## 2. Full-Blown Development

On the complete other side of the spectrum, you have projects like OpenDaylight. These projects have a lot of promise, and for a list of reasons way too long for this post. Suffice it to say that ODL's open source roots, the extremely passionate (you have no idea) community that is building it, and the modular nature of the project that allows you to choose what tools are appropriate for your environment. The business logic that you put into place doesn't need to change when these nerd-knobs change either. That's the beauty of the abstraction the ODL framework provides.

However - as I've learned in my own experiences with ODL, this is not a simple scripting excercise. Like OpenStack, if you plan to leverage OpenDaylight in your own environment, it's definitely a good idea to essentially hire an army of developers to maintain it and tweak it's functionality to fit your business case. The cool thing about this - and the reason I'm involved with the project - is that this gives you a lot more control over your infrastructure, and if your use case impacts a significant group, you could push this code upstream so that others can do the same thing.

In my experience, much of what I just said falls on deaf ears when it comes to network engineers. And that's okay.....this culture has yet to truly permeate the networking industry. The biggest impacts in this space lately include projects like ODL, but also Openstack Neutron, and of course - Open vSwitch. But still, traditional network engineers have yet to even look at many or all of these projects. They're still weighed down by the list of tasks they need to get done by the end of the week on their massive, black-box infrastructure.

It also doesn't help when those that do have the time or the inclination ask "How can I get involved?" and the answer is "learn programming". Most engineers have basic scripting skillsets, but project like ODL and Openstack require a lot more than that. There are frameworks to adhere to, classes to build, interfaces to consume, methods to write. Many of these concepts are foreign to network engineers who have at most written or copied a script to automate one single task. In their eyes, they live deep within the big black section on the below chart (one of my favorite and most-referenced XKCD strips of all time):

[![](https://imgs.xkcd.com/comics/is_it_worth_the_time.png)](http://xkcd.com/1205/)

Given the amount of time they currently have on their plate (none) and the amount of learning they feel like they'd have to do

Now - there's a middle ground here I'll discuss in the third point but I want to take a moment to address those that fit this description. Please PLEASE do not assume that "learning programming" is a prerequisite for contributing to a big honkin' project like OpenDaylight. Everyone on the project (or other projects for that matter) will likely tell you to contribute early and often. This means that small, bite-sized chunks are best for those that are just learning. And guess what? You don't even have to write functional code! You could edit wiki pages, annotate code with comments inline, or support the community in other ways - all are very valuable contributions. Please don't make the mistake of believing that you have no value to give until you've mastered even one programming language, be it Java, Python, or BASIC (*shudder*).

## 3. Hybrid Approach

I believe that the future will largely consist of a mixture of the the first two approaches. First off, a vendor-supplied framework for getting the "structure" of automation as opposed to developing your own) is immensely valuable to those with limited time. That's why I specifically mentioned workflow engines like vCenter Orchestrator. These allow the general overview of an automated process to be defined very quickly and easy using a GUI, and a palette of tools.

There's more than can be done here though - one of the most powerful features that a workflow engine like vCO can have is extensibility - the ability to write little snippets of code that accomplish a single task that's not already offered on the platform, and are able to both accept and produce a variety of data.

Since I'm talking about vCO, it's worth mentioning that there is a node type called "Action" whose sole purpose is to allow the designer to write Javascript in order to do just this. I've been told it's not totally full-blown Javascript, but it gets the job done. I think there can be a lot of work done in this area because it offers some basic extensibility while not requiring a network engineer to install Eclipse and start building classes.

## Conclusion

So maybe that hybrid approach is the future - maybe the vast majority of SDN administrators will write just as much code as they do today, with the possible exception of injecting snippets of code where appropriate into engines that do the majority of the "framework-y" stuff for them, writing code only for the very specific piece of functionality that they want, and only then when the vendor hasn't already done it for them.

What do you think? Do you think these ideas are still years away? Share your thoughts below.
