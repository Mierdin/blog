---
layout: post
title: The DRY Principle, and Why Network Engineers Should Care
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-03-12"
wordpress_id: 5683
slug: dry-principle-why-network-engineers-should-care
tags: ['abstraction']
---


The networking industry has long speculated that coding skillsets are something that will likely become key in the future. I'm sure this will vary from job to job, but I can tell you that - at least for me - it's already happened.

I'm not even just talking about knowing syntax like Python, Java, Ruby, etc. I've maintained these skillsets sufficiently throughout my network-specific studies that recalling these skills isn't that hard (admittedly I'm a youngin so it hasn't been that long). It pleases me greatly to see folks that haven't really ever written code going through Codecademy and the like, learning these tools. While this knowledge is important, the methodologies that are second nature to most software developers, are becoming increasingly crucial for network engineers to learn from as well.

A little background first. I actually didn't even consider doing anything with infrastructure (networking or otherwise) until my senior year of college in 2011. I had spent four years out of a 5 year program assuming that I would likely do something related to software development. I sat through lecture upon lecture, hearing about principles, methodologies, history lessons on specific languages, and I created more UML diagrams than I would care to admit. Obviously I went in another direction but that's a story for another time.

One such principle I was taught many times during this journey is known as [DRY (Don't Repeat Yourself)](http://c2.com/cgi/wiki?DontRepeatYourself). It states:

> Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

This is a fancy way of saying that if you're imparting data into a system, build your system so that this only needs to be done once. Software developers these days hardly need to be reminded of this. Common programming practices have used this and similar methodologies for some time.

Let's say you've written some kind of software function. Your project needs to use this function in quite a few places. Wouldn't it be better to refer to the original function, rather than re-write that function in multiple places? It's also true for code that maybe you aren't re-using yourself - it's almost always better to grab code that someone else wrote and use it in your project rather than waste time re-writing it. Logging is a good example for this - we could write an elaborate logging mechanism, or just use the freely available log4j. (Yeah open source!)

Networking is very different. We REGULARLY and DELIBERATELY re-create knowledge in multiple places, regardless of perceived relationships. It is a horrible problem that we have been beaten into adopting because network engineers have been told that security and uptime trump **everything** - even at the cost of slower business agility.

Don't believe me? How do you configure VLANs today? "Go to a box, enter the VLAN into the database, ensure it's passed on the right ports. Ooops, wrong native VLAN on that trunk on that specific box - need to match the other box that I configured 2 hours ago." Don't tell me you could just use VTP, because you know as well as I do that every network engineer or instructor will tell you VTP is a bad idea. Why? Because as convenient as VTP is when done well, it has caused outages before (mostly due to misconfigurations or rogue switches). SECURITY AND UPTIME! WE MUST OBEY!

> Violations of the DRY principle are lovingly called WET (Write Everything Twice - or even better - We Enjoy Typing). Traditional networking of all kinds is extremely WET.

Truly, automation has been the antithesis of most network engineer's methodologies for quite some time. Automation of any kind, even if it's a baked-in feature like VTP, has always been looked at as automated failure. Manual configuration became the name of the game, because we felt better about having a human being play a part in every configuration change. We felt safer that way.

Clearly this does not scale. The IT shops of tomorrow will have to use some of the technologies and methodologies (some, not all) that today's web scale companies are doing in order to stay relevant. One of those things is networking orchestration across the board. The DRY principle even admits that automation is a huge part of this - a message that seems almost specifically addressed to infrastructure folks.

Abstraction is another term primarily used in Comp Sci circles, though I'm sure if you've been a reader of Keeping It Classless for any length of time, you've heard it from me too. In short, this is the practice of separating  an idea from specific instances of those ideas. You can create a python class, and that will allow another python script to create an instance of that class without having to recreate any of the code inside the class itself - it inherits all that automatically and you are then able to move on to the specific task at hand.

There's a lesson to be learned in networking here. There really isn't a very good abstraction layer in production today, so as a result we require apps guys to know about things like addressing and VLANs. Mike Dvorkin says [here](https://www.youtube.com/watch?v=lxxxWiyZgSg) that this is "a crime against humanity", which is spot on.

I am very excited to see that the industry is going in this direction. The Model-Driven Service Abstraction Layer (MD-SAL) that serves as the fundamental interpretation engine in OpenDaylight aims to provide this. The way that policy is configured in platforms like Plexxi Control, Tail-F's NCS or Cisco ACI will also provide this kind of abstraction. Open source junkies will either drool over OpenDaylight, or if they want, write their own SAL (ODL MD-SAL is based on YANG so this is also feasible) to meet a specific business need quickly. The decision to abstract business logic up the stack another layer is a good move, and it's going to happen, but we have yet to see **which** method out of those I just listed (and much more) will be most popular. Maybe there won't ever be one SAL to rule them all - every business has different requirements, so it's possible this shouldn't ever be standardized.

The first step is to consider ANY abstraction. This is something network engineers might benefit from thinking about today, for their specific environment.

## Conclusion

Network engineers repeat themselves every day. We as an industry don't have time to work on cool stuff like design, architecture, or integration, because we're busy making VLAN or ACL changes. We're dragged into the mud daily with things that shouldn't be occupying our time.

A change in methodology is needed. The networks of tomorrow can be just as secure and reliable as we need them to be, while also being able to respond to business needs as quickly as any other technical area.
