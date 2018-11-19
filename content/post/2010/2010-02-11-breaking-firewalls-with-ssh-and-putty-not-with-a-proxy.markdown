---
layout: post
title: Breaking firewalls with SSH and puTTY - NOT with a proxy.
author: Matt Oswalt
comments: true
categories: ['Security']
date: "2010-02-11"
wordpress_id: 68
slug: breaking-firewalls-with-ssh-and-putty-not-with-a-proxy
tags: ['firewall']
---


I've been seeing a lot out on the internet about proxy servers and how to use them to circumvent your school or workplace internet filters.

Lifehacker recently posted an ~*EIGHT PAGE*~ [walkthrough](http://lifehacker.com/5469038/bypass-heavy+handed-web-filters-with-your-own-proxy-server?skyline=true&s=i) on how to set up such a proxy at home.

This is entirely too complicated. Not only is it a long walkthrough, but your traffic is still unencrypted. Unless your school, work or other bought their filter technology more than 4 years or so ago, they can still see the header of your packets and where they're headed. Even if you have a proxy set up remotely, they'll still see that the request is eventually headed to, say, facebook, and will break the connection. No, you have to encrypt the ENTIRE stream.

Let me be perfectly clear: for the purpose they're using, proxies are just simply not the way to go. It's like killing a fly with a High-Yield Tactical Nuke. Yeah, it will get the job done, but damn is it excessive.

Proxy servers are intended to, among other things, provide network administrators a way to REQUIRE users to authenticate to their proxy server before being even let out to the internet. Most employers do this, and schools are starting to. This helps to ensure that only authorized users are using the internet at the location, and that all that activity is logged. Proxy servers also cache content from sites that users go to often, so that the content doesn't have to be downloaded fresh every time someone navigates to the site.

Using a proxy server to get past a firewall may work some of the time, but your employer will still be able to see that the request will eventually be forwarded to facebook, myspace, piratebay, or wherever you're going, EVEN IF THE SITE IS USING SSL (https)! Network traffic is transmitted in packets, and when you send a request to a site that uses HTTPS, the part of the packet that contains the information you're transmitting is encrypted, but the part that says where that packet is headed IS NOT ENCRYPTED. This could mean one of two things for you; either your network admin is smart, and has a firewall that reads these "packet headers" and denies them regardless of whether or not they're headed to a proxy first, or keeps this header in the internet logs, which could lead to consequences. Or both. More than likely both. Yeah....both.

Now that you know the problem, you want to know how to encrypt the header part too, right? Right! How do we do that?

SSH is all you need. Most of you are familiar with it and for those that aren't, google it. This isn't a walkthrough of how to do it, there are plenty out there, [take this one for example](http://souptonuts.sourceforge.net/sshtips.htm). However, I will briefly explain how this is highly preferred to using a proxy.

This is done with a simple SSH server, can be a laptop, or thin client if you're concerned with power consumption.

Just google "breaking firewalls with puTTY" and you'll get results. Proxies are nice, but most of the time they're complicated, and don't really get the job done. This way, your employer, or school IT staff cannot possibly see what you're doing.

They can, however, see how much bandwidth your encrypted session is using, so don't do anything bandwidth-intensive. Staying low-key is the name of the game. But if you're careful, you'll be emulating the internet connection that serves your SSH server.

[![Putty](assets/2010/02/Putty_dock_Icon___Vista_style_by_gege32.jpg)](assets/2010/02/Putty_dock_Icon___Vista_style_by_gege32.jpg)

First, using something like puTTY as a local proxy that passes all requests FULLY ENCRYPTED straight from your laptop to your SSH server is much easier to set up. Most linux distros have an SSH server installed already, you just need to turn it on. Try out [ClearOS](http://www.clearfoundation.com/Software/overview.html), its a great RHEL-based server OS. Once you have that server exposed to the internet, its a couple of steps to allow puTTY to tunnel requests that use a port of your choosing.

Second, your network admin can't see what you're doing unless he can see your screen (or if he can hack SSH, not an easy task, I assure you). The only thing they can see is how much bandwidth your session is using. If it gets excessive, they can see where on their network it's coming from and take action accordingly. That said, don't be crazy with this. Being able to get on Youtube, Hulu, Netflix, Pandora, Slacker, etc can be tempting if those sites were previously blocked, but doing so may arouse some suspicion.

In conclusion, if you look at the [walkthrough](http://souptonuts.sourceforge.net/sshtips.htm) I linked to, you'll see that this process is not only TONS easier, but it actually gets the job done. Please consider trying this out before using a proxy.
