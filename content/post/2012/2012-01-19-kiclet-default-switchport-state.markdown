---
layout: post
title: 'KIClet: NX-OS Default Switchport State'
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2012-01-19"
wordpress_id: 1872
slug: kiclet-default-switchport-state
tags: ['kiclet']
---


Cisco switches (and the vast majority of other vendors) ship their switches with all ports in the enabled state. This allows someone with no networking background to plug stuff in, the switch starts learning MAC addresses, and everything works just fine. Sometimes it's necessary from a security perspective to change this default behavior, so the network engineer is forced to "no shut" every port he or she wishes to use.

In NX-OS this is a particularly interesting subject because it also is a security best practice to do this, not only for your Ethernet ports but also for Fibre Channel.

The command to shutdown all Ethernet ports by default is:
    
    switch(config)# no system default switchport shutdown

If you wish to also do this with all Fibre Channel ports, simply append the "san" keyword like so:
    
    switch(config)# system default switchport shutdown san

As always, you can "no" out either command to undo this configuration:
    
    switch(config)# no system default switchport shutdown
    switch(config)# no system default switchport shutdown san

Not only a good idea from  a security perspective, but has a habit of helping to clean up your configuration by eliminating a few redundant "shutdown" commands, since it becomes default behavior.
