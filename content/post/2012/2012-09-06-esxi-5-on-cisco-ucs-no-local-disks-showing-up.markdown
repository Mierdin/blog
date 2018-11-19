---
layout: post
title: ESXi 5 on Cisco UCS - No Local Disks Showing Up
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2012-09-06"
wordpress_id: 2423
slug: esxi-5-on-cisco-ucs-no-local-disks-showing-up
tags: ['cisco']
---


I am installing ESXi 5 on a Cisco UCS B440 M1 blade, and ran into some local disk issues. I used both the stock ESXi 5 image from VMware, as well as the recently released image from Cisco that contains the latest UCS drivers. Same issue on both.

The issue was that when I got to the disk selection screen on the ESXi installation, I did not see any disks:

[![](assets/2012/09/1.png)](assets/2012/09/1.png)

I had a gut feeling that the RAID controller was configured incorrectly, which turned out to be true. There are two ways to fix this.

## Via UCS Manager

Check out the documentation regarding local disk policies on Cisco's site:

[http://www.cisco.com/en/US/docs/unified_computing/ucs/c/sw/raid/configuration/guide/Cisco_UCSM.html#wp1068267](http://www.cisco.com/en/US/docs/unified_computing/ucs/c/sw/raid/configuration/guide/Cisco_UCSM.html#wp1068267)

I have rarely set these to anything but "Any Configuration", since the vast majority of my ESXi installs are done via Autodeploy, or Boot from SAN. Regardless, the easy way to fix this issue is to simply create and apply a local disk policy that matches what you want.

[![](assets/2012/09/6.png)](assets/2012/09/6.png)

Long story short, "Any Configuration" will simply pass through the current configuration on the disks, which for me was nothing. Therefore, no storage was presented to the installer.

## Directly on the RAID Controller

When prompted during startup, enter the RAID Web BIOS by pressing 'C', or on some hardware types, Ctrl + H. When the configuration screen loads, go to "Configuration Wizard".

[![](assets/2012/09/2.png)](assets/2012/09/2.png)

Selecting New Configuration will erase all data on the drives and re-initialize them for the new RAID configuration we will apply in the next steps.

> I don't care for my installation because the drives were new and had no data, but be wary if you have existing data - this wipes EVERYTHING - you have been warned.

The next screen asks what kind of configuration you need. I don't mind letting the wizard set up proper redundancy, so I selected "Automatic Configuration" and specified to be as redundant as possible. That resulted in this configuration:

[![](assets/2012/09/3.png)](assets/2012/09/3.png)

Where before there were no virtual drives, there is now one. Basic mirrored drive configuration.

Had I specified that these drives should just be initialized, and not placed into a virtual drive for RAID, that would have worked just as well. I don't need the extra storage, since this is just hosting ESXi, so RAID1 will suffice.

Exiting out of the WebBIOS now will prompt a reboot, after which you will see this upon initialization of the RAID controller:

![](assets/2012/09/4.png)

We now see a virtual drive upon startup, and when ESXi loads up the next time....

[![](assets/2012/09/5.png)](assets/2012/09/5.png)

Strange that this was the default configuration for these blades, but regardless, a simple reconfiguration for proper redundancy and disk initialization did the trick.

Note that if you have anything other than "Any Configuration" in your local disk policy, you could have some issues when configuring directly in the WebBIOS in this way. I would use this method if you have a policy in place but want to deviate from it for some reason. I would also create standalone service profiles that have the "Any Configuration" disk policy set.

Hope that helped!

> Thanks to [@ajkuftic](https://twitter.com/ajkuftic) for pointing out the UCSM method to doing this!