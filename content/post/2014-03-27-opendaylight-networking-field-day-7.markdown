---
layout: post
title: OpenDaylight at Networking Field Day 7
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2014-03-27"
wordpress_id: 5783
slug: opendaylight-networking-field-day-7
tags: ['brocade']
---


[Networking Field Day 7](http://techfieldday.com/event/nfd7/) was the third [Tech Field Day](http://techfieldday.com) event I attended as a delegate, and as expected, it was a blast. Its always good to be reunited with old friends, especially in this kind of environment, where constant technical discussions are.......well, they're just going to happen. There were certainly some common undertones in every single presentation. One big example is OpenDaylight - nearly every vendor had at least something to say about it. I'd like to call out the two vendors that went out of their way to discuss OpenDaylight in detail.

## Plexxi

I've [written about Plexxi before](https://keepingitclassless.net/2013/10/plexxi-optimized-workload-and-workflow/), specifically regarding their planned contribution to OpenDaylight. I was very glad to briefly touch base with Nils Swart at the [OpenDaylight Summit](http://events.linuxfoundation.org/events/opendaylight-summit) in February, and very psyched to see that he was going to recap Plexxi's involvement in the project at NFD7:

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/bKGU7tYZV38" frameborder="0" allowfullscreen></iframe></div>

Plexxi's contribution is officially called the "Affinity Metadata Service" project. Developers can access information on this project as well as access source code on the [wiki page](https://wiki.opendaylight.org/view/Affinity_Metadata_Service:Release_Review). As Nils puts it, it allows you to represent a Plexxi infrastructure inside an OpenDaylight environment. It should be pointed out that this is within the controller tier itself, meaning that this can be done on top of non-Plexxi hardware (though I believe they also make available a southbound project that utilizes their Plexxi Control APIs).

The end-goal here is outlined by Nils - OpenDaylight can become the common configuration element for Plexxi customers that  have Plexxi infrastructure, but also wish to extend this policy framework into an OpenFlow-capable vSwitch, such as OVS.

[![plexxi](assets/2014/03/plexxi-1024x531.png)](assets/2014/03/plexxi.png)

This is not to say that this policy framework couldn't be used entirely using OpenFlow networks, but I'm sure Plexxi would make the argument that on the physical side, their gear does a better job. In a non-Plexxi data center, I imagine the common idea would be to leverage the Affinity service to map OpenFlow rules into the virtual switches, but rely on overlays and traditional L3 ECMP to get the job done on the physical side.

Derick Winkworth also demonstrated an integration between the Plexxi Data Services Engine and OpenDaylight. Every network service consumes information in a different way, and he used the creation of a network tap to illustrate this between OpenDaylight and Plexxi Control.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/2vrX_67ovoQ" frameborder="0" allowfullscreen></iframe></div>

This was a pretty light example but if you think about it, there could be quite a few use cases for normalizing metadata in this way.

## Brocade

I also ran into Dave Meyer at the OpenDaylight Summit in February. I've been fortunate enough to run into him at various events in the past, and it's always a pleasure to chat with him about what he's working on. He's very heavily involved with OpenDaylight and definitely grabbed our attention early in the morning before I even finished my coffee (knowing how my brain works before coffee, the man is a miracle worker).

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/K5mgGYkaNDA" frameborder="0" allowfullscreen></iframe></div>

I love that Dave spent a lot of time talking about the non-technical aspects of the industry. The power of the community in projects like ODL is an extremely powerful group of folks.

Another great point that Dave made was the idea that "how" we build things is more important than what we're building. The real value comes from the culture of our organizations, and the people involved. Tackling a problem from not only multiple perspectives but multiple separate disciplines is key. This hits a chord with me, as I spend a lot of my time bridging the gap between various IT siloes within my own company as well as customers I work with.

I encourage you to check out the [project proposals page](https://wiki.opendaylight.org/view/Project_Proposals:Application_Policy_Plugin) on the ODL wiki to see what's coming down the pipeline (OpenFlow pun?). Of the list that's there today, I'm keeping a focused eye on the "Application Policy Plugin", which seems to be a representation of the policy model that Cisco and Plexxi are using in their ACI and Affinity products, respectively.

In summary, I loved the emphasis on community, and the push for open source - not necessarily as an end-all to every problem, but at the very least our best bet for moving forward and becoming the new standards body for the networks of tomorrow.

## Conclusion

As I mentioned before, OpenDaylight was brought up in nearly every presentation in some form or fashion. Other vendors didn't talk about it as much as Brocade or Plexxi, but it was all on our minds, so inevitably it came up in conversation both on and off camera.

I think the next NFD (or two) will see a few more releases of OpenDaylight, and we'll see how the various vendors react. Though OpenDaylight was discussed at nearly every vendor at some point, only two really made an effort to demonstrate their involvement in a big way. I'm hoping to see more demonstrations of ODL work at future NFDs, and perhaps other Tech Field Day events.

> Plexxi was a vendor presenter at [Networking Tech Field Day 7](http://techfieldday.com/event/nfd7/), an event organized [by Gestalt IT](http://techfieldday.com/about/). These events are sponsored by networking vendors who thus indirectly cover our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
