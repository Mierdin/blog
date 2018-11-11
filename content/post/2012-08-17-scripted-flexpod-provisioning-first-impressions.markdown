---
layout: post
title: Scripted Flexpod Provisioning - First Impressions
author: Matt Oswalt
comments: true
categories: ['Datacenter']
date: "2012-08-17"
wordpress_id: 2277
slug: scripted-flexpod-provisioning-first-impressions
tags: ['automation']
---


I had the opportunity this week to ascertain the feasibility of automating the provisioning of a full Flexpod. For reference, this is considering a "vanilla" Flexpod build:

  * Pair of Nexus 5ks
  * Pair of Cisco UCS Fabric Interconnects (with a few chassis)
  * Netapp running ONTAP 7-Mode (I tested on FAS6070)

Note that this also makes a few assumptions about the build.

  * FC via Nexus 5000, no MDS
  * No existing vCenter integration or storage migration

So - pretty much a green field Flexpod build, pretty close to the specs laid out in the design guide.

Even such a standard, relatively simple Flexpod build can take 80 hours or more. Excluding the initial customer engagement, the planning, design, implementation, and operation stages are quite time-consuming.

Enter a blog post by Netapp engineer "ahohl", originally posted in October 2001:
[https://communities.netapp.com/docs/DOC-13143](https://communities.netapp.com/docs/DOC-13143)

If your first thoughts were anything like mine, you thought:

![](https://southparkstudios-intl.mtvnimages.com/shared/sps/images/shows/southpark/vertical_video/import/season_07/sp_0710_04_v6.jpg?width=480)

Now, once you recover, a few things to think about.

This "suite" of scripts is no longer in development. It appears that the creator was given a few months to throw together a killer set of scripts that would eventually make itself into some kind of product by Netapp. However, other solutions came out, and Netapp decided to partner with those vendors rather than continue to develop these scripts.

Also, if you think you will be able to just download these scripts, plug in the variables, and go, think again. These scripts have quite a few prerequisites, not only the ones listed, but a few not listed. Assuming I'm given the chance to continue to work on these, I fully intend to deploy everything via a pre-built Windows 2008 VM that contains all the prerequisites, and is also able to provide advanced services that can compliment future additions, such as PXE booting.

Finally, the scripts are.....not complete. I ran into several instances, mostly with respect to the Netapp storage, where the configuration didn't work as desired. The script made a nice effort to define the VIFs where NFS, FCoE, and CIFS were supposed to run, but it didn't create any ifgrps on the filers where these VLAN interfaces would be defined, so pretty much the entire networking configuration was broken.

## Conclusion

Even though it would take a lot of work to get these scripts functioning reliably enough to repeat on some kind of "Flexpod Assembly Line", it's hard to ignore their potential, especially in the face of current automation products, some of which can cost around $8,000 per Flexpod (yikes!).

I mentioned that it can take up to 80 hours from scratch to conclusion for a typical Flexpod installation. I got the scripts to the point where I could run them reliably and install my own values supplied via CSV file, and after 27 minutes, the script finished and all three components were configured. That's 27 minutes, folks.

My definition of "configured" is somewhat minimal, but without having to do anything myself - just relying on the scripts - I was able to see a Fibre Channel LUN provisioned by Netapp to the ESXi servers in UCS. The Netapp's aggregates, volumes, LUNs and igroups were all configured, the Nexus 5ks were all zoned, and the UCS had everything it needed to spawn services profiles and boot a server in order for ESXi to see the LUN being presented to it. That's a lot of work that I didn't have to do.

I will be posting details of my first trial run, as well as any future development efforts I can commit to this at a later date, but I wanted to post my initial thoughts first. I'd like to continue to build out some of the features I've seen missing, such as fixing the Netapp networking section, as well as some really ambitious features that are no more than scratches on a napkin right now.

Even with all the bugs, this guy put together something spectacular, and I really would hate to see it get buried in history.
