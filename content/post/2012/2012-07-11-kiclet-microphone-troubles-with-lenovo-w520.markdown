---
layout: post
title: 'KIClet: Microphone troubles with Lenovo W520'
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2012-07-11"
wordpress_id: 2228
slug: kiclet-microphone-troubles-with-lenovo-w520
tags: ['audio']
---


I came across this the other day and wanted to share. For some reason, Windows by default decided to enable the "audio enhancements" feature on my new Lenovo Thinkpad w520.

This caused my microphone to essentially be unusable - I was in several webex meetings and each time everyone said I was completely garbled and not even close to being able to understand me. After a little poking around, I found this:

[![](/assets/2012/07/screen.png)](/assets/2012/07/screen.png)

As shown above, go to  audio settings and then to the properties of your microphone, then disable the box that says "Enable audio enhancements".

Your audio will then sound much better. It's possible this feature works well in certain environments, but for me it was completely unusable, and from what other resources on the internet were telling me, it was the same for a lot of other people.
