---
layout: post
title: Next-Generation Network Telemetry
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2016-03-30"
slug: next-generation-network-telemetry
tags: ['monitoring']
---


Late last year, I was pleased to be part of a [special Tech Field Day event](http://techfieldday.com/event/dfdr1/) focused on network analytics. We had a day full of presentations from folks like Netflix, Google, and [some goofball with a wrinkly jacket](http://techfieldday.com/appearance/open-discussion-on-infrastructure-management/) - all focused on what the next-generation networks will look like with respect to analytics.

This was a while ago, but I've wanted to write about this ever since, and a recent conversation gave me the spark I needed.

# Microservices

First, I want to mention that  - in no small part due to the Netflix presentation - this was one of the first times I've heard microservices brought up in a network tooling context. Sure, microservices are all the rage and we've definitely seen a lot of activity regarding how to bring our networks up to the level required by these new application architectures. However, starting with this event, I've also started to notice a tremendous value in approaching the network software itself with a microservices architecture, instead of the monolithic network monitoring/management software we use today.

More on that in a future post.

# Out With The "Pull", In With the "Stream"

If you haven't watched any of the videos from the DFDR1 event, I recommend that you do, but before you do that, check out [this Software Gone Wild podcast](http://blog.ipspace.net/2015/05/network-monitoring-in-sdn-era-on.html#more), wherein Ivan Pepelnjak talks with Terry Slattery, Chris Young, and me about network monitoring in the new age. I think this podcast does a really good job of stating the problems that exist with network monitoring today, and it would be a good listen before diving into the [DFDR1 videos](https://www.youtube.com/playlist?list=PLinuRwpnsHadcSz4jqt5p0_dUZhRRGqVg).

One of the big changes coming to network monitoring is a complete pivot on how we obtain metrics. In some cases, this is due to scale of the network, but in other cases it is a simple matter of consistency. The network management model in use today is very tightly coupled to the platforms that we're monitoring, and we have to be very particular with the products we choose to use for this purpose.

I believe network monitoring is changing in a few ways. Like anything else, this isn't going to happen overnight, but it's worth being aware of these changes, and the value they bring to the table:

- **Push Model, not Pull** - Network devices stream telemetry data to a collector instead of require that they be polled. Think "netflow" but for everything, and again, not so tightly coupled to the platform.
- **Loosely Coupled** - Streaming network telemetry of tomorrow will not require an IETF standard in order to be useful. A standard format like JSON will be used, and it's up to the collector to interpret the data. This allows network operations to quickly evolve their network perspective.

# Streaming Telemetry

I see a few technologies as driving this new "push" model forward. One of the presentations at DFDR1 was from Google, and Anees spoke about a few things they're doing in this space. One of those things is [grpc](http://www.grpc.io/). A hyper-simplified way of looking at GRPC might be "RPC over HTTP2". This is a powerful idea nonetheless, as with this, we gain a lot of the functionality built into HTTP2, like the streaming functionality. In traditional RPC over HTTP1, large datasets were really hard to deal with (read: impossible in many cases).

The idea of being able to subscribe to a GRPC "service" provided by a network device is very attractive to me. It's not as unreliable as the "pull" model that we're accustomed to, but it's also not necessarily a "here's a firehose, good luck drinking it all" either.

There's another project that I've had my eye on for some time as well. Intel's "Software Defined Infrastructure" (SDI) team has been hard at work with their ["snap"](https://github.com/intelsdi-x/snap) project that they open sourced late last year. Snap provides a way to gather telemetry from various points around your infrastructure, and it seems to be highly extensible (which is one of the big things I look for in a project).

# Loosely Coupled

Those that know me well know that I subscribe to the Unix Philosophy, or at least most of it's "rules". There's a lot that the networking industry can learn from this mindset. The "rule of modularity" states that we should build simple components connected by clean interfaces. This tends to conflict with the "norm" in network monitoring, where you mostly have to buy in to one monolithic products that doesn't really allow for much flexibility or extensibility. In particular, the collection of telemetry, and the display of that telemetry occurs in the same black box, and as a result, we're bound to how that data is leveraged within this black box.

This concept was addressed in the Netflix presentation at about 40:30 in the video below:

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/cd-5ADtsTK4" frameborder="0" allowfullscreen></iframe></div>

At this point in the video, Matt brought up a interesting comparison between the tools Cacti and Graphite - as an analogy of how the representation of telemetry data has changed. With a tool like cacti, you have to predetermine what you want to collect, and you have to be specific about it. With graphite, you don't - you sort of just spew metrics at it, and you can then use them, or choose not to. This is a total disaggregation of the **collection** of the data from the **representation** of that data, enabled by some kind of generic, clean interface.

By the way, [I'm taking the same approach with ToDD](https://oswalt.dev/2016/03/test-driven-network-automation/)! In the current version, the ToDD server will publish test metrics to a TSDB like InfluxDB, and I can then choose what query to write in Grafana to take advantage of that raw data in any way that I want. I can generate a handful of totally different graphs from the same dataset. I may even use something other than Grafana!

<div style="text-align:center;"><a href="/assets/2016/03/grafana.png"><img src="/assets/2016/03/grafana.png" width="900" ></a></div>

Matt's presentation sums it up nicely, as he describes the approach that Atlas takes: "You can throw any data at us you want as long as it's in the right format".

# Conclusion

The Netflix presentation is a good (albeit fairly extreme) example of what's possible when you invest in your own telemetry platforms. They totally own the roadmap for this platform, and on top of that, they've built clean interfaces into it so as to not make other Netflix developers hate their jobs.

It's also very important to not discard the entire Netflix presentation with thoughts of "I am not Netflix therefore none of this applies to me". Though the scale of what Netflix has done is impressive from a "geek cred" perspective, there's still a lot here than may be more applicable to smaller organizations in the next 5 years. Do not fall into the trap of thinking that the value of an open telemetry system can only be valuable to the top 5 networks.

> I attended Data Field Day Roundtable 1 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://oswalt.dev/disclaimers/))
