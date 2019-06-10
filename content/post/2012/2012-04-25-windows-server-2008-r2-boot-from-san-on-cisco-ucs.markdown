---
layout: post
title: Windows Server 2008 R2 Boot From SAN on Cisco UCS
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2012-04-25"
wordpress_id: 2148
slug: windows-server-2008-r2-boot-from-san-on-cisco-ucs
tags: ['bfs']
---


For those that have worked with any type of blade server system, you know that boot from SAN is just about the coolest thing since sliced bread. Cisco UCS makes this even cooler by integrating with the service profile concept, allowing for stateless compute provisioning across the board.

I've done boot from SAN many times, but never with Windows. I've primarily used ESXi4.1 or ESXi5.0 stored on a Fibre Channel LUN, then the VMs are stored in either a FC or NFS datastore. Running a BFS for baremetal Windows isn't something I'd explored yet.

So the first thing I do is get the B-series drivers ISO from Cisco, which allows me to light up the M81KR adapter during Windows installation and get the SAN accessible.

When I hit "refresh", I'm able to see the local storage installed in the system, as well as the Fibre Channel LUN I set up.

[![](/assets/2012/04/screen14.png)](/assets/2012/04/screen14.png)

You'll notice that there's an error shown at the bottom. Clicking on this will bring up the following message:

    Windows is unable to install to the selected location.  Error: 0x80300001.

    Windows cannot be installed to this disk. This computer's hardware may not support booting to this disk. Ensure that the disk's controller is enabled in the computer's BIOS menu.

[![](/assets/2012/04/screen121.png)](/assets/2012/04/screen121.png)

As a side note, I've already heard that the Windows installation environment, WinPE, has problems with FC multipathing, so I was careful to construct my zoning (for now) so that only one FC path was available. Otherwise you'd see multiple instances of the same LUN, which confuses WinPE. It's very important to change this to a redundant design after installation.

My boot policy follows this idea - as I said, it's important to change this after installation to ensure a redundant design:

[![](/assets/2012/04/screen5new.png)](/assets/2012/04/screen5new.png)

The cause of this issue is that the BIOS for the blade was unable to distinguish between the FC storage and the local storage. I was not aware of this, but ESXi had been installed on some of the local disks. Windows detected this potential conflict and notified me that the BIOS settings were incorrect. Unfortunately, it did not say what exactly was wrong about it - I had to dig around to arrive at this conclusion.

In order to even test this theory, I simply pulled the local disks stored in the blade. Upon restarting the blade and getting back to the installation screen, I see that the other disks are gone, and the only thing I see is my 150G Fibre Channel LUN. However, when I try to install this time, I get yet another error message:

    Windows cannot be installed to this disk. The selected disk has an MBR partition table. On EFI system, Windows can only be installed to GPT disks.

    Windows cannot be installed to this disk. This computer's hardware may not support booting to this disk. Ensure that the disk's controller is enabled in the computer's BIOS menu.

[![](/assets/2012/04/screen7.png)](/assets/2012/04/screen7.png)This is also quite a simple fix, although it required that I recreate the boot LUN.

My Fibre Channel SAN is a Netapp 3240. The LUN thats created is part of a larger volume that will hold several boot LUNs for servers. In order to change the type of LUN, you must delete and recreate, making sure to select type "Windows GPT" during creation:

[![](/assets/2012/04/screen8.png)](/assets/2012/04/screen8.png)Fortunately, you shouldn't have to reboot to see the changes, simply click "refresh" in the Windows installer, and attempt to create a new partition again.

If you get the following message:

    Setup was unable to create a new system partition or locate an existing system partition.

Try disabling EFI boot in the BIOS of the blade:

[![](/assets/2012/04/bios.png)](/assets/2012/04/bios.png)

Read [this helpful thread](https://supportforums.cisco.com/thread/2131105) for more details on this

That should allow you to install to the disk.

[![](/assets/2012/04/screen10.png)](/assets/2012/04/screen10.png)

Note that although the error message stating that installation to the disk is still not possible, the "Next" button is no longer greyed out. Clicking this will provide you with the great screen of success, shown below:

[![](/assets/2012/04/screen111.png)](/assets/2012/04/screen111.png)

Kind of a pain, especially when you think about how bloody easy it is to install and configure boot from SAN for ESXi. However, if you remember a few of these "gotchas", you can get it working.

For those looking for slightly more "official" guides on the process of running boot from SAN for Windows, here's some vendor materials pertaining to the subject. Some were helpful in my specific situation, some were simply educational in general.

## Links

* [UCS - Installing Windows 2008 Server](http://www.cisco.com/en/US/docs/unified_computing/ucs/sw/b/os/windows/install/2008-vmedia-install.html)
* [Cisco B-Series Blade Servers Windows Installation Guide](http://www.cisco.com/en/US/docs/unified_computing/ucs/sw/b/os/windows/install/BSERIES-WINDOWS.pdf)
* [Microsoft KB article on BFS](http://support.microsoft.com/kb/305547)
* [Netapp Community Thread regarding BFS with Windows](https://communities.netapp.com/community/netapp-blogs/msenviro/blog/2011/08/16/lab-notes-san-boot)
* [Windows Boot from Fibre Channel SAN - An Executive Overview and Detailed Technical Instructions for the System Administrator](http://www.microsoft.com/download/en/details.aspx?id=2815)


