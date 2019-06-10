---
layout: post
title: Automation Isn't Just About Speed
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-12-22"
wordpress_id: 5994
slug: automation-isnt-just-speed
tags: ['automation']
---


In talking with folks about automation, the conversation almost always come around to "speed, speed, speed". It's easy to see why this is the first benefit that pops into mind - we've all spent gratuitous amounts of time doing repetitive, time-consuming tasks. It's obvious why the prospect of automating these tasks and getting the time back is such an attractive one, even though most of us that have tried know that this is an absolute reality:

[![](https://imgs.xkcd.com/comics/automation.png)](http://imgs.xkcd.com/comics/automation.png)

All kidding (but some.....seriousing?) aside, is speed the only benefit? In the realm of IT infrastructure, should we pursue automation only when [this other piece of brilliance](http://xkcd.com/1205/) tells us it's worth it?

Consider a small deployment of a few switches, a router, maybe some servers. Using manual methods to configure the relatively small amount of infrastructure isn't really **sexy**, but it's also not a huge time suck either. There's just not a lot of infrastructure in these small deployments, and manual configuration doesn't really impact the rate of change.

As a result, when discussing automation concepts with small, and even medium-size shops, I'm usually met with understandable skepticism. There's a huge part of IT industry that assumes that all of our fancy blog posts and Twitter pontifications about automation and SDN **just must not apply to them**. That's a huge miss on our part, in my opinion.

Focusing on "speed" as the reason to automate a task is analogous to saying source code version control is valuable because it is a nice file server.

## Standardization Brings Predictability

I believe the MOST valuable result of automation is the ability to accurately predict outcomes. Automation brings a certain accuracy and repeatability to a process that allows us to do some very interesting things. For instance, you may think that it's not worth building configuration templates for your single remote site, but in reality it's one of the best ways you can prepare for growth, and it provides the same value to your small IT shop as it does the Fortune 500.

It's usually the simple stuff, things that don't seem to provide much value on the surface - that end up mattering most. Take for example the EVER common situation where switchport layouts are absolutely random. I've gone into many situations where - when I inquire as to where I should plug something in, the customer responds with "anywhere that's free", or something like that.

[![cables](/assets/2014/12/2012-03-16_11-20-08_226.jpg)](/assets/2014/12/2012-03-16_11-20-08_226.jpg)

Eventually we get things working, so what's the harm? Well aside from causing the chaotic mess picture above, not having some kind of standard operating procedure for these kind of things can lead to impaired troubleshooting ability. For instance, if you standardize on using the first 4 ports of every access switch for the uplinks to the next layer up, then you always know where to look when that switch is having issues. You also know how to template-build these switch configurations.

In summary, **standardization** is one of the most important prerequisites of infrastructure automation. Sure, automation brings obvious benefits like accuracy, repeatability, and yes, speed. However, I believe the biggest benefit is predictability. In network automation and SDN, we talk about removing the human from the equation because humans are slow, but don't forget that we are also very unpredictable. Erroneous configuration aside, we all have various ways of doing things because we've all gone through a unique learning experience over time.

Rather than have everyone touch infrastructure directly - taking all of their baggage into it - working through a software layer allows us to push our standard practices into code to be strictly enforced. The SMEs on a particular technology will come together once and agree on the best practices for their gear, push those standards into code (or infrastructure-as-code products like [Schprokits](http://www.schprokits.com/)), and call it a day. This must be something enforced at the cultural level, however, as you need the SMEs to provide this guidance to those writing/extending the tools, and you also need commitment that these tools will not be worked around (which defeats the whole automation project).

> Software middleware can also help with garbage collection - things like [SAN zoning](https://keepingitclassless.net/2014/12/automating-san-zoning-schprokits/) and ACL entries will be more relevant because they're actively tracked. No more bloated configs.

Infrastructure predictability is a product of combining the right tools with cultural rigor and discipline. If you do not standardize and then automate the operations of your infrastructure, you're accruing technical debt. Someone will pay for that.

## Start Simple

Recently I had a twitter conversation with my good friend Ed Henry:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/NetworkN3rd">@NetworkN3rd</a> It is at first :)</p>&mdash; Matt Oswalt (@Mierdin) <a href="https://twitter.com/Mierdin/status/545293359137705985">December 17, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I think Ed was onto something here, but as I mentioned in the thread, I strongly believe that for the vast majority of IT shops, automating the "status quo" is really the only realistic definition of automation today. Over time, as IT shops discover the flaw in their process (because they've scaled it out and suffered the challenges that come with doing so) then they might consider changing out those switches and buttons for new ones. Those that aren't at this scale yet don't need to change the entire paradigm of how infrastructure is run - they need to sell more donuts, or fix more cars. They need infrastructure that works, and they need a migration path to get there.

Hopefully I've made it clear that infrastructure automation isn't really a matter of size or scale, but as a matter of discipline and desired outcomes. With that in mind, I encourage you to start simple. Easy things like building templates to drive your switch configurations are things that you can do today that isn't far-fetched, but very realistic and full of benefit.
