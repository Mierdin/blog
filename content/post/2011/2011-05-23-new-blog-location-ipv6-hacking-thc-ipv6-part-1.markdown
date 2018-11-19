---
layout: post
author: Matt Oswalt
title: New Blog Location / IPv6 Hacking - "thc-ipv6" [Part 1]
excerpt: Some recent academic experiences allowed me to play with some IPv6 hacking
  tools. By far, the easiest to use tool that's specifically designed to exploit vulnerabilities
  in an IPv6 network is the "thc-ipv6" suite by The Hacker's Choice. There are about
  25 scripts in this suite that allow a hacker (Okay....or pentester....)  to do all
  kinds of nasty stuff on an IPv6 network.
comments: true
categories: ['IPv6']
date: "2011-05-23"
wordpress_id: 332
slug: new-blog-location-ipv6-hacking-thc-ipv6-part-1
tags: ['DoS']
---


> I'm pleased to announce the first post in my blog's new location, here at [keepingitclassless.net](https://keepingitclassless.net). I have been running a casual blog from my house for the past two years with mixed success. Residential internet connections as they are, this was usually hit or miss regarding whether or not my blog was even reachable. I've moved all that content to a web host which should prove to be much more reliable.
>
> I'm taking advantage of the whole Facebook thing to get the word out about the new blog, so feel free to "Like", and you'll receive updates more often!
>
> With that, I'd like to welcome you to [keepingitclassless.net](https://keepingitclassless.net)!

Some recent academic experiences allowed me to play with some IPv6 hacking tools. By far, the easiest to use tool that's specifically designed to exploit vulnerabilities in an IPv6 network is the "thc-ipv6" suite by The Hacker's Choice. There are about 25 scripts in this suite that allow a hacker (Okay....or pentester....)  to do all kinds of nasty stuff on an IPv6 network.

I'd like to make clear that I am in no way taking credit for these scripts - and I would encourage you to head over to [http://www.thc.org/](http://www.thc.org/). They have much more than just this toolkit. (They also maintain the infamous "Hydra" - a very fast network logon cracker.)

I'll be the first to say that they're almost too easy to use - these kind of tools forgo the concept of understanding what's going on when using them, paving the way for script kiddies to abuse the heck out of them. However, they are instrumental in situations where these insecurities have to be demonstrated to an audience not already familiar with the topic - sometimes simpler is better.

The "flood_router6" script is made to take advantage of the inherent weakness in operating systems that blindly accept IPv6 Router Advertisements. It floods the network with hundreds of fake router advertisements per second. While most Linux Distributions perform well with this attack, accepting none of the spoofed router advertisements, Windows blindly accepts each advertisement, adding the IPv6 address, Temporary IPv6 address and Default Gateway settings as a result of the Router Advertisement being sent. This is a "feature" that is present even in the most recent Windows operating systems, including Windows 7.

[![](assets/2011/05/ra_flood_lotsa_ipaddrs.jpg)](assets/2011/05/ra_flood_lotsa_ipaddrs.jpg)

Shown above is the output of the "ipconfig" command on a Windows 7 laptop that had been recently attacked with this script. As a result, thousands of IPv6 addresses were added, which caused so much stress on the CPU and memory, the device became completely unresponsive and eventually required a reboot to remove the thousands of fake addresses in memory.

The attack itself is simple. The Linux hacker's distribution "BackTrack 4 R2" has a directory dedicated to the "thc-ipv6" suite at

    /pentest/spoofing/thc-ipv6

Once the attacker is within that directory, the command used to run the attack is:

    ./flood_router6 eth0

(where "eth0" is the network interface on the attacking machine from which to flood the network with router advertisements)

[![](assets/2011/05/ra_flood_bt4.png)](assets/2011/05/ra_flood_bt4.png)

Within seconds, the windows client becomes completely unresponsive, and the CPU utilization maxes out. The computer memory utilization also starts to increase.

[![](assets/2011/05/ra_flood_cpu_memory.jpg)](assets/2011/05/ra_flood_cpu_memory.jpg)

That's all it takes to execute a devastating attack on the clients on the network. Since router advertisements are sent to the multicast group ff02::1 which is equivalent to a Layer 2 broadcast. This means all devices in the broadcast domain would be flooded with these fake router advertisements. Depending on the network design this could affect hundreds of devices, causing catastrophic failure within seconds. A smart attacker will be looking for areas like computer labs or cube farms - areas that are likely to be part of the same broadcast domain - to maximize the impact of this attack.

For more on The Hacker's Choice or their IPv6 hacking toolkit, head on over to [http://www.thc.org/](http://www.thc.org/). I'm an IPv6 geek, and there are 24 more scripts in this suite, so stay tuned for more on this toolkit!
