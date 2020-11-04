---
layout: post
title: Networking Field Day 7 - Here We Go Again!
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-01-28"
wordpress_id: 5396
slug: networking-field-day-7-here-we-go-again
tags: ['actionpacked']
---


[![](https://static.techfieldday.com/wp-content/uploads/2013/11/NFD-Logo-400x398.png)](http://static.techfieldday.com/wp-content/uploads/2013/11/NFD-Logo-400x398.png)

I'm pleased to be invited back for the 7th installment of Networking Field Day in San Jose, CA from February 19th - 21st. This event is  part of a series of independent IT community-powered events that give the vendors an opportunity to talk about the products and ideas they've been working on, and receive honest and direct feedback from the delegates.

The results of this dynamic vary quite greatly - sometimes a vendor doesn't quite bring their A-game and we let them know. Other times, vendors use the opportunity to bring the best and brightest that they have into the daylight of the community, and the delegates in attendance are more than pleased to let the world know. It's one of my favorite things about the IT industry, and I encourage you to head over to the [Tech Field Day site](http://techfieldday.com/event/nfd7/) for more information on NFD7 as well as the other events under the TFD umbrella.

We have a fantastic video crew following us around and they do a great job providing really high-quality video feeds that can be viewed live online. We usually do a pretty good job of posting the link whenever we begin a new presentation on Twitter, but generally the best bet is the main [Tech Field Day site](http://techfieldday.com/) - the video feed is always front and center for your convenience. If you can't watch live, recordings of all broadcast video will be made available within a few days. Those links will make their way to the [NFD7](http://techfieldday.com/event/nfd7/) page when posted.

Each Tech Field Day event is allocated a Twitter hashtag, and it is the best way to interact directly with both the delegates and vendors in real-time. Networking Field Day 7 will be using the hashtag #NFD7. Please use this hashtag to either keep track of the goings-on at NFD7, or communicate with the delegates and vendors (we do a pretty good job of bringing community questions to the vendors right away and getting them answered).

Here's a rundown of the vendors that will be presenting at Network Field Day 7, as well as a few introductory thoughts.

## ActionPacked Networks

ActionPacked's flagship product is LiveAction. The following video is quite long, but it gets the point across and shows the tool in action.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/JKrgb1YWi0U" frameborder="0" allowfullscreen></iframe></div>

LiveAction for QoS Configuration allows an administrator to graphically and at scale, configure global QoS policies, rather than work from device-to-device on a CLI level, which is prone to errors. It sounds like the software essentially just scrapes together CLI commands for either the administrator, or the software to place on the device via SSH. The rest of the features seem to center around monitoring infrastructure, and perhaps making small configuration changes.

The big question in my mind is - what are they doing with other vendors? Cisco is mentioned by name on nearly every slide, and with the vertical they seem to be going for here, they'll be hard pressed not to find a significant amount of Juniper gear or other, and the video didn't lead me to believe they work with anyone other than Cisco.

## Avaya

The first thing that entered my mind when I heard Avaya was presenting at NFD7 was SPB, or Shortest-Path Bridging. Avaya's not usually brought up in networking discussions - they're arguably a far bigger voice or even video vendor than anything else. I actually worked with Avaya in this space quite a bit when I was developing Java-based applications for their VoicePortal platform in a previous life.

So yeah...shortest-path bridging. Avaya has been pushing this idea for a number of years, seemingly in defiance of the rest of the industry going towards the direction of TRILL in order to solve the STP problem. If Avaya is here to talk about that, I'll be interested to hear what they have to say on it, but currently my thoughts mirror that of [Greg Ferro's](http://etherealmind.com/spb-attention/) - I just don't see a lot of interest for SPB in the industry.

I would be remiss if I didn't post a video of the TFD roundtable at Interop New York 2013, where Avaya came and - speculation on SPB's place in the industry aside - actually did a really good presentation on SPB.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/aEmTyXuY_8g" frameborder="0" allowfullscreen></iframe></div>

It will be interesting to see what Avaya comes to talk about. My prediction is they'll come to talk about something like their [Fabric Connect](http://packetpushers.net/show-158-avaya-software-defined-data-centre-fabric-connect/) product. Their Ethernet switching portfolio isn't exactly the talk of the town, so it would make sense that they would focus on an "SDN-esque" option. They've been pushing SPB as the transit-of-choice in an SDN deployment, and sounds like it is aimed at achieving the same goals as Cisco's Dynamic Fabric Automation - essentially providing features for network agility by manipulating L2 ECMP without committing to a pure L3 routed DC network such as what you'd run VXLAN over. Paul Unbehagen mentioned the "header bloat" that comes with VXLAN as a reason for going in a different direction.

I am a fan of this idea, except that in nearly every case, L2 ECMP features have traditionally been either cost-prohibitive (licensed feature), proprietary and incompatible with other vendor switches, or both. So...I will be interested in hearing from Avaya regarding the adoption of their SPB-based SDN offering.

## Brocade

Brocade's last presentation was at NFD5, very soon after their acquisition of Vyatta, which is still my go-to in terms of virtual routing appliances. As a result, they were not able to talk about Vyatta as much as I would have liked, but it was understandable seeing as the acquisition was very recent.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/0BdYDubkCwY" frameborder="0" allowfullscreen></iframe></div>

I hope to hear more from them regarding what they've done with Vyatta in the past year or so.

I'm also hoping we get treated to something like what they did back at NFD2 - a hands-on lab. This is not something that happens often, and honestly it's a very great way to engage NFD delegates, as it virtually guarantees that we'll all be scrambling back to our laptops to blog about the experience.

Brocade and I have a strange relationship - though I can never claim that I've worked with their gear officially, I run into their FC switches at just about every customer I work with (split about 50/50 with Cisco Nexus or MDS in terms of FC transport). So....a fresh look at Brocade is always welcome. I also have a lot of respect for [Jon Hudson](https://twitter.com/the_solutioneer) - I see him pop up at events like this often and always enjoy hearing his networking perspectives.

## Dell

Honestly I don't know what to expect from Dell. This will be their first Networking Field Day, and I don't believe that their previous appearances at Tech Field Day proper had much networking-related content. Despite the small ripple that their Force10 acquisition made a few years back, I still don't hear about Dell networking products that much.

It's possible that they may talk a little bit about their Active System Manager product - they went into a little bit of detail about this at [TFD9](http://techfieldday.com/appearance/dell-presents-at-tech-field-day-9/) but the conversation was fairly light on networking details.

Regardless, I look forward to hearing what Dell has for us in the networking space.

> **EDIT**: Just after I hit "publish" on this article I saw news of Dell's deal with Cumulus Networks to resell Cumulus switches. Hopefully this doesn't sound negative, because it's not intended that way...but why? I'd like to hear from Dell regarding this decision, because it appears to represent a pretty large shift in strategy with respect to Dell's networking business.

## Extreme

I've seen a lot of Extreme's gear in customer environments - but only on the Fibre Channel switching side thus far. On perusing their site, I notice they do talk a little about automation in both the data center and campus (hey, there are other networks out there besides the data center) networks. They even [call out a few partners specifically](http://www.extremenetworks.com/solutions/datacenter_sdn.aspx) like NEC and Big Switch, which seems to indicate that their switches can be purchased with the express purpose of connecting up to some kind of NEC or Big Switch controller.

So, perhaps they're coming to NFD7 to talk about what they've been working on in terms of their own software solution, perhaps one that is able to cohesively manage the data center AND campus networks. They do make a few critical campus LAN components such as access switches and even wireless APs, so an exploration into the specifics of their "[Open Fabric Edge](http://www.extremenetworks.com/solutions/open-fabric-edge.aspx)" product might be appropriate here. I look forward to hearing what they're bringing.

## Juniper

Like Brocade, Juniper last presented at Network Field Day 5, and in that session (among other things) - Jeremy Schulman showed up to talk about the transition between DevOps and network automation - this is one of my favorite NFD moments ever:

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/NuyamiblDng" frameborder="0" allowfullscreen></iframe></div>

I do also want to call out Jeremy's [recent appearance on the Packet Pushers podcast](http://packetpushers.net/show-176-intro-to-python-automation-for-network-engineers/) where he talks a bit about Python and specific details regarding what the network engineer of tomorrow will look like. Very fitting concerning today's conversations about SDN, and one that is of critical interest to me. I really should get that blog post out of drafts - been there for a few months now.

Knowing that Juniper is working on stuff like this means that I am absolutely eager to hear from them in a few weeks.

## Plexxi

So I think my opinion regarding Plexxi is fairly well-known at this point, largely due to posts I've made about them in the past, [such as this one](https://oswalt.dev/2013/10/plexxi-optimized-workload-and-workflow/). Or quite frankly, because of bad ass videos like this:

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/-2DO_R_MRok" frameborder="0" allowfullscreen></iframe></div>

Suffice it to say I have a lot of respect for Plexxi. I think their approach of "application affinities" is absolutely the right approach, which is one of the big reasons why Cisco ACI also resonates with me so much. Plexxi is just taking the flamethrower to this largely unexplored jungle that is SDN, and they're making this whole NetOps/DevOps thing practical and grounded. They showed us a lot of things only a few short months ago at NFD6, and I look forward to seeing what they've been working on since then.

**EDIT**: I watched a little bit of what was going on at Cisco Live Europe and saw a little more about what Plexxi is doing with OpenDaylight. I am familiar with Plexxi's contribution of their Affinity API as an ODL module, and am happy to see they're continuing to do public work with the project.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Retweet, but with tags.. Plexxi ring topology in Opendaylight.. <a href="https://twitter.com/PlexxiInc">@PlexxiInc</a> <a href="https://twitter.com/OpenDaylightSDN">@OpenDaylightSDN</a> <a href="http://t.co/jJzZlExKoI">pic.twitter.com/jJzZlExKoI</a></p>&mdash; Derick Winkworth (@cloudtoad) <a href="https://twitter.com/cloudtoad/status/426064504858767361">January 22, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Day two showing <a href="https://twitter.com/hashtag/CLEUR?src=hash">#CLEUR</a> what <a href="https://twitter.com/PlexxiInc">@PlexxiInc</a> is doing with affinity and <a href="https://twitter.com/OpenDaylightSDN">@OpenDaylightSDN</a> <a href="http://t.co/FdyLH2zWxL">pic.twitter.com/FdyLH2zWxL</a></p>&mdash; Nils Swart (@NLNils) <a href="https://twitter.com/NLNils/status/428444388151156737">January 29, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I'm very interested in hearing about their continued work with OpenDaylight, and Plexxi's view of the impact to both themselves as a company and also the community.

## Pluribus Networks

Pluribus is still fully in stealth mode from what I can tell. Information on their site is fairly limited, but I was able to find [this whitepaper](https://www.pluribusnetworks.com/images/pdf/Pluribus_Networks_F64_Data_Centers.pdf) that talks about their Server-Switch platform.

This is pure speculation at this point, but if I had to guess, I'd say they have a pair of ToR switches that connect a slew of their rackmount servers, forming the physical layout of the F64 Server-Switch. Based on the wording, it sounds very similar to Cisco UCS, in that the network (data and storage) and compute are managed as one. Their Netvisor application, whether hosted on the switches a la UCS, or as a virtual machine within the compute itself, would provide a single pane of management for the entire pod - the network offering 10/40Gbps of lossless Ethernet connectivity (via DCB).

I'm hoping to chat a little more with Pluribus concerning these thoughts and hopefully get a little confirmation, as well as a sneak preview of what they've been working on. If I'm correct in my assessment, then I think they've got a fairly unique opportunity in going above and beyond what Cisco's already done with UCS, by providing rich networking services inside the chassis itself. Today, UCS doesn't really do much more than lossless Ethernet transport - the value proposition is largely in the unified management aspect. Pluribus can go above and beyond this by adding functions like load-balancing, firewalling, routing, etc. right there in the fabric.

Either way I look forward to the big reveal at Networking Field Day 7.

## Tail-F

I have actually heard Tail-F come up in quite a few conversations recently. In early SDN debates where we were discussing things like exactly what should be abstracted - the entire control plane, or simply the management plane - Tail-F was specifically mentioned multiple times.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/om7Jd6iuBGI" frameborder="0" allowfullscreen></iframe></div>

Their NCS product is of interest to me for a few reasons. First, it answers questions that I've already posed to ActionPacked up near the beginning of this post - configuration simplicity can and should be done across a wide variety of device types and platforms. I enjoy working with the OpenDaylight project primarily because with the modular framework powered by OSGI, we have this. In terms of closed-source solutions, NCS seems to be pretty good too.

Tail-F does a few other things as well, but that's what stuck out for me, and I'll save the rest for their presentation in a few weeks.

## Summary

I applaud Stephen and his crew for putting together this rock-solid vendor list. I think each and every one of them have the ability to knock it out of the park at NFD, and I look forward to listening and discussing the technologies we've all been power-pointing for the last few years.

> I am attending Networking Field Day 7 as a community delegate. This means that the vendor(s) may pay for a certain portion of my travel arrangements, and may give out some small tchotkes, but no delegate is ever compensated for attending, or for writing any articles. Any opinions given are my own and are never influenced in any way. ([Full disclaimer here](https://oswalt.dev/disclaimers/))
