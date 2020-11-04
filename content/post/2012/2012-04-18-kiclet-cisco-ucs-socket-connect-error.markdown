---
layout: post
title: 'KICLet: Cisco UCS Socket Connect Error'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-04-18"
wordpress_id: 2103
slug: kiclet-cisco-ucs-socket-connect-error
tags: ['cisco']
---


I recently observed some strange behavior with Cisco UCS Manager. When I visited the web page that allows me to download the .jnlp file that launches UCSM, it came up just fine. But when I clicked on "Launch UCS Manager" to actually launch this applet, the splash screen showed briefly, but disappeared after a few seconds, never to be seen again.

Eventually, you might also see some java error messages that say something like

    "java.net.MalformedURLException: unknown protocol: socket".

[![](/assets/2012/04/screen5.png)](/assets/2012/04/screen5.png)

The frustrating part of this is that it's a generic Java error message and google's not really my friend on this one. The error message seems to denote some kind of network connectivity problem, but how could that be if I was able to successfully visit the UCSM web page and download the jnlp file?

After some digging, I found the problem. Take a look at the Java control panel:

[![](/assets/2012/04/screen11.png)](/assets/2012/04/screen11.png)Once there, go to "Network Settings":

[![](/assets/2012/04/screen21.png)](/assets/2012/04/screen21.png)

A quick look at the proxy settings indicates that Java is currently looking up the settings of whatever the default browser is on the system.

[![](/assets/2012/04/screen4.png)](/assets/2012/04/screen4.png)

My default browser WAS Chrome, but I recently switched to Firefox because I am using some specific proxy settings in Firefox that allow me to get to the internet. The Cisco UCS I want to connect to is on the LAN, so I don't want to use the proxy to get to it. I've found my culprit: Java was using the Firefox proxy settings to attempt to get to UCS, and I only recently started seeing this behavior because I had only recently designated Firefox as my default browser. Chrome, which was my default browser before, had no proxy settings, so I was able to use UCSM in the past with no problem.

I know that whenever I'm managing UCS for customers, it's most likely not going to be through a proxy. So - I went ahead and checked the "Direct Connection" radio button, effectively causing Java to ignore any and all proxy settings and just go straight to the UCS system:

[![](/assets/2012/04/screen31.png)](/assets/2012/04/screen31.png)

I relaunched the JNLP and everything worked fine. Simple problem, simple fix, but a default setting that will cause problems if - like me - you work in professional services and network conditions change frequently.
