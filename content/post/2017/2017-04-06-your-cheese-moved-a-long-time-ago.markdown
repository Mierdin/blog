---
layout: post
title: Your Cheese Moved a Long Time Ago
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2017-04-06"
slug: cheese-moved-long-time-ago
tags: ['networking']
---


I was recently on a panel at the [Event-Driven Automation Meetup](https://www.meetup.com/Auto-Remediation-and-Event-Driven-Automation/) at LinkedIn in Sunnyvale, CA, and we all had a really good hour-long conversation about automation. What really made me happy was that nearly the entire conversation focused on bringing the same principles that companies like LinkedIn and Facebook use on their network to smaller organizations, making them practical for more widespread use.

<blockquote class="twitter-tweet tw-align-center" data-lang="en"><p lang="en" dir="ltr">Nina Mushiana of <a href="https://twitter.com/LinkedIn">@LinkedIn</a> says &quot;Anything that can be documented should be automated&quot;.<br>Great Auto-Remediation Meetup! <a href="https://t.co/l76U1IydjB">pic.twitter.com/l76U1IydjB</a></p>&mdash; StackStorm (@Stack_Storm) <a href="https://twitter.com/Stack_Storm/status/847664487620530177">March 31, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

One particular topic that came up was one I've struggled with for the past few years; What about Day 2 of network automation? So, we manage to write some Ansible playbooks to push configuration files to switches - what's next? Often this question isn't asked. I think the network automation conversation has progressed to the point where we should all start asking this question more often.

I believe that the network engineering discipline is at a crossroads, and the workforce as a whole needs to make some changes and decisions in order to stay relevant. Those changes are all based on the following premise:

> The value of the network does not come from discrete nodes (like routers and switches - physical or virtual), or their configuration, but from the services they provide.

If you're just getting started down the path of following basic configuration management or infrastructure-as-code principles, **that's fantastic**. This post is not meant to discourage you from doing that. Those things are great for 1-2 years in the future. This post focuses on year 3+ of the network automation journey.

# Your Cheese Has Moved

We've all heard the lamentations that come from server admins ([throwback alert](https://keepingitclassless.net/2015/02/free-form-discussion-cleur/)) like "why does it take weeks to provision a new VLAN?"; I worked as a network and data center consultant for a number of years and I can tell you that these stories are true, and it gets much worse than that. 

As I've said before, what the sysadmin usually doesn't know is all the activity that goes on behind the scenes to deliver that VLAN. Usually what they're asking for is a new logical network, which isn't just a tag on a switchport - it's also adding a layer 3 interface, and potentially routing changes, edits to the firewall, a new load balancing configuration, and on and on and on. The network has traditionally provided a lot of these services, that the sysadmin took for granted.

You might understand their frustration, but the reality is that the network engineer is trying hard just to provide these services and ensure they're changing adequately for the applications that rely upon them. It also doesn't help when processes like ITIL force such changes to take places every first weekend of the month at 2AM. This is a far cry from what the application teams and developers have come to expect, like response times of seconds or minutes, not weeks or months. But hey, those silly developers don't know networking, so they can just deal with it, right?

Yes, it can be tempting to make fun of some developers that can't tell a frame from a packet. However, it may be useful to remember that a developer wrote the software in your router. Someone had to write the algorithms that power your load balancer. It is indeed possible that some software developers know networking - even better than most network engineers out there. Then, if you put them in the constantly-innovating culture of silicon valley that is always looking for a problem to solve, it's inevitable; the arduous processes and inflexible tooling that has dominated networking for so long provided those developers and sysadmins with a problem to solve on a silver platter.

<div style="text-align:center;"><a href="/assets/2017/04/cheese.png"><img src="/assets/2017/04/cheese.png" width="300" ></a></div>

And solve it they did. When x86 virtualization was really hitting the mainstream, network engineers didn't really acknowledge the vSwitch. They wrote it off as "those server guys". What about when we started routing in the host or hypervisor? I know a lot of people like to make fun of the whole `docker0` bridge/NAT thing. Those silly server people, right? Developers are spinning up haproxy instances for load balancing, and learning how to use iptables to secure their own infrastructure. On top of that, all of these network services are **also being offered by AWS** and are all in one nice dashboard and also totally programmable. Can you really blame the developer now? Put yourself in their shoes - if you were faced with an inflexible network infrastructure that your application depended on, and you had no control over it, how long would it take you to follow the shiny red ball over to Amazon where they make all those same network *services* totally abstract and API-controllable?

So what's happening here is that "those server guys" are basically running their own network at this point. We've clung to our black boxes, and our configuration files at the cost of **losing control over the actual network services**. The truth is, we need to play a lot of catch-up.

 > I know what you're thinking - there's more to the network than the data center. But like it or not, the datacenter houses the applications, and the applications are where the business sees the value in IT. Applications and software development teams sit closer to the boss, and they're learning how to manage network services pretty well on their own out of necessity.

# Getting the Cheese Back

Network automation is about so much more than merely solving a configuration management problem. If it was, this would all be a bit anticlimactic, wouldn't it? Everyone would just learn Ansible/Salt/Puppet and be done with it.

Network automation, just like all other forms, is about **services integration**. There aren't "existing tools" for your legacy, internal applications. At some point [you're going to have to write some code](https://keepingitclassless.net/2017/03/learn-programming-or-perish/), even if it's an extension to an existing tool. It's time to get over this aversion to dealing with even basic scripting, and start filling in the 20% of our workflows that can't be addressed by a turnkey tool or product. To me, this is the next step of network automation - being able to fill in the gaps between historically air-gapped services to create an automated broader IT system.

For instance - Kubernetes is an increasingly popular choice for those looking to deploy distributed applications (don't make me say "cloud native"). It's great at managing the entities (like pods) under it's control, but it's not meant to run everything meaningful to your business. If you're running Kubernetes in your organization, it will have to run alongside a bunch of other stuff like OpenStack, vSphere, even mainframes. This is the reality of brownfield.

As you might expect, all these systems need to work together, and we've historically "integrated" them by hand for a long time by looking at different areas of our technology stack, and "rendering" abstract concepts of desired state into implementation-specific commands and configurations. Just take networking as a specific example - a network engineer is the human manifestation of a cross platform orchestrator, seamlessly translating between Cisco and Juniper CLI syntaxes.

<div style="text-align:center;"><a href="/assets/2017/04/dr_garencieres.jpg"><img src="/assets/2017/04/dr_garencieres.jpg" width="500" ></a></div>

So, to return to the main point; the network is now no longer the sole proprietor of network services - those are slowly but surely migrating into the realm of the sysadmin and software developer. How can we adapt to this? One way is to acknowledge that the new "network edge" is very blurred. No longer is there a physical demarcation like a switchport; rather, these services are being provided either directly adjacent, or even co-resident with the application.

It's actually a bit encouraging that this has happened. This change represents a huge opportunity for network engineers to gain more control over the network than they've ever had. Historically, these network services were hidden behind "value-add, differentiating features" like CLI syntax (insert sarcasm undertone here). In the new world these services are either taking place in open-source software, or are at least driven by well-designed, well-documented APIs. So, this new model is out there ready for us. We can take it, or lose it.

# Conclusion

The migration of network services out of the network itself was inevitable, but it's absolutely not a death blow to the network engineer - it's a huge opportunity to move forward in a big way. There's a lot of work to do, but as [I wrote about last week](https://keepingitclassless.net/2017/03/learn-programming-or-perish/), the networking skill set is still sought after, and still needed in this new world.

[I'll be speaking at Interop ITX](http://info.interop.com/itx/2017/scheduler/session/fundamental-principles-of-automation) in Vegas next month, about this, and more related topics. If you want to talk about automation, or just geek out about beer or food, I'd love to chat with you.

