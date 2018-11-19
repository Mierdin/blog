---
layout: post
title: 'Network Automation: Be Bold!'
author: Matt Oswalt
comments: true
categories: ['Network', 'Automation']
date: "2015-09-29"
slug: network-automation-be-bold
tags: ['networking']
---


I've had something on my mind concerning network automation, and I think it's worth mentioning it here.

There's been a lot of talk - [including plenty from myself](https://github.com/Mierdin/nwkauto) - about using tools like Ansible for creating network configuration files; that is, text files that contain configurations for network devices, usually a list of CLI commands. And this is a great first step, certainly if you're new to network automation.

It's really not that hard to generate configurations. You can do it in about five lines of Python, or you can stick with that Excel spreadsheet powered by macros (you know who you are). I challenge anyone to tell me that Ansible is better at generating config templates than Excel. The reality is that it's not - and it's hardly attempting to be.

So, for the sake of making a point, let's say the generation mechanism doesn't matter. Let's concede that this is the wrong optimization to be making. The question becomes - what **is** the right optimization?

I think the bigger problem to address is that of treating our networks like fragile snowflakes. I can't tell you how many times I've logged into a device, and felt like I was blowing dust off of an antique book. The real cause of network fragility is inconsistency. I think if you're new to automation, consider how you can use tools mentioned in this space to solve these "introductory" problems:

- Consistent interface descriptions. They matter. Someone will read them and trust them at some point.
- Rotating device passwords and SNMP community strings.
- Getting a snapshot of network changes over time. Identifying inconsistencies between devices.

I want you to consider the brevity of this list. This is hardly a comprehensive collection of network maintenance tasks, but that is intentional. My point is that network automation isn't about boiling the ocean. It's true - starting small is important so is realizing automation's benefits where it makes sense, early.

It's also worth mentioning that these days, being able to test automation workflows using virtual network devices is at an unprecedented level of availability. Use these tools to gain confidence in your newfound workflows. Don't stop at being able to eyeball a textfile - be proactive with your testing.

# Conclusion

I don't mean to speak ill of network config templates. Indeed in an industry that is still tightly bound to command-line syntax, this is definitely something that should be part of our automation workflow. In fact, it's probably the most crucial part of achieving consistency. However, it's all moot if these changes do not make it into production.

Do not be content with generating text files. Move boldly into network automation without fear. Yes our networks are critical, and you may think that your environment is too small to deal with such things. I say, it's never too early to care about consistency, and about quality. Embracing automation will help you achieve these things, and will help ensure you get home in time for supper.
