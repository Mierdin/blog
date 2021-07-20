---
layout: post
title: The Two "Network As Code" Domains
series:
- DevOps for Networking
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2015-05-06"
wordpress_id: 6078
slug: the-two-network-as-code-domains
tags: ['automation']
---


You've probably heard the term "network programmability" at this point. You probably also heard it equated to anything to do with code, automation, and networking. This was not always the case.

Network programmability really first hit the big time back in 2011 in the early days of the public OpenFlow discussion. That phrase was almost universally understood to be a data plane concept - because it was describing the revolutionary ideas brought up by abstracting away a forwarding pipeline. "You mean I can program my network device directly?" Network programmability.

I was inspired by a thread that my friend Josh kicked off with this tweet:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">I am far from being a dev but I am no longer scared to learn to code. Thanks to the folks helping me start to get it.</p>&mdash; joshobrien77 (@joshobrien77) <a href="https://twitter.com/joshobrien77/status/591313039657476097">April 23, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

An interesting dialogue followed, and I felt compelled to address the problem caused by marketing departments muddying the waters of what would otherwise be a very simple idea.

Now obviously it's too late to "right the wrong" that resulted from marketing and journalism engines chugging at full steam trying to make every technical term and phrase utterly useless. However, I would like to offer the dichotomy of the networking industry the way I see it. These two areas are quite different from each other as it applies to "writing code", and could represent entirely different career paths for someone looking to evolve their skillsets.

## 1 - Network Ops as Code

It was only a very short time ago when the term "DevOps" was even mentioned in the same breath as "networking" for the first time, and already the term is nearly meaningless in this context. These days it essentially means "automation", and typically about a very specific automation or configuration management tool.

So screw all of that - let's just say that adopting such practices is basically just a better way of doing Ops. It is in this area where most operators write scripts to automate their provisioning or troubleshooting tasks. And there are a ton of these out there, if maybe a little outdated and neglected.

And that's fine! Why try to make it something that it's not?! The point is that if you're writing code at all, you're doing it because you are a network operator, and you want to be better at it. You don't want to be a programmer. This area is certainly not for full-time developers only - most full-time devs don't have the time or inclination to run a network. This area is all about learning enough about languages and tooling to add value to your role as a network operator.

However, let me mention that there is a lot of value in learning some of the very high-level practices involved with software development - it will help you in your efforts to run your network more efficiently. Methodologies like [Continuous Integration](https://oswalt.dev/2015/01/continuous-integration-pipeline-network/) and Test-Driven Development are **absolutely** applicable to network infrastructure, and some of the same benefits can be realized as well. For instance - making changes in smaller chunks that can be easily tested is a very good way of helping to keep your name off of an outage report.

Adopt some software development best practices to ensure your scripts survive the test of time and actually remain in production and useful, and you'll be far better off.

For the most part, this side of the house places an emphasis on learning basic toolchains that sit outside the traditional network OS. IT professionals in this space know enough to glue together existing, loosely coupled components. They're able to - for instance - leverage the Ansible template module to render some templates that they wrote for their networking devices. They understand the basic toolset found in most Linux distributions, and are able to write simple scripts to make network metrics readily available.

If you sit in this camp, you are writing "software" that places the operator first - all scripts, shims, and templates are written to improve that person's experience and effectiveness.

## 2 - Network Programmability

There is a totally different area where a networking mindset can be applied, and it leans much more towards the "pure" software development side of the house.

The industry is seeing a trend - thanks largely to the ongoing increase in popularity of open source tools - where network services like routing, security, and load balancing are being offered in software in a distributed manner. In this case, these features are built by actual software developers.

Take the virtualized datacenter as an example - it's becoming even more trivial to move these basic functions into the hypervisor. Software like Open vSwitch allows us to do in software - in a distributed manner - what we've been relying on big expensive black boxes to do for decades. This software wasn't created just by one vendor and released as a product - rather it was created by networking professionals that took on the challenge of learning a formal language and creating something that truly required both skillsets.

The key thought here is that "network programmability" software is not simply for human consumption, but is instead about enabling more machine-to-machine communication. It is here where the "borg" will be born. This isn't universally true of all open source networking software - [Quagga](http://www.nongnu.org/quagga/) is a great open source project but is obviously built to cater to the operator, not necessarily to orchestration software. This makes the idea of "network programmability" more an ethereal concept than a black-and-white yardstick.

Do you need to be a programmer to contribute in this area? I would say not necessarily for starters, but you do need to be willing to move in that direction - this requires much more focus on actual software development methodologies and rolling out new functionality in code that you write. In this case, the software you write doesn't just automate the network, it IS the network. You're literally rolling out network services like your favorite iPhone application rolls out features.

## Conclusion

In essence, this comes down to two things:
    
  1. Are you a network operator that's interested in moving forward with some of this, but the idea of churning out features in code bores/scares you? Then don't go down that path! There's plenty of value in being able to leverage existing tools and features from your networking vendor or from open source projects by adding a little bit of your own logic where it's needed.

  2. If you want a bit more than just operationalizing existing tools, there are quite a few areas where you can contribute. Check out the open source projects like Open vSwitch, Docker, and OpenStack. There are plenty of folks on these projects that will help you get up to speed on full-blown software development.

The separation of these ideas are fundamentally why the whole "network engineers have to learn to code" idea is extremely misleading. I think there's plenty of value in learning a programming language, and it will certainly increase your marketability, but "learning code" isn't just a one-size-fits-all idea.
