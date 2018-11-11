---
layout: post
title: 'KIClet: IOS "network" Command Cheating'
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-07-12"
wordpress_id: 4196
slug: kiclet-ios-network-command-cheating
tags: ['bad', 'habits']
---


I have always used the "network 0.0.0.0 0.0.0.0" statement to describe "all interfaces" when configuring a routing protocol like EIGRP. I know that it's not correct, but I never stopped to wonder why my bad habit still worked.

Then, I found this [good article by](http://blog.brokennetwork.ca/2011/02/how-ios-cheats-when-using-network.html) [@jdsilva](https://twitter.com/jdsilva) explains this is IOS just assuming you had a "brain fart" and meant to type the proper "network 0.0.0.0 255.255.255.255"

I'm studying for the CCIE and it can be really good to identify these bad habits that, while in real life may not be too bad, especially this kind, where the result is the same, but on exams can mean the difference between failure and success.

By the way, yes, my favorite command in NX-OS is still this:

    cli alias name wr copy run start
