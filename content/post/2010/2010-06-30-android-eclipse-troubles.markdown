---
layout: post
title: Android & Eclipse Troubles
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2010-06-30"
wordpress_id: 184
slug: android-eclipse-troubles
tags: ['eclipse']
---


Setting up a new Android Development Environment in Eclipse? Having troubles? Maybe one of these two solutions will help:

# PROBLEM #1

I recently re-imaged my PC and decided to build my Android Development Environment from scratch. Some recent modifications to my eclipse installation messed it up so I cut my losses and started over again.

This time around, I noticed that Eclipse Helios was available for download, and not only that, it was the first version of Eclipse to offer a 64-bit version of the IDE for windows. Since that fits my machine specs, I opted for that.

I had already installed JRE/JDK, so that was out of the way. However, when I attempted to launch the newly installed Eclipse IDE, I got slammed with this:

A Java runtime Environment(JRE) or Java Development Kit(JDK) must be available in order to tun Eclipse. No Java virtual machine was found.

Umm......what? I know I have java installed, so what gives? 

Here's the part where I could go through all the troubleshooting, smoking, and cursing required to solve the problem. How agonizing it is to have a seemingly reliable program tell you something that you know for a FACT is not true. Read on for the story's ending...

# SOLUTION #1

Like I said, I tried a lot of ideas to fix this....a lot of articles online say to add the java dir to your path variable, or to create a JAVA_HOME variable and add the path there, etc. While these ideas are valid, they didn't solve my problem. The reason was quite simple once I figured it out.

The version of Eclipse Helios I downloaded was initially a 64-bit version, but the JRE installed was 32. When I decided to try wiping everything and start over, I downloaded the default JDK/JRE bundle from Sun's site (which was 64 when I came to the site). Without thinking about the potential problems, when I went to download Eclipse, I figured the new version (Helios) was to blame. Since I've been using Ganymede for years, some of which for Android Development, I went with that, but if you remember, anything pre-Helios was 32-bit only (at least for Windows).

> Seeing a pattern? I unintentionally mixed architecture types for most combinations I was trying.

So here's the trick.....just stay away from 64-bit for now, for both the JRE/JDK and Eclipse. Use a 32-bit version of the JRE, with a 32-bit version of Eclipse. I have tried looking briefly in regards to whether or not Google recognizes this publicly as an issue, but based upon my experience the last few days, you're not losing anything by going 32-bit, and if you do, it actually works like it should. I post this in the hopes that it won't cause you the amount of pain it caused me, because frankly the issue is pretty simple, and almost obvious, now that I know what caused it. The problem was that Eclipse's error message didn't accurately describe the problem. Who knows, maybe in future Eclipse versions, it will detect this mismatch and prompt the user accordingly.

Finally, I say this last because I don't know if this is my fault or not, merely an observation: Just use Ganymede. For some reason, there was some wierdness installing the ADT plugin in any other version, and Ganymede worked for me. Just a thought.

# PROBLEM #2

This will be shorter. Sometimes, especially if you have several different hard disks in your  machine, and many do nowadays, you store your media/games/documents on a separate drive  from your system drive. This allows for easy logical separation of data.

If this is the case, and you try to run a new Android virtual device in  the SDK and AVD manager, you may get hit with this:

    emulator: ERROR: unknown virtual device name: '<device name>' emulator: could not find virtual device named '<device name>'

Obviously this is aggravating because it's in the list of virtual devices, so when you click start, it should at least be able to find it, right? Well....having multiple drives means information is scattered, and the device isn't really where the AVD/SDK Manager thinks it is.

# SOLUTION #2

Create a symbolic link! For those that aren't familiar with the term, think of it as a shortcut that your computer recognizes. The "mklink" command will allow you to turn a location on a hard drive into a shortcut that points to something completely different.[ The article here provides a more than descriptive walkthrough of solving this problem.](http://techtraveller.blogspot.com/2009/07/android-fixed-unknown-virtual-device.html)

Hopefully these gave you something to work with when troubleshooting your freshly installed Android Development Environment. Feel free to comment below if you experience anything else that prevents you from getting to the devving! :)
