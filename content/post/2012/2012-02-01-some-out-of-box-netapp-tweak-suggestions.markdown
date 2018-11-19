---
layout: post
title: Some Out-of-Box NetApp Tweak Suggestions
author: Matt Oswalt
comments: true
categories: ['Storage']
date: "2012-02-01"
wordpress_id: 1922
slug: some-out-of-box-netapp-tweak-suggestions
tags: ['netapp']
---


It's interesting to me to see the differences in infrastructure products as it pertains to out of the box, or default configuration. Take for instance, the relationship between a firewall and a switch. Your average firewall is configured "closed", meaning that if you want to allow anything, you have to explicitly allow that certain type of traffic. If you do not, it is not allowed. A switch, on the other hand, is configured to be functional above all, out of the box. Even high-end switches, with all the advanced switching feature sets that they have, are configured out-of-box to start switching frames immediately, with absolutely no configuration needed, if that is the desire. Most of what you'll see in IT, whether it be infrastructure like routers/switches/firewalls, or platforms, such as Windows Server, which MS decided to start hardening by default (finally) starting with 2008 R2.

That said, whenever I post information about hardening a system to be more secure, it's not necessarily because that product is insecure, but rather that the designers wanted it to be functional, and leave it to the implementation engineers to harden it according to customer environments. This is one such post. I'll be speaking specifically about a Netapp filer I'm configuring at the moment. It is a FAS3200 series filer running ONTAP 8.0. It has a few options left to defaults that you may want to tweak. These are simply options I've been shown in my studies from various sources that might need to be tweaked. They will obviously vary depending on the environment - so take this with a grain of salt.

First, there is a call-home feature that notifies Netapp about various health metrics, or other support functionality. Some might not want this to be turned on for security reasons, but there could be others. Be sure, however, to use other alert mechanisms so you're still made aware of any issues.

    options autosupport.enable off
    options autosupport.support.enable off

Next, it's a well-accepted practice to force signing of CIFS sessions.
    
    options cifs.smb2.signing.required on

Every volume created will automatically have an NFS export created for it. This means that if you've exposed NFS functionality to your IP network, your volumes will be presented via NFS to anyone on your network. The default permission settings aren't (fortunately) blown COMPLETELY open, but they are not locked down, and frankly, the export should not be created automatically. You're already creating the volume, it's not difficult to take it one step further and create the corresponding NFS export, in my opinion. In technical precision, this option will control whether or not volume-related commands make changes to the /etc/exports file.

    options nfs.export.auto-update off

Next, you can disable that pesky snapshots folder that I'm sure many of you have seen at the root of your CIFS shares, for instance in the vSphere datastore browser. Not only is that a bit annoying, but it's quite insecure. You probably don't want anything to have access to this folder. The following option will prevent the snapshots folder from appearing in the root of the CIFS share.

    options cifs.show_snapshot off

This CIFS feature allows snapshot folding, which trades a slight performance hit for additional storage efficiency.
    
    options cifs.snapshot_file_folding.enable on

Next, if you have the hardware support, enable flexcache. For those that don't know, flexcache is an awesome component that takes frequently accessed blocks of data and places them on a very fast flash cache module. It is read only, so writes must still be sent to disk, but the WAFL file system allows writes to be very fast anyway.
    
    options flexcache.enable on

You may want to disable the HTTP admin interface, commonly referred to as FilerView (sadly soon to be deprecated). This is simply preference, though technically, having it enabled increases the security footprint of the filer.
    
    options httpd.admin.enable off

For more information about various Netapp options, check this page out:

[http://backdrift.org/man/netapp/man1/na_options.1.html](http://backdrift.org/man/netapp/man1/na_options.1.html)

I'll admit this is a condensed list. Did I miss a really important option or set of options for tweaks that may apply to the majority of implementations that differs from the default configuration? Please let me know in the comments.
