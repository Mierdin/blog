---
layout: post
title: Network Automation or SDN?
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-06-24"
wordpress_id: 5865
slug: network-automation-or-sdn
tags: ['automation']
---


With all of the activity going on in the networking industry right now, and all of the new terminology (as well as old re-invented terminology), it's quite easy to get messages mixed up. After all, there's no centralized dictionary for all of this stuff. I'd like to address something that has bugged me for a while.

I've now heard from quite a few folks that SDN to them means the ability to automate network tasks. This almost totally misses the point, in my opinion. Network automation should literally be thought of a prerequisite for what we'll likely be doing on our networks in 10 years; call it SDN if you want. My logic involved with coming to this conclusion is almost 100% about the people involved. Allow me to elaborate.

## What's Missing?

In my experience the main thing that's missing from 90% of enterprise networks today is that networking teams have not properly defined their workflows, and/or have not formalized a service catalog to other parts of the business. As a result, everything is fire-fighting, or one-off requests.

Tracking changes historically, and pinning them to business processes is totally impossible (if it's even attempted), and garbage collection does not occur. Thus, network configuration gets exponentially more cumbersome. All the while, the network team becomes less and less motivated to fix the problem.

## The Faux Fix

So....you're part of such an environment, and your local vendor account manager walks in and pronounces that if you buy this shiny new thing with the shiny new label - YOU SHALL HAVE SDN! And hey - your CIO just read an article on that SDN enables synergistic streamlining of assets, resulting in a compelling ROI for the flux capacitor. The next day, the Purchase Order is signed, and what do you know....you just bought your way into running a better network. How about that?

Fast forward a few years. You realize that you're still having issues, even though your wallet is lighter. You realize that your people are not communicating with each other like they should. Part of your new SDN system is either being totally ignored, or is moved into an area that is competing for budget and time-of-day with another team. Your shiny new toy is being used as a weapon, or at **best**,** **just one more point of management for a team that didn't have enough time in the day to begin with.

Saying you have SDN because you bought an SDN product is no less silly than saying you have a DevOps team because you use Puppet. The DevOps movement, as well as BOTH network automation and SDN, have one big thing in common - and that's the cultural shift. These changes are driven by people FOR people. Anything less makes it just another box. The tools that your team uses is insignificant, next to the culture that is fostered within that team, and within your organization. At the end of the day, your people have to give a shit.

## The Real Difference

If "real" SDN is about culture, then that means that the journey from the old model to the shiny new SDN model is also about culture. For organizations that haven't even started down this path, automation is totally new - or best-case scenario, it's being used in an isolated, limited fashion. It's still dominated by fear.

Look at how nervous folks were to enable VMware DRS, or at least to do anything other than notify the administrator that some workloads should get moved around. Now it's commonplace to have it enabled and set fairly aggressively. So what changed? Sure, some time went by, and folks read blog articles saying "hey it's really not that bad". Fundamentally though, it comes down to trust. We trust this feature works because enough people tried it somewhere, and confidence was built.

So what happens for the here and now, in your own infrastructure? Networking isn't like server virtualization - heterogeneity is a near-certainty, the critical nature of the data network is unparalleled, and lets face it - until the last few years, it hasn't really changed all that much. And you probably don't (or shouldn't) want to wait 10 years for others to solve your problems in a way that's probably not even specific to your environment anyways.

If you'd like to get out of the rut of unpredictable firmware upgrades, random network downtime, and missing dinner because of late-night maintenance windows to add a freaking VLAN, you need to get over your fear of doing things more efficiently. That doesn't mean just hit the network automation script and pray it works. It means fostering a culture of automation the hard way. It means looking strategically at your network and identifying what works MOST terribly. It means setting up an **exhaustive** automation test scenario - even a limited one - and hammering the crap out of it until you're utterly confident in doing it in production, during the day. Pick your own automation tool - it really doesn't matter next to getting it done in the first place.

## So....SDN?

Hopefully I've made it clear that I believe there's a HUGE difference between where we are today and where we CAN be in networking for most of the regular enterprises out there. We're not doing a lot of automation in enterprise networks so any form of automation looks the same. And it's true, there are aspects of the two that are similar. But instead of slapping the SDN label on what we should have been doing all this time, I think we need to acknowledge that there's some middle ground - and that most of us need to get there first.

My opinion is that some of the products being worked on right now are actually pretty stellar. For organizations that have fostered a culture of automation, these technologies should be a great tool to augment existing capabilities. Some may decide to continue to do things their own way (homebrew), and some may find a product that was pretty close to what they were planning to tackle next. Either way, the prerequisite is the culture.

We spoke about network automation on the latest episode of [The Class-C Block](http://classcblock.com/2014/06/23/show-16-ansible-and-network-automation/) - notice how excited we all got when we began discussing making changes in production, during the day?

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/5Bec9UBzdaQ" frameborder="0" allowfullscreen></iframe></div>

In summary, I believe:
	
  * Network Automation represents the next evolution in networking for those that have properly defined their workflow and have formalized a service catalog to other parts of the business.
	
  * SDN represents the next evolution in networking for those that have properly mastered network automation and have fostered a culture that is not afraid of failure, but rather encourages failure to occur  on their terms, so that they can learn from it and immediately be better.

## Conclusion

I'm of the opinion that trying to define SDN is probably pretty silly, as is using the term to describe some specific thing that everyone should just know. The reality is that the term means different things to just about everyone. It would be pretty safe to say that most of the blame can be placed with the marketing folks that like to throw that label on every product that does anything cool in networking.

I'm also of the opinion that it's not all marketing fluff (even if good products are sometimes front-ended by marketing fluff). I believe there are a few key elements that separate network automation from SDN. I also believe it is these key elements that can be used to decide if SDN is even appropriate for an organization. Maybe it's not....yet. Maybe some other things need to happen first.
