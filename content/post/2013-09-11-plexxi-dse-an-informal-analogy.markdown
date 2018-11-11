---
layout: post
title: 'Plexxi DSE: An Informal Analogy'
author: Matt Oswalt
comments: true
categories: ['Tech', 'Field', 'Day']
date: "2013-09-11"
wordpress_id: 4623
slug: plexxi-dse-an-informal-analogy
tags: ['nfd6']
---


Sitting in the NFD6 demo with Plexxi and got a great overview of the DSE product they've been working on. This service allows them to dynamically build network configurations based on external services like Openstack, puppet, etc.

The example that Derick provided was the fact that an access list - instead of referring to a source IP address, or destination port, etc. - we can now refer to  a puppet request, for instance. In other words, "permit getPuppet()", where getPuppet will evaluate to whatever that request returns in real-time, dynamically.

Consider the following. I have a script that goes out to insert a configuration line in a list of devices. That list of devices is maintained statically in the script (don't act like you've never written a script with static IP addresses in it). What Plexxi is doing is the equivalent to creating a method in your script that reaches out to a database of some kind, whose job it is to maintain the proper list of network devices, and grabbing the list from that in real time. Static IP address, meet method.

Stay tuned for more posts on this - I'm not done talking about it.
