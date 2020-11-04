---
layout: post
title: Cisco UCS Error - "Process Failed"
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-01-18"
wordpress_id: 5344
slug: cisco-ucs-error-process-failed
tags: ['cisco']
---


One of the (sadly numerous) issues I've run into while upgrading to Cisco UCSM version 2.2(1b) is this little error message indicating that a service failed to start:

[![httpd_cimc](/assets/2014/01/httpd_cimc.png)](/assets/2014/01/httpd_cimc.png)

This gives us an error code of F0867 and it's letting us know that the UCSM process httpd_cimc.sh failed on one of our Fabric Interconnects.

For those that don't know, you can get a list of processes within UCSM by connecting to local management and running "show pmon state".
    
    DCB6296FAB-A# connect local-mgmt
    DCB6296FAB-A(local-mgmt)# show pmon state 
    
    SERVICE NAME             STATE     RETRY(MAX)    EXITCODE    SIGNAL    CORE
    ------------             -----     ----------    --------    ------    ----
    svc_sam_controller     running           0(4)           0         0      no 
    svc_sam_dme            running           0(4)           0         0      no 
    svc_sam_dcosAG         running           0(4)           0         0      no 
    svc_sam_bladeAG        running           0(4)           0         0      no 
    svc_sam_portAG         running           0(4)           0         0      no 
    svc_sam_statsAG        running           0(4)           0         0      no 
    svc_sam_hostagentAG    running           0(4)           0         0      no 
    svc_sam_nicAG          running           0(4)           0         0      no 
    svc_sam_licenseAG      running           0(4)           0         0      no 
    svc_sam_extvmmAG       running           0(4)           0         0      no 
    httpd.sh               running           0(4)           0         0      no 
    httpd_cimc.sh           failed           5(4)           0         0      no 
    svc_sam_sessionmgrAG   running           0(4)           0         0      no 
    svc_sam_pamProxy       running           0(4)           0         0      no 
    sfcbd                  running           0(4)           0         0      no 
    dhcpd                  running           0(4)           0         0      no 
    sam_core_mon           running           0(4)           0         0      no 
    svc_sam_rsdAG          running           0(4)           0         0      no 
    svc_sam_svcmonAG       running           0(4)           0         0      no

As you can see, this process is indeed failed. Now - the [UCS fault reference](http://www.cisco.com/en/US/docs/unified_computing/ucs/ts/faults/reference/2.0/UCS_SEMs.html#wp1385890) will tell you that if this happens, regardless of which process it happens to be, you should generate a show-tech UCSM and call TAC. I have to agree with this, because usually it's not a good idea to take any action to fix this yourself.

However - since this happened to me within a TAC call, I learned that this particular process is actually new in UCSM 2.2 - you now have the ability to use a web browser (HTTP) to go directly to a blade's IP address in order to launch the KVM window.

[![kvmdirect](/assets/2014/01/kvmdirect.png)](/assets/2014/01/kvmdirect.png)

The process "httpd_CIMC.sh" is the process that allows UCSM to manage these connections. The reason this process wasn't starting was because I hadn't upgraded my Fabric Interconnects firmware yet - only the UCSM application itself. UCSM wasn't able to find the proper binaries to run this process because they didn't exist. So, finishing the upgrade and rebooting the FIs took care of this for me.

Always err on the side of caution, however. Always follow upgrade guides to the letter, and if you're in doubt as to what these processes do, get on the support forums or call TAC.
