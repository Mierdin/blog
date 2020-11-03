---
layout: post
title: Plexxi - Optimized Workload and Workflow
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-10-28"
wordpress_id: 4824
slug: plexxi-optimized-workload-and-workflow
tags: ['affinity']
---


Plexxi was a vendor that presented at [Networking Field Day 6](http://techfieldday.com/appearance/plexxi-presents-at-networking-field-day-6/), and was one that really got me excited about what's possible when you think about what kind of metadata your data center contains, and what products like Plexxi can do with that data once abstracted and normalized the right way.

I will be intentionally brief with respect to my thoughts on the hardware - others like [Ivan](http://blog.ipspace.net/2013/09/plexxi-psi-mau-at-gigabit-speed.html) (and more) have already done a better job with this than I ever will. Many of the technical details regarding Plexxi's optical solution were discussed both in the video I'll embed below, but also in their prior appearance at [Network Field Day 5](http://techfieldday.com/appearance/plexxi-presents-at-networking-field-day-5/).

## New Hardware: Workload

Plexxi made a few hardware announcements at NFD6, specifically showcasing the new switching and optical products that would be joining their portfolio this year.

As with before, we're talking about photonic and electronic switching baked into the same chassis, where the specific path chosen by the optical backbone is completely programmable via the Plexxi controller. This is all made possible by the [lightrail interfaces](http://www.plexxi.com/2013/09/plexxi-paths-and-topologies-part-1-let-there-be-light), which allow for quite a few optical paths between neighboring switches, and doesn't mean that a physical connection must be with adjacent switches.

The Plexxi controller computes the most efficient optical topology based on application needs. Layer 1 SDN. The control plane is hierarchical, meaning there's a distributed controller module on each switch that operates when disconnected from the centralized Plexxi Control cluster. The local controller is able to fail over even if the controller is disconnected.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/yUrWo_WIZ1M" frameborder="0" allowfullscreen></iframe></div>

### Plexxi PSI: Pod Switch Interconnect

Plexxi introduced the PSI to provide more of a hub and spoke topology, as opposed to the physical ring topology they introduced earlier. The idea is to still implement the same kind of topology that allows you to do photonic switching, producing programmable L1 topologies, but in the hub-and-spoke model.

[![diagram5](/assets/2013/10/diagram5.png)](/assets/2013/10/diagram5.png)

A compelling use case for using the PSI is, for example, big scale-out deployments, or any data center where repeatable, consistent growth is observed in a pod-like format. Each PSI can connect up to six  top-of-rack switches, and then the optical spine on the PSIs is able to form the ring topology we saw earlier. This occurs over the extender ports on each PSI, separate from the LightRail interfaces meant to go to ToR switches.

So, a single pod would consist of 1-2 PSIs, and up to 6 top-of-rack switches. Repeat as necessary, connecting each pod into the ring of PSIs that becomes your DC network.

By the way, the PSI is totally passive, so the idea of redundancy is a little less important. They made the argument that no one has redundant patch panels. The PSI is basically just a bunch of cables. Photonic switching doesn't even occur within the box.

### Switch 2SP

The 2SP is a dense access-layer switch (16x QSFP and 8x SFP+)

[![diagram6](/assets/2013/10/diagram6.png)](/assets/2013/10/diagram6.png)

I found the concept of Flexxports quite interesting - there are four of these per switch (SFP+) - these allow direct layer 1 native access to the lightrail interfaces for a server-side connected device, bypassing the switching ASIC entirely. This is for things like FC or Infiniband where you just need some direct L1 connectivity for something that is non-ethernet. Setting the connection up between Flexxport and Lightrail strand is programmable, not fixed - which is pretty cool.

The LightRail interfaces, each carrying 12x10GbE, provide uplinks to either other switches or to the PSIs mentioned above. Essentially, this gives you 240Gbps of total uplink bandwidth per 2SP.

## The SDN Unicorn: WorkFlow

Plexxi makes the argument that DevOps is about enhancing your workflow, which is about building context and metadata dynamically - not through inspecting the packets on the network, but by proactively integrating with the applications using the network and using data gathered from them.

Plexxi's view is that DevOps has not completed its goal in the network until the requirements of an application, and the intricate relationships between the components of an application is imprinted on the network fabric. They're not happy leaving DevOps at the current standard of automating the existing model. They're changing the model so that it's built from the ground up to be operationalized (workload) then building on top of that a metadata engine that takes advantage of such a foundation (workflow).

In the second half of their presentation, the Plexxi team talks about their work towards this effort, specifically focusing on the Data Services Engine that they're on the verge of releasing to the world. The DSE is aimed at providing normalization for the gratuitous amounts of metadata present is all aspects of data center infrastructure.

[![diagram4](/assets/2013/10/diagram4.png)](/assets/2013/10/diagram4.png)

This normalization is actually the most difficult part when considering DC-wide orchestration, because everyone does it differently. Working with APIs is easy. Populating them with relevant data cross-platform is the difficult part.

Check out what they're doing with this, mixed in with good-old [CloudToad ](https://twitter.com/cloudtoad)humor.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/-2DO_R_MRok" frameborder="0" allowfullscreen></iframe></div>

### Plexxi DSE

The DSE software that Plexxi is developing is aimed at providing a normalization engine for the metadata in your DC infrastructure, whether it's servers, networking, hypervisor, storage, etc. With DSE you can have various channels that are designed to take data from important sources like VMware and OpenStack, and provide a sort of "translation service" so that integrating these services with the other infrastructure in your DC is less painful.

[![diagram2](/assets/2013/10/diagram21.png)](/assets/2013/10/diagram21.png)

As Derick points out, Orchestration is a data integration problem first and foremost. How do I access that data, how do I get it in a usable format, and how do I know when that data has changed?

Think about finding a devices based only on IP address. You have to look at the ARP table, then MAC address table, then follow down the line.  With DSE, you can put in the IP address, and it tells you everything it knows about that IP address. Think of what you get out of a CMDB when you assign a device and everything about it a unique ID. These kind of relational database concepts can be moved into the network, where we can use any piece of identifying data like an IP address, mac address....anything - and find out everything that is related to. Pretty cool.

The Plexxi DSE answers the problem that infrastructure metadata, especially in the data center, is kind of a cluster right now. Each service, tools, or product in your datacenter is able to offer some kind of data about the infrastructure or software it manages, but the data provided, as well as the format of the data (YAML, JSON, XML, etc.) vary quite greatly.

DSE doesn't even have to be used for networking - it stands completely on it's own. This is freaking awesome, considering that they're open-sourcing this. You can bet that I'll be playing with this a lot once I can get my hands on it.

### OpenDaylight and Plexxi

Plexxi's most prominent idea is their concept of "application affinities". Affinities are a way of describing an application, which from a network perspective is really all of the methods by which various pockets and services that make up an application communicate with each other. An "affinity link" is a way to provide policies to the network that allow applications to talk to one another. In this way, you abstract the details concerning network connectivity, and provide consumable policies that are already written in "application lingo". So, rather than state "10.1.1.1 can talk to 10.1.1.2 on tcp port 80", we can say "our web tier is consumed by our application tier using JSON over HTTP". The network-specific nerd knobs are still there, just abstracted.

Rather than simply force customers to purchase their hardware to see what this is all about, Plexxi pushed this "affinity API" code[ into the OpenDaylight project](https://wiki.opendaylight.org/view/Project_Proposals:Affinity_Metadata_Service). Go ahead and pull down the code and take a look.

[![ODPAffinity](/assets/2013/10/ODPAffinity.png)](/assets/2013/10/ODPAffinity.png)
    
    git clone https://git.opendaylight.org/gerrit/p/affinity.git
    cd affinity
    mvn clean install

Then follow the [usual process for ODL](https://wiki.opendaylight.org/view/OpenDaylight_Controller:Pulling,_Hacking,_and_Pushing_the_Code_from_the_CLI) to get it imported into Eclipse.

I poked around a little bit and plan to a little more later, but the first thing that struck me is that this isn't just another southbound API. Not that all of the other vendors are just making southbound API modules for ODL, but Plexxi is doing something pretty cool here by contributing to a part of ODL that serves as the basis for how SDN logic is processed. Using the Affinity API that Plexxi contributed, we now have enhancements to the ODL northbound API that allows the ODL controller to make use of the idea of affinities - respecting the relationships that applications have between their various parts, and configuring the network accordingly. The southbound APIs remain unaffected - you can use whatever language you want there.

For instance when used with ODL, the concept of affinities could, in theory, be transposed onto an OpenFlow-based hypervisor and VXLAN-based physical network, essentially recreating what folks like VMware are doing with NSX, but with Plexxi's affinity constructs.

I have massive amounts of respect for this approach. Plexxi is doing here what most other vendors are either not doing or are hesitant to do - they push code that represents their company's vision for networking, make it so that it works with the current model, then offer the hardware solution based on photonic switching that complements these ideas. This is the case both with their DSE, and the Affinity API. Though I'm sure Plexxi would argue it works best on their hardware, you don't have to purchase to see for yourself.

Derick puts it best: "It's not enough to say we have an API, we have to do something about that."

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Go ahead. Tell me you have an API. <a href="http://t.co/O1ZIE3miqU">pic.twitter.com/O1ZIE3miqU</a></p>&mdash; Derick Winkworth (@cloudtoad) <a href="https://twitter.com/cloudtoad/status/378264787672514560">September 12, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

If the idea takes off, then people are going to start looking at Plexxi's hardware as a foundation to that logic inside ODL or elsewhere. They're not pushing whitepapers - they're pushing code. Now.

[![tumblr_inline_mfd3t0Vl061qiv5yk](/assets/2013/10/tumblr_inline_mfd3t0Vl061qiv5yk.gif)](/assets/2013/10/tumblr_inline_mfd3t0Vl061qiv5yk.gif)

> Plexxi was a vendor presenter at [Networking Tech Field Day 6](http://techfieldday.com/event/nfd6/), an event organized [by Gestalt IT](http://techfieldday.com/about/). These events are sponsored by networking vendors who thus indirectly cover our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter's beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don't ask for, nor are they promised any kind of consideration in the writing of my blog posts ... and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://oswalt.dev/disclaimers/))
