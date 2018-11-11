---
layout: post
title: This New "Cloudshark" Thing
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-11-07"
wordpress_id: 1735
slug: this-new-cloudshark-thing
tags: ['capture']
---


I had heard of CloudShark a while back but was reminded of it by a recent [Packet Pushers article](http://packetpushers.net/cloudshark-new-features-and-why-would-i-use-cloudshark-when-i-could-just-intsall-wireshark/). For those that haven't, CloudShark is a new product that basically claims to be a cloud-based capture file (such as from Wireshark) archiving solution. Viewing [the main CloudShark website](http://www.cloudshark.org/), you'll be unable to miss what is obviously their big pull - CLOUDSHARK BRINGS YOUR CAPTURE FILES TO THE CLOUD OMGZ!!! (Did the fact that those words are at the top of each page on their site not give away their enthusiasm?)

Lets get this out of the way quickly - yes of course it would be a security faux pas to upload actual production network captures to a 3rd party free service. Discussions such as [this thread on ask.wireshark.com](http://ask.wireshark.org/questions/698/wwwcloudsharkorg) contain arguments against CloudShark, because of exactly this reason. In fact Laura Chappell, a name nearly synonymous with Wireshark these days, while still open to the idea of CloudShark for various reasons, was careful to point out that CloudShark themselves advise that if security is your focus, don't use this feature.

I'd like to follow that up with this - the upload feature is obviously a demo (and an impressive one) on some of the features CloudShark has to offer right now - such as packet annotations, and easy sharing capabilities - you can distribute links to capture files, and even specific packets within a capture to collaborate on with team mates. I think this is a pretty neat idea and the fact that people get hung up on the fact that the demo isn't secure is a little underwhelming.

Do a little more research and you'll find that CloudShark is also offering an appliance for use within an organization's network to address these security concerns. While I haven't exactly gotten my hands on one to test for myself, I think the idea has some merit. CloudShark will have to work hard to get into markets currently penetrated by WildPackets, because the idea of viewing packet captures in a web browser - though shiny and cool, isn't enough. Archiving capture files is just one small feature. They need to take some of their existing strengths, such as the collaboration features, and expand on them. There may be an opportunity to get into what is currently WildPackets market if CloudShark can offer some of the same features with this new platform. I have a current request outstanding for their whitepapers  - I'd be interesting to see if they're trying, even a little bit, to compete with current monitoring solutions.

Garry Baker over at PacketPushers pointed out that the application is useful for organizations where Wireshark cannot be installed (at least not easily) on end-user devices because of policy. First, what kind of organization does that to their network engineers? That's like sending a knight after an evil fire-breathing dragon with no sword. Regardless, the browser function is still cool and pretty useful - the kind of thing that helps to gain some quick momentum. That momentum will fizzle unless some new features are developed to pull customers away from their existing solutions.
