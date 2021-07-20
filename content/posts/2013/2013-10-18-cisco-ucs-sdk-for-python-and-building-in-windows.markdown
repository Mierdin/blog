---
layout: post
title: Cisco UCS SDK for Python, and Building in Windows
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-10-18"
wordpress_id: 4766
slug: cisco-ucs-sdk-for-python-and-building-in-windows
tags: ['api']
---


So I'm tackling a little side project - and that is to replicate my Cisco UCS configuration scripts, currently in PowerShell, but instead in Python.

While the UCS API is actually an XML interface on the Fabric Interconnects, Cisco has created a [module of cmdlets called PowerTool](http://developer.cisco.com/web/unifiedcomputing/pshell-download) so that this service can be easily consumed, rather than deal with XML serialization directly. For instance, once authenticated, you can do cool stuff like get a list of all Service Profiles on a system:

    PS C:> Get-UcsServiceProfile -Type instance | select name
    
    Name
    ----
    DI-ESXi-01
    DI-ESXi-02
    DI-ORC-01
    DI-ORC-02

Cisco has (somewhat) recently developed the rough equivalent ([though in a very early, alpha-type release](http://developer.cisco.com/web/unifiedcomputing/sdk)) for Python.

The ironic thing about all of this is that my entire reason for building out python scripts for UCS is so that I can automate tasks on both Windows and non-Windows OSs. Personally, my main development environment is Windows - but my UCS scripts will be run on a Unix-based system in production, so the emphasis for me is simply to be cross-platform, which really is just taking advantage of one of Python's strengths.

Truth be told, I expect that only a very small percentage of admins that deal with UCS are in the position of either not wanting to or not being able to run PowerShell. So the reason behind me doing anything with the Python SDK for UCS is that I want to be able to run the same scripts, anywhere, without any crazy hacks or porting. There's also a small project that requires it that I'm sure I will be posting info about in due time.

> I have a project started on github, and it is definitely in the early stages (just made the first commit today) that will aim to be a full configuration script for UCS in python. [Check it out here](https://github.com/Mierdin/pyUCS-Build).

The ultimate goal is to show Cisco that we see the value in the Python version and are really making an effort to use it. I also don't want them to get rid of the PowerTool solution (not that they would) because there's also a lot of value in running everything on a consolidated platform. Most DC infrastructure vendors that have developed anything like this have done so in PowerShell (i.e. Netapp, VMware, etc.)

After I've written a functional script to my liking, I'll make another post describing the process and contrasting it's learning curve with that of the PowerShell version.

## Building the Environment

Following the Cisco documentation, I first needed to install the Cisco python modules using Cygwin.

It's probably more important to get the version right (This didn't work with Python 3.x) - and it's probably possible to run the setup scripts outside of cygwin. However, I ran it here because it's mentioned in the docs as a supported platform.
    
    Mierdin@Nimue ~
    $ which python
    which: no python in (/usr/local/bin:/usr/bin:/cygdrive/c/Program Files/Common Files/Microsoft Shared/Windows Live:/cygdrive/c/Program Files (x86)/Common Files/Microsoft Shared/Windows Live:/cygdrive/c/Windows:/cygdrive/c/Windows/System32:/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/Wbem:/cygdrive/c/Program Files (x86)/Java/jre6/bin:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0:/cygdrive/c/Program Files (x86)/Windows Live/Shared:/cygdrive/c/Program Files (x86)/Nmap:/cygdrive/c/Program Files/apache-maven-3.1.1/bin)
    
    Mierdin@Nimue ~
    $ echo "PATH=$PATH:/cygdrive/c/Python27" >> .bash_profile
    
    Mierdin@Nimue ~
    $ source .bash_profile
    
    Mierdin@Nimue ~
    $ which python
    /cygdrive/c/Python27/python
    
    Mierdin@Nimue ~
    $ cd /cygdrive/c/users/mierdin/dropbox/code/python/UCS/UcsSdk-0.5
    Mierdin@Nimue /cygdrive/c/users/mierdin/dropbox/code/python/UCS/UcsSdk-0.5
    $ ls
    build  PKG-INFO  samples  setup.cfg  setup.py  src
    
    Mierdin@Nimue /cygdrive/c/users/mierdin/dropbox/code/python/UCS/UcsSdk-0.5
    $ python setup.py build
    running build
    running build_py
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'zip_safe'
      warnings.warn(msg)
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'include_package_data'
      warnings.warn(msg)
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'namespace_packages'
      warnings.warn(msg)
    
    Mierdin@Nimue /cygdrive/c/users/mierdin/dropbox/code/python/UCS/UcsSdk-0.5
    $ python setup.py install
    running install
    running build
    running build_py
    running install_lib
    creating C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkCcoImage.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkConstants.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkConvertFromBackup.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkMethodMeta.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkMoMeta.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkMos.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkp3.py -> C:Python27Libsite-packagesUcsSdk
    creating C:Python27Libsite-packagesUcsSdkresources
    copying buildlibUcsSdkresourcesSyncMoConfig.xml -> C:Python27Libsite-packagesUcsSdkresources
    copying buildlibUcsSdkUcs.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkUcsBase.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkUcsHandle.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdkWatchUcsGui.py -> C:Python27Libsite-packagesUcsSdk
    copying buildlibUcsSdk__init__.py -> C:Python27Libsite-packagesUcsSdk
    byte-compiling C:Python27Libsite-packagesUcsSdkCcoImage.py to CcoImage.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkConstants.py to Constants.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkConvertFromBackup.py to ConvertFromBackup.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkMethodMeta.py to MethodMeta.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkMoMeta.py to MoMeta.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkMos.py to Mos.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkp3.py to p3.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkUcs.py to Ucs.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkUcsBase.py to UcsBase.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkUcsHandle.py to UcsHandle.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdkWatchUcsGui.py to WatchUcsGui.pyc
    byte-compiling C:Python27Libsite-packagesUcsSdk__init__.py to __init__.pyc
    running install_egg_info
    Writing C:Python27Libsite-packagesUcsSdk-0.5-py2.7.egg-info
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'zip_safe'
      warnings.warn(msg)
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'include_package_data'
      warnings.warn(msg)
    C:Python27libdistutilsdist.py:267: UserWarning: Unknown distribution option: 'namespace_packages'
      warnings.warn(msg)
    
    Mierdin@Nimue /cygdrive/c/users/mierdin/dropbox/code/python/UCS/UcsSdk-0.5
    $

Once built, you can call UCS functions inside python natively in Windows, after of course, you import the module.

In this example, I get a printout of the current faults on my UCS system.

    Python 2.7 (r27:82525, Jul  4 2010, 07:43:08) [MSC v.1500 64 bit (AMD64)] on win32
    Type "copyright", "credits" or "license()" for more information.
    >>> 
    
    >>> from UcsSdk import *
    >>> handle = UcsHandle()
    >>> handle.Login("10.102.1.5", "admin", "password")
    True
    >>> orgObj = handle.GetManagedObject(None, OrgOrg.ClassId(), {OrgOrg.DN : "org-root/org-DI_DCA"})
    >>> getRsp = handle.GetManagedObject(None, FaultInst.ClassId())
    >>> WriteObject(getRsp)
    
    Managed Object			:	FaultInst
    --------------
    ChangeSet                       :
    Lc                              :
    Descr                           :ether port 1/3 on fabric interconnect B oper state: sfp-not-present
    LastTransition                  :2013-10-10T01:05:31.935
    Rn                              :None
    Type                            :network
    Severity                        :info
    Dn                              :sys/switch-B/slot-1/switch-ether/port-3/fault-F0279
    Tags                            :network,server
    Cause                           :configuration-applying
    Status                          :None
    Created                         :2013-10-10T01:05:31.935
    Ack                             :no
    Rule                            :port-pio-sfp-not-present
    OrigSeverity                    :info
    PrevSeverity                    :info
    Code                            :F0279
    HighestSeverity                 :info
    Id                              :105452
    Occur                           :1

Thanks for reading, and if you're interested in contributing, leave a comment here, or on my [github project for UCS in Python](https://github.com/Mierdin/pyUCS-Build). Also, if you want to tell Cisco you support their development of this tool, it probably couldn't hurt to send them a line at [ucs-python@cisco.com](mailto:ucs-python@cisco.com) (posted on the SDK site).
