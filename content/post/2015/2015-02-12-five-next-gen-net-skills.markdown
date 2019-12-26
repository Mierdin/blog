---
layout: post
title: Five Next-Gen Networker Skills
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2015-02-12"
wordpress_id: 6027
slug: five-next-gen-net-skills
tags: ['bgp']
---


With all the flux that is going on in the networking space, it's hard to figure out what to do next. You may want to add to your skillset, but you're not sure where to throw your effort. I'd like to focus on five different areas you can focus on, without talking about a specific product - at the end of the day, that's just implementation details. These areas are going to be increasingly more valuable and will help you be more marketable when added to your existing network knowledge and experience.

This isn't meant to say that all of these skills are required to move your career forward; indeed, everyone's situation is unique. These are just ideas - the way you implement these skillsets in your own life is up to you.

## 1. Software Skills

Here, I'm not necessarily talking about full-fledged code knowledge. This section isn't about going and getting a 4 year CS degree. This is mostly about tools, methodologies, and workflows. For some, this will include some kind of interpreted language like Python, but will vary in degree greatly from person to person.

[![I_am_a_Programmer](/assets/2015/02/I_am_a_Programmer.png)](/assets/2015/02/I_am_a_Programmer.png)

To help get more detailed with this point, I'd like to drill down on four very specific areas within the "software skills" umbrella that you might find useful in your career.

**Configuration Management Frameworks** - You should familiarize yourself with at least one of these tools, like Puppet, Chef, Ansible, Salt, or Schprokits. These tools allow you to get to the meat of what infrastructure automation is all about, and that is a standardized workflow. You can use some of the built-in functionality to get started very quickly, without needing to be a hardcore programmer.

**Git** - It's important to have some knowledge of a version control system. The reason I mention Git specifically is because I believe it has the lowest barrier to entry than any of the alternatives. I won't say that Git is easy....some of the more advanced concepts still have my head spinning daily. However, it is widely used, and though it may not be easy to learn all the bells and whistles, it's design lends itself to simplicity, and the less advanced features are not difficult to pick up quickly.  Even if you're using it for simple configuration artifacts, such a switch configuration, or maybe a few YAML files and Jinja2 templates, it can be a powerful part of your workflow, and support for it is very widespread.

**Continuous-Integration and Test-Driven-Development** - It is impossible for me to go very deep with either of these topics in this article. I've [already written a post](https://oswalt.dev/2015/01/continuous-integration-pipeline-network/) on the former, and am planning one soon for the latter. I will say this: these ideas can really have a positive impact on system uptime.  The driving idea behind both of these idea is to get code to production faster, without compromising on quality, or disrupting operations. When problems do arise (and they will), these also allow us to return to a stable state more effectively. If you think of your configuration changes as source code, you're now treating your infrastructure as a version-controlled software product.

There is no Rosetta Stone for what this means to your infrastructure, but the key idea (especially with test-driven development) is that you have a feedback loop in place that is able to accurately test the success or failure of a change. If you are automating changes to an access-control list, this means being able to instantly test connectivity that is reflected by that change, and if the tests fail, the change gets rolled back. I hope to elaborate on the idea of test-driven development in a future post very soon.

**Code** - The reality is that no existing tool answers 100% of everyone's needs, and if you have a corner case that needs addressed, you may need to be able to write some kind of extension to an existing tool, or even a new tool entirely. The need for this skillset is totally dependent on the use case, but.....if you have the time and interest, why not?

## 2. Linux

I am convinced that an understanding of how networking works in a Linux system is becoming more and more important every day.

For the most part, we still rely heavily on closed, monolithic platforms from the big vendors to make our packets go. This is a paradigm that won't change overnight, so there will continue to be value in learning your vendor's certification stack relevant to your job for quite a while.

[![Gnulinux](/assets/2015/02/Gnulinux.png)](/assets/2015/02/Gnulinux.png)

However, as data center networks become simpler, and lower-level network functions like L2 and L3 offloaded to the hypervisor, much of the process for configuring and troubleshooting network connectivity is taking place in a Linux distribution of some kind. Software like ifupdown and Quagga are good places to start for this.

Linux has a very different look and feel compared to the traditional monolithic CLI presented by IOS or JunOS. There will be a learning curve if you're a CCIE/JNCIE that has lived on the vendor CLI for years. Networking is beginning to move in the direction of the [Unix philosophy](http://www.faqs.org/docs/artu/ch01s06.html), which - among other things - teaches that we build processes to do one thing, and to do it well. Using Linux in a networking context obviously gives great credit to this idea, and allows us to assemble that which we need, and no more.

## 3. Deep Protocol Knowledge

If you go through the standard certification track for your favorite vendor, chances are that the curriculum will include a good amount of information about various standard networking protocols like Spanning-Tree, OSPF, BGP, or MPLS. This is especially true in the lower-to-mid level certifications, since at that point, most of the information is still pretty new. However, the higher-level certifications focus a lot more on vendor-specific implementation details. Though there is plenty of this in the lower-level certs as well, this is especially true here, since the fundamentals have been more or less covered at this point. It makes sense; one of the primary purposes of a vendor certification is to train a larger technical sales force for that vendor.

[![Icons11](/assets/2015/02/Réprésentation_dinternet.jpg)](/assets/2015/02/Réprésentation_dinternet.jpg)

If you work for an organization that uses only a single vendor, you probably don't need to go much further than the configuration notes for that product. However, I've noticed that multi-vendor networks and open source implementations of networking protocols are on the rise. In this case, the vendor's documentation isn't always sufficient, because it only addresses a portion of your infrastructure. The common denominator here is the open protocols and standards that allow these vendors to interoperate. Knowing JunOS or IOS syntax takes a back seat to knowing BGP **really** well, because only then will you be able to run a network that's composed of both.

I put this section here, not to talk trash about vendor certifications, but to make the point that there is a common skillset that supercedes vendor-specific details. Even the new fancy SDN stuff is using some of the nerd knobs present in protocols like BGP to do [cool new things](https://tools.ietf.org/html/draft-lapukhov-bgp-opaque-signaling-00), and it's beneficial to have the deep protocol knowledge to be able to speak to it.

## 4. Hypervisor and Container Networking

One of the earliest things I did to begin to break out of the traditional "I know Cisco routing/switching" silo was to begin to move down into the compute layer with regards to forwarding traffic. At the time I knew I was going to need to know more about virtualization, and I figured that applying my networking knowledge as a transition point into this space was a good move. And it worked out pretty well. I even got [a few good posts out of it](https://oswalt.dev/series/virtual-routing-2/).

In the past 4 years this has become one of the biggest focus areas for network innovation. My good friend Brent Salisbury says it best - [the virtual edge is the new network edge](http://networkstatic.net/network-iceberg/). By the time you get to the physical network, you're already at the second tier of the hierarchy. It is no longer acceptable to view the ToR as the sole demarcation between network and compute.

[![Container_ship_Hanjin_Taipei](/assets/2015/02/Container_ship_Hanjin_Taipei-1024x768.jpg)](/assets/2015/02/Container_ship_Hanjin_Taipei.jpg)

It worked for me, so maybe it will work for you. I highly recommend that you acknowledge that the access layer is now inside a server for those virtual workloads, and become familiar with the way vSphere virtual switching works, or check out [Open vSwitch](http://openvswitch.org/). Container networking is also going to be bringing a new face to this - Jon Langemak has written some [PHENOMENAL posts](http://www.dasblinkenlichten.com/docker-networking-101/) on Docker, Kubernetes, CoreOS and more - all from a networking perspective. With the tools available in the open source community, there really is no excuse to not be branching out and pushing yourself to learn new things outside of the traditional stack.

## 5. IPv6 (Everything is Dual-Stack)

Now before you say anything, I'll admit that the phrase "This is the year of IPv6" is a bit cliche at this point. For a 20 year old protocol, it's easy to assume that if it hasn't caught on, it never will.

However, that's not really an option. The internet has exhausted supply of IPv4 address space very incrementally, and at each "milestone", this battle cry has been uttered, but we're actually there now. We're actually at the point where significant portions of the world can ONLY get IPv6 connectivity. The time is coming for those of us languishing in IPv4 splendor. It may not happen in 2015, but it will happen, and soon enough, recruiters will be asked to filter out resumes that do not contain "IPv6".

[![ipv6](/assets/2015/02/ipv6.png)](/assets/2015/02/ipv6.png)

My recommendation is to ask if your service provider offers IPv6 connectivity. If they don't (or if it's a kludge) then check out Hurricane Electric [tunnel broker service](https://tunnelbroker.net/). I have an SSID that runs ONLY IPv6 for testing purposes, as well as another that is dual-stack. I plan on doing some extensive testing very soon to see exactly what devices **really** support v6, and will do my part to keep vendors accountable. This is my way of eating my own dog food in a somewhat forgiving environment (my home) so that I don't piss off the wrong people at work. The key is to think of everything in dual-stack. Assume that for everything you do you'll have to configure it in both IPv4, and IPv6. It's useful as a thinking exercise at a minimum.

## Conclusion

I hope this list was useful - let me know in the comments if you think I left anything out!
