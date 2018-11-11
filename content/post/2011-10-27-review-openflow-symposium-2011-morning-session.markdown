---
layout: post
title: OpenFlow Symposium 2011 - Morning Session
author: Matt Oswalt
comments: true
categories: ['Tech', 'Field', 'Day']
date: "2011-10-27"
wordpress_id: 1689
slug: review-openflow-symposium-2011-morning-session
tags: ['nfd']
---


[![](assets/2011/10/41-300x168.png)](assets/2011/10/41.png)

I was able to watch a good chunk of the morning session of the OpenFlow Symposium in San Jose. The stream was having issues at the beginning of the afternoon session, plus I was pulled away for other issues, so I was only able to watch the morning session. I'd like to provide a bit of a write-up from what I was able to catch, and point out some of the highlights that I took interest in from the day's speakers.

For those that haven't heard - OpenFlow is the newest iteration of Software Defined Networking, which abstracts the control plane from the forwarding plane in networks. This allows you to centralize the controlling device, and with OpenFlow as an open protocol that defines the communication between the two, you can begin to actually program your network behavior as it pertains to the controller imposing logic on the forwarding devices.

Greg mentioned that Juniper recently announced support for OpenFlow in JunOS, which provided some really good perspective for the beginning of the symposium. Many of the struggles thus far with some of the smaller shops is the use case and when/where it makes sense to use OpenFlow. Where does OpenFlow position itself as a business strategy? What are some of the use cases for OpenFlow?

Igor from Yahoo started the day's talk to try to answer some of these questions. I thought he provided some decent perspective into what OpenFlow is from a layman's perspective. He analogized OpenFlow as like an x86 instruction set for networks. He pointed out that many of today's networks run on protocols that are the equivalent of Excel Macros. If you were tasked with rewriting Apache web server, you wouldn't use Excel macros, you would use something like c++. OpenFlow is like that - it doesn't do anything really that new per se, but you are able to control flows more easily because of that open and centralized control point. In addition to this, he also pointed out that because of the separation of control plane and the forwarding plane, you are able to "mix-and-match" and purchase each component from different vendors, if necessary.

His other big point was that the complexity of communication flows has increased exponentially - there is now more cross-talk and east to west communication than ever. Virtualization is certainly one of the biggest reasons for this. Often, routers spend 30% or more cpu cycles doing topology discovery. If you can get all this information into a central database, you can use SDN to program this stuff. SDN is about faster, cheaper, better.

Ed from Google let us in on the fact that Google is heavily invested in OpenFlow research (but would not indicate if Google was using it in production in any way) and thinks it is something that will have severe impact on Google's future in the next 2-5 years. From a cost perspective, SDN allows you to make efficient use of network resources. SDN centralizes resource management, making it easier to get a global view of your network. It's also a means by which to keep track of state more effectively.

During the question and answer section, I was able to gather a few additional points. OpenFlow has potential for companies with a big killer app - they write their own software, and they know how it works. They can create OpenFlow networks that cater EXACTLY to the needs of that application if needed.

Anywhere you have a dense topology, there's a savings opportunity with openflow because you're ripping the control plane out and simplifying these clusters.

Yahoo is aiming to have that centralized management - they're really excited about that more than anything. They want to control everything in one place, and they want to know exactly how it works. They can control forwarding, control code-behind, and control state, all from one place.

The large portion of the morning session after that was taken up by vendors speaking about their thoughts on OpenFlow and their implementations of it. Here are my condensed thoughts after listening to them:

* Cloud computing is going to be a massive use case for SDN. One vendor pointed out that virtualization has increased trouble tickets for many organizations by 300% - 600% because the network has failed to address the problems virtualization brings to the table. SDN will allow the engineer to allocate and move resources dynamically, and on-demand, without being constrained by existing constraints like VLANs. As such, the statement was made that "openflow is like vmware, but for networking". That statement was a bit much, but taken out of the context that a vendor was saying it, it helps get the point across about what OpenFlow is supposed to accomplish. The point is that SDN is a logical next-step for virtualized environments.

* A vendor began to point out, but then Ivan from IOSHints simplified this next point - the SDN concept really belongs in a three-tier model. First, the forwarding tier does what forwarding planes do - forward traffic. They receive directions from the Controller Tier, which is really just a set of instructions or functions for network flow control, and finally the Application Tier on top which uses the instruction sets from the Controller Tier to control network traffic in an application-specific way.

* Finally, there's been a lot of debate over OpenFlow specifically regarding the hype that suggests that OpenFlow is something that will change the way we do networking. Many of the people in the room were smart enough to know this wasn't really the case, but still a vendor pointed out that OpenFlow does change the game in some ways. For the programmer, it absolutely does change things - with OpenFlow you can program your network just like you can your killer app, making the two one and the same. For the network engineer that does some coding, it might bring some new functionality. For the switch developer, not so much.

## Matt's Mind

I thought the morning session was good - there was a ton of lively discussion and really put OpenFlow (and SDN in general) in perspective. I think it's important to think of OpenFlow in the right context, understanding that it's just a new way to do the same thing, not a new way to do a new thing. Even though, it's a powerful tool for those that can take advantage of it, and it was valuable to see companies like Google and Yahoo getting behind it, in addition to the vendors that actually have their own product that they were pushing.

I'm really excited to see more of the afternoon session - the stream was offline for a portion of it, and I got called away to another issue by the time it came back up, so I missed it.  Perhaps I'll do another post after I see it.

EDIT: See some of the videos of the morning session [here](http://techfieldday.com/2011/yahoo-google-openflow-technology/):

[Page containing all vendor presentations](http://techfieldday.com/2011/openflow-presentations-bigswitch-brocade-cisco-nec-juniper/)
