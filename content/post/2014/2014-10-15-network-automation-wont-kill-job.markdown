---
layout: post
title: Why Network Automation Won't Kill Your Job
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-10-15"
wordpress_id: 5960
slug: network-automation-wont-kill-job
tags: ['automation']
---


I've been focusing lately on shortening the gap between traditional automation teams and network engineering. This week I was fortunate enough to attend the [DevOps 4 Networks](http://www.devops4networks.org/) event, and though I'd like to save most of my thoughts for a post dedicated to the event, I will say I was super pleased to spend the time with the legends of this industry. There are a lot of bright people looking at this space right now, and I am really enjoying the community that is emerging.

I've heard plenty of excuses for NOT automating network tasks. These range from "the network is too crucial, automation too risky" to "automating the network means I, as a network engineer, will be put out of a job".

> To address the former, check out Ivan Pepelnjak's [podcast](http://blog.ipspace.net/2014/09/schprokits-with-jeremy-schulman-on.html) with Jeremy Schulman of Schprokits, where they discuss blast radius (regarding network automation).

I'd like to talk about that second excuse for a little bit, because I think there's an important point to consider.

## A Recent Example

A few years back, I was working for a small reseller helping small companies consolidate their old physical servers into a cheap cluster of virtual hosts. For every sizing discussion that I've been a part of when approaching first-time virtualization, you typically get quite a bit more than you actually need. There are many reasons for this, but one of the reasons that I liked to bring up was that - in my experience - IT shops that implement virtualization for the first time tend to get kind of crazy creating new virtual machines. It's easy to imagine, considering how easy it is to create a virtual machine, especially compared to the old way of procuring and provisioning physical servers. And wouldn't you know it - like clockwork, each customer immediately started creating machines they've always wanted to have - for instance, an additional cluster node for one of their applications. There was a clear correlation between the adoption of this new technology, and the increased use of the infrastructure as a whole.

You might ask - did the business ramp up their efforts because there were more compute and storage resources then they had before? Actually, after the project, there were far fewer resources than they used to have due to proper consolidation. So what changed? Ultimately the reason is simple - the infrastructure was more easily consumed. The tools that allowed an administrator to quickly spin up compute resources meant that they were able to close the gap between IT's resources and the business.

Once this new operating model was adopted, the word was out. Now that the business folks could see  the fruits of that "virtualization" buzzword for themselves, they immediately started thinking of other ways to put the infrastructure to use for them - look at virtual desktops as an example. Not to mention the myriad of system automation tools in that space now that are widely accepted and used - each time a new tools is adopted, it multiplies this effect.

The virtualization admin is now a position that doesn't really exist - what we once called virtualization admin is now responsible for a lot of the software stack on top as well, and in many ways are the "get shit done" folks for their IT organization. I would make the argument that for many of these folks, their organizations value them much more, not less. Virtualization was just the beginning - the real change occurs when you expose things like self-service portals that allow you as the IT professional to control the experience (because you are still on the hook for it) but still allow someone to easily use it, in the way that they might swipe a credit card for Amazon Web Services.

## Killing the "Black Box"

The implementation details of network automation are admittedly different from automating server configuration (i.e. the Blast Radius factor, etc.) but the underlying value is precisely the same. Network automation isn't about learning Python, it's not even about moving your network configuration into templates - though that's certainly a valued component. The truth is that network automation, like any other form, is about visibility, and trust. It's about network engineers stepping up and providing a way for other disciplines to consume networking more effectively. It's about reducing the gap between the infrastructure and the business by "opening the kimono" on the black box that is the network.

[![black-box-310220_640](assets/2014/10/black-box-310220_640.png)](assets/2014/10/black-box-310220_640.png)

Sometimes this means saying "no". This isn't about creating a new world of wild-west "anything goes" networking. You are the network engineer, no one knows your network like you do, and sometimes server folks ask for crazy things. This is why visibility is such a key part of the DevOps movement, and is being carried into the same for networking. Visibility means introducing a very valuable feedback loop so that when you have to say no, you're able to give a reason why, and those asking for network resources will learn and grow themselves. Saying "no" teaches no one anything.

I always think about open source contributions when I consider this paradigm - open source projects sometimes suffer from code contributions that are sub-par. Most of the time it's working code, but from a quality or readability perspective, it would really water down the quality of a project, so the committers tend to -1 those kind of contributions. This kind of rejection isn't about rejecting the code entirely (unless it's just meaningless garbage), the goal is to massage the code into a usable, well-formed state, and finally be accepted after a few modifications. I've been fortunate enough to work with very patient folks that provide the right feedback, and help me grow as a programmer - and it's the best way to learn, frankly.

You may believe that holding on to manual process and stomping your feet whenever someone suggests removing you from your per-box CLI guarantees you job security, but the only thing it does is kill your organization's (and in turn, your paycheck) ability to scale, and remain competitive.

I believe that - just like our compute example in the section above - when other parts of the business get used to the new operational model on the network, they're going to think of a lot of your automation use cases for you. Do not think only of automation within the scope of only the tasks you're doing now - understand there's an entire world of things out there that people want but don't yet know how to ask for. If you start creating visibility and consumability into your infrastructure, the business will quickly catch on. Having been the first person that has opened the kimono and really worked with them to get things done on the network side, you will become their immortal hero.

## Responsible Automation

Network engineers' insistence on manually tweaking each nerd knob on each individual box is still roughly comparable to a virtualization administrator carefully controlling which disk a virtual machine is stored on, or which specific DIMM it uses for memory. At some point, you realize that the system exists to be a pool of resources, so it should be treated that way. The server admin doesn't want their services to be brought offline any more than a network engineer does - but they were willing to incrementally introduce new and better tools into the environment, and now it's just part of the operating model.

Look - I agree that the blast radius for networking tends to be larger than in the other disciplines. One important point that was brought up at the DevOps for Networks event was that network engineers are and will always be on the hook for ensuring uptime of the entire stack, and changing the tool they've come to know well (per-box CLI) makes them feel like they won't be able to guarantee SLAs. It's a real concern - especially when you consider that a lot of network engineers are just not interested in learning a new tool, or worse, their business isn't giving them the time to even explore it. The latter is a very real problem, and it's clear that efforts like this have to come from the top down.

The benefits of network automation are clear, but these concerns are very real. So what do we do? The first thing I would recommend is really good testing. These days, you can set up a pretty good test environment virtually, and testing configuration changes before ever touching a physical network. This wasn't always possible, but now that it's low-hanging fruit, consider revisiting this topic and using it to get used to some of the tools that emerge in this space.

Just like with other forms of automation, all it takes is for the business to see a tangible example, even simple ones (and the simple ones are easier to put into place). Soon, they'll be able to properly articulate what they've always wanted the network to do, and the attention given to automation projects will snowball. Don't be afraid to start with the small things - not only does it save you time, (it can help keep the firefighting at bay) but also helps those on the outside start to see what it is you're trying to do.

## Conclusion

This space is evolving constantly, and my main point was to address the question of job security in the new paradigm of network automation. However, this is an area that is becoming very near to my heart, and I can tell you that future blog posts will be focused on very concrete examples - like creating network templates, or the idea of creating a continuous integration pipeline for deploying network configurations. Until then, I hope I helped clear up this idea - stay tuned for more from me on this topic.