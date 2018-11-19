---
layout: post
title: '[Storage Flow Control] Part 1- Introduction'
series:
- Storage Flow Control
author: Matt Oswalt
comments: true
categories: ['Storage']
date: "2014-01-17"
wordpress_id: 5312
slug: storage-flow-control-part-1-introduction
tags: ['FCoE']
---


When making the leap to adopting FCoE as a storage medium, there are a few things to consider in order to be successful. Many of these concepts are foreign to the storage administrator who has been operating a native Fibre Channel SAN for the better part of the last decade or more - this is because while Fibre Channel networks are costly, they are purpose-built. There is no concept of a loop in Fibre Channel - with Ethernet we deal with these all the time. It's clear that while Ethernet is a convenient and low-cost medium for networking, there are additional considerations when using it to carry SCSI payloads.

Therefore, there is an apparent need for a mechanism that allows us to ensure the network is suitable for this traffic. FCoE is one thing, but taking a step back, it's true that all storage protocols need some kind of mechanism that allows the client to receive feedback concerning the state of the network, and take action accordingly to protect the data in motion. This concept is called Flow Control - and while it's certainly not specific to storage traffic, it's a very useful example to consider.

## What is Flow Control?

Storage-related traffic - whether SAN or NAS - is usually the result of a client sending some kind of I/O to a remote entity. It's important that the network is able to provide some kind of feedback back to the client to let it know when it should slow down. Perhaps there's contention on a link - in which case it would be wise to slow down the flow of data to prevent loss. This is Flow Control, and every storage protocol uses this in some way.

IP Storage is easy. Every wonder why all network-attached storage protocols run over TCP? This isn't just for reliability - though that's a big part of it. Another big reason is because TCP windowing already does this for any encapsulated traffic. If the TCP stack of the host begins to see that some of the segments being sent are not being acknowledged properly, it retries the transmission, but demands acknowledgements more often. This results in smaller, "bite-sized" chunks of data to ensure that everything gets through. In time, the window will slide open and closed until it arrives at a reasonable value for the current network conditions.

Native Fibre Channel works a little differently - through a concept known as buffer credits. These credits are used to determine how many frames to send in a certain period of time. When the receiver is ready to receive more frames, it sends a message indicating this is the case, essentially refilling these credits for use. This concept is provided by the FC-2 layer - which is roughly equivalent to the OSI Transport Layer - which is where we're used to seeing TCP and UDP. So this makes a lot of sense.

And finally, we arrive at FCoE - which is a little different than the first two examples. It runs over Ethernet, like IP storage does, but it's not IP storage....because it doesn't run over IP. Without this, we can't have TCP, which means we can't use TCP windowing for flow control....so what do we use? This is where Priority Flow Control comes in.

## What PFC **Isn't**

Priority Flow Control is NOT the same thing as Priority Queue. When learning the ins and outs of FCoE, I struggled with this concept until someone explained it to me this way:

PFC, as we'll soon see, is a way for network devices to inform peers that there is congestion. Priority Queue, on the other hand takes place in the queues on switch when there is congestion - it's a way of identifying a certain type of traffic that should get prioritized to pass through a switchport before any other queue is serviced. This concept is core to understanding QoS in general.

## What is PFC?

The "flow control" portion of PFC is actually somewhat similar to native FC's use of "buffer credits", except that it works in the exact opposite way. Where FC uses buffer credits to signal when the network is ready to accept additional traffic, PFC works by sending signals to the network that congestion is taking place and that it wishes the traffic to slow down.

This is accomplished through Ethernet "pause" frames - a type of message sent to the reserved multicast address of 01:80:C2:00:00:01. These frames essentially instruct the sending device to wait to send any more data. This frame can also specify the length of time it wishes the other end of a link to wait.

The biggest drawback to this is that it really defeats the purpose for traffic on this link that is intended to be given priority - a pause frame, if honored globally simply pauses all traffic, regardless of perceived priority. So, priority Flow Control modifies this idea a little bit by allowing the pause frame to define the pause behavior on each Class of Service. This idea came to be in the IEEE standard [802.1qbb](http://blog.ipspace.net/2010/09/introduction-to-8021qbb-priority-flow.html) (not a link to the standard, but rather to an excellent writeup by Ivan Pepelnjak).

##  Conclusion

I enjoyed learning about these various mechanisms because it further illustrates the symmetry between otherwise wildly different technologies. Fibre Channel and Ethernet/IP were invented under different operating environments, and for totally different reasons, yet there are common building blocks. Another reason why I'm do networking for a living.

I will continue this post with a Part 2 that covers a specific implementation of PFC and how to troubleshoot when things go wrong.
