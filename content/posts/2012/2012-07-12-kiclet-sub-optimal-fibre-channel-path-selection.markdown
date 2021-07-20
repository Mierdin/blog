---
layout: post
title: 'KIClet: Sub-Optimal Fibre Channel Path Selection'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-07-12"
wordpress_id: 2238
slug: kiclet-sub-optimal-fibre-channel-path-selection
tags: ['esxi']
---


The SAN I'm currently working with connects a pair of Netapp FAS3270 filers running ONTAP 8.0.2 7-Mode.

If you're running VMware ESXi in your environment in front of a Fibre Channel SAN, path selection is discovered more or less in a first-come-first-served fashion.

I got this message on my Netapp filer:

    FCP Partner Path Misconfigured:
    Host I/O access through a non-primary and non-optimal path was detected.

Since the LUNs mounted by ESXi were residing on the A-side filer, the paths going through the B-side filer would just be sent over the partner link to the A-side, which is less efficient than going directly through A. However, since ESXi doesn't know which is more efficient, it uses whatever comes first.

If you want to optimize this (and I recommend it), then hop over to Netapp's support site - they've provided the ESX Host Utility toolkit for optimizing Fibre Channel on ESXi and includes a utility called config_mpath. This will allow you to set paths correctly.

The toolkit is available here:

[http://support.netapp.com/NOW/download/software/sanhost_esx/ESX/](http://support.netapp.com/NOW/download/software/sanhost_esx/ESX/)
