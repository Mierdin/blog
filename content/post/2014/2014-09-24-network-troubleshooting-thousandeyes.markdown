---
layout: post
title: Network Troubleshooting with ThousandEyes
author: Matt Oswalt
comments: true
categories: ['Tech', 'Field', 'Day']
date: "2014-09-24"
wordpress_id: 5940
slug: network-troubleshooting-thousandeyes
tags: ['bgp']
---


My first experience with ThousandEyes was a year ago at Network Field Day 6, where they were kind enough to give us a tour of their office, and introduce us to their products. I've been fairly distracted since then, but kept an eye on what other delegates like Bob McCouch were doing with the product since that demo.

A year later, at Network Field Day 8, they presented again. If you've never heard of ThousandEyes, and/or would like an overview, watch Mohit's (CEO) NFD8 introduction:

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/A_j_mC5ehSU" frameborder="0" allowfullscreen></iframe></div>

## Debugging the Internet

One of the things that really stuck out a year ago, and was reinforced tenfold this year, was that ThousandEyes was not introducing any new protocols to the industry - at a time when all of the headlines were talking about new protocols (i.e. OpenFlow). Numerous tech startups - especially those in networking - are in existence purely to tackle the big "software-defined opportunity" gold rush.

Instead, ThousandEyes is focused on network monitoring. If you're like me - you hear those words and immediately conjure up images of all of the.....well, terrible software that exists today to monitor networks. In addition, network monitoring is inherently very fragmented. You can really only monitor what's yours; the internet was founded by connecting autonomous systems together. You can't really monitor the network upstream from you - right? Certainly not to a degree where you can actually found the root cause of problems in an effective way. On top of that, if you're using some kind of overlay VPN solution like MPLS, then things get even stickier.

> For many of us, the solution involves getting on the phone, and calling up our provider's NOC - hoping desperately that they'll be able to address the issue, and that finger pointing will be kept to a minimum.

ThousandEyes was founded out of Ph.D. research on Internet routing diagnostics and security. Of the founding principles Mohit mentioned at the beginning stuck out most for me: "Be creative with protocols and require minimal instrumentation". Without watching the presentation, this phrase may go unnoticed - but please keep this phrase in mind when watching the presentation on active probing. There was tons of good content from these guys at NFD8, but this is by far my favorite section.

The reason I called out that phrase is that the core of both their company and their products is a deep understanding of existing protocols like TCP, IP, ICMP, etc. and how common platforms from Cisco, Juniper, etc. handle these protocols. They use this understanding to take advantage of the incredible troubleshooting data that these protocols provide and most don't even know it. With this data, they can not only discover problems on an enterprise's own network, but also extrapolate details about other, separate networks entirely.

## BGP Path Visualization

Most are aware that there are [BGP servers](http://www.bgp4.as/looking-glasses) connected to the internet that allow someone like myself to take a look at the global BGP table without actually setting up a peering.

Unlike traditional BGP looking glass servers, ThousandEyes offers some cool visualizations (more important than many give credit for), historical event playback. ThousandEyes uses the data collected from their globally-positioned probes to collect data on the BGP table, and changes made to it. This means that if a prefix hijacking occurred, not only could you go back in time and re-play the event, but you'd be able to visualize all of the affected autonomous systems, and correlate this data with other events - like the introduction of routing loops.

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/K9n7-9A7bKk" frameborder="0" allowfullscreen></iframe></div>

I love how they provide a nice summary (left side of the screen) of interesting tidbits about the situation, such as "3 links with a delay of over 100 ms", "2 links with jumbo frames", and "7 links are part of an MPLS tunnel". This serves as a great way to maintain situational awareness when troubleshooting, so you know some important points to focus on with your network, or any upstream network.

Finally - this network monitoring focuses on the applications themselves. Sure, you can troubleshoot BGP relationships, but if only one particular application (which may be hosted on a SaaS provider) is having issues, you'd still have to figure out what path through the internet is being taken for that application. ThousandEyes makes the troubleshooting very app-centric, so you start from there, and all troubleshooting information is pertinent to that application.

## Active Probing

Now - BGP is just one tool. What about the myriad of other protocols that operate on our network?

ThousandEyes knows that the network protocols we have used for years are a valuable data point. Protocols like IP, ICMP, TCP, etc. are constantly operating on our network, and the myriad of behaviors that are built in to all of them are very revealing of how the network is behaving at a given time.

Because these protocols are running everywhere, they can not only be used to troubleshoot issues on your own network, but on other networks you may be connected to - an upstream provider, for instance. ThousandEyes is able to send artisanal, hand-crafted packets upstream into the next network, in order to discover how that network is operating. They call this Active Probing.

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/cT79irzaH9A" frameborder="0" allowfullscreen></iframe></div>

Think of how traceroute works - essentially, our machines send a series of packets to a destination, starting with a TTL value of 1, and incrementing until the destination is reached (or until 255). The responding "ICMP time exceeded" packets allow the source to identify intermediate hops, and display latency information for that hop.

Unfortunately, due to common restrictions (like throttling ICMP, which is common on the internet),  current tools like traceroute are only useful for simple stuff like up/down and very basic troubleshooting. Check out ThousandEyes' blog on the caveats of popular network tools like [traceroute](https://blog.thousandeyes.com/caveats-of-popular-network-tools-traceroute/) and [iperf](https://blog.thousandeyes.com/caveats-of-traditional-network-tools-iperf/).

Because of this, ThousandEyes built their own packet crafting library, so that they can control not only the fields in a given packet or frame, but within the context of a stream. I like to think of it as a combination of scapy and iperf (note also the performance improvements that Ricardo briefly mentions).  With this library, they're able to set specific values in a packet like with scapy, but are able to do this with all packets in a stream. For instance, they're able to emulate a full TCP session, while having full control of how the fields are set.

This library is also able to infer total throughput - probably based on something like TCP windowing. Again, iperf does this, but accomplishes this by having an iperf process at both ends. Using ThousandEyes' tool, no such requirement would exist. It may not be a perfect measurement as a result, but it's pretty close, and it's better than nothing, which is what you'd get in most cases (can't exactly install an iperf server wherever you wish, can you?).

> I mentioned this at the event, but I'll mention it again. ThousandEyes, please consider putting at least a portion of these tools into the open source community. These are incredibly useful tools, and in my opinion is the best way to get your name out - it demonstrates that you guys don't just have a good product, but also have a very deep understanding of existing network technologies and protocols.

## Conclusion

Again, the most bad ass part of all of this, is that they can figure out all this stuff by inference - not having any agreement with the owners of that infrastructure. Just a deep understanding of how protocols work, and exploiting that knowledge to get more data for troubleshooting. It's a recognition that networking isn't just transport - it is an absolutely abundant source of data, just waiting to be mined. And that gets me excited.

Check out a few other blog posts by awesome fellow delegates [Ethan](http://ethancbanks.com/2014/09/18/thousandeyes-network-monitoring-use-cases/) and [Lindsay](http://lkhill.com/thousandeyes-noc-for-the-internet/).

> ThousandEyes was a vendor presenter at [Networking Tech Field Day 8](http://techfieldday.com/event/nfd8/), an event organized [by Gestalt IT](http://techfieldday.com/about/). These events are sponsored by networking vendors who thus indirectly cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter's beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don't ask for, nor are they promised any kind of consideration in the writing of my blog posts ... and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://oswalt.dev/disclaimers/))
