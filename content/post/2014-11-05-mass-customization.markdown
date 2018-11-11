---
layout: post
title: Mass Customization
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2014-11-05"
wordpress_id: 5975
slug: mass-customization
tags: ['automation']
---


I've mentioned in past articles about my belief that networking - both as a discipline and a technology - needs to be more consumable to other disciplines. But what does this mean? I was reminded of a few great examples today that I think are relevant to this idea, and might help explain my point a little more clearly.

## Mass Production Meets Customization

The assembly line revolutionized the auto industry. Prior to this, vehicle production was very slow, and extremely costly. The introduction of the assembly line for creating automobiles allowed cars to be created in a predictable, repeatable way. However, Ford famously required all Model T's to be painted black. Even before the introduction of the assembly line, the Model T was available in other colors, but with the move to mass production, this option was taken away.

The term "[mass customization](http://en.wikipedia.org/wiki/Mass_customization)" is essentially the idea that mass production can co-habitate with customization, resulting in a customer experience that is personal and custom-built, but that also gets to experience the low unit cost that comes with mass production.

A great example of mass customization is the [Moto X](https://www.motorola.com/us/motomaker?pid=FLEXR2&action=designNew) phone, whose commercials famously offer all kinds of customization options for the actual body of the phone you're purchasing. You can select the color of the back of the hone, as well as the side buttons, even the small strips of color around the logo on the back or inside the speaker assembly are tweakable.

Through this, you're able to make the phone your own. Are you an expert in designing and fabricating all of the various components of a smartphone? I certainly am not, and I wouldn't trust myself to do a good job - it's not my expertise. This kind of tool still places the responsibility of creating a working, well-made device in the hands of those that are skilled at it. However, as a consumer, I believe I am in control, and that the phone I'm designing is my own.

Maybe an even more relevant example is something like Rackspace. I can create a Rackspace account, and within minutes, have a virtual machine that is connected to the internet, and available for me to connect to and start installing software on. I can provide exact specifications on how this machine should look, what kind of connectivity it has, and even what operating system is on it. Beyond that, I have root access to this operating system, and can make it do anything I want.

Am I profoundly changing Rackspace's internal infrastructure every time I make a change to my machine? No! Do I need to be given access to their servers or switches in order to feel like I, as a consumer, am controlling my own experience? Of course not.

## Standards and Templates Aren't Just For You

The idea of enforcing a standards within IT infrastructure is totally crucial to being able to automate it's management. The phrase "you can't automate what you don't know" is true to a point, but I think the important thing to remember is that the very idea of automating infrastructure still makes assumptions about how that infrastructure is built prior to automation. Without enforcing some kind of standard, such as "each access-list entry is preceded by a remark that contains a Change ID number", automation is actually pretty difficult, certainly within network infrastructure specifically.

When I say "networks need to be more consumable", I'm really talking about network engineers putting together the right tooling for their network that allows other disciplines to have the same experience that I do when I order a Moto X, or create a new virtual machine within Rackspace, or AWS. You're the network engineer, and you're the only one with the right knowledge to do things like configuration template building, or adopting DevOps tools and workflows. No one but you has the battle scars to prove that you can keep the network up and running, and no one but you will be held accountable when things don't go well.

So take the opportunity now to enforce standards. Build [configuration templates](https://keepingitclassless.net/2014/03/network-config-templates-jinja2/) for your network devices, even if you have a small environment and/or IT shop. Publicly document your workflows, and put on paper what you may now be taking for granted. There will always be exceptions to standardized templates, so build them with customization in mind from the get-go. Have the wisdom to know which nerd knobs should stay at a certain position due to best practices, and which can be exposed safely to those without deep infrastructure knowledge.
