---
layout: post
title: The "D" in SDN
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2013-02-12"
wordpress_id: 2934
slug: the-d-in-sdn
tags: ['cisco']
---


I have seen the conversation around SDN evolve over what amounts to the last few years from something that was barely whiteboard material, to something on everyone's lips in this industry. Why? What's so interesting about these three little letters? Well, if you've heard of it, you've undoubtedly heard from your local vendor account manager that their product is the leader in the SDN market, or that they just made a big acquisition that really puts them ahead in the SDN space, blah, blah, blah. You might also hear from some particular technical individuals (or peers) that SDN is going to "change the world" or "put all network engineers out of work".

## Definition of Parts

When encountering a word or phrase that has an unclear definition, or a definition that is not known to me, I like to break it down into parts and define those. Lets take a look. (Definitions from Google)


> soft·ware
> 
> Noun
> The programs and other operating information used by a computer.

This is a pretty simple one - we all know what software IS, and what it CAN DO, but when you think about it, it's just a list of instructions. This allows us to do really anything with the hardware that runs the software, provided the hardware is physically capable of performing the task.

> de·fined
>
> Verb
> past participle, past tense of de·fine
>
> State or describe exactly the nature, scope, or meaning of.
> Give the meaning of (a word or phrase), esp. in a dictionary

The key phrase here is to "state or describe exactly the nature, scope, or meaning of." This means that the person or thing doing the defining must encompass everything about what it is that's being defined. It must not replace or remove the thing being defined, that would be absurd - the definition of the word "hippocampus" is not the hippocampus itself, it is simply a near-perfect description of what the hippocampus is and does. It is the responsibility of the person or thing that is making the definition, to accurately describe or dictate the nature, scope, and behavior of what is being defined.

> net·work·ing
>
> Verb
> present participle of net·work
> 
> Connect as or operate with a network: "the stock exchanges are resourceful in networking these deals".
> Link (machines, esp. computers) to operate interactively: "networked workstations".

Finally, we arrive at networking - this definition should be no surprise, it is simply a way to connect or interoperate multiple systems together using some kind of medium.

Based on these definitions, SDN is a means by which the act of networking multiple machines/computers together is defined by a set of instructions running in software, somewhere, somehow. The confusing part of all of this is, since software runs on everything to some extent, who's to say that we haven't been running SDN since the inception of computer networking itself! After all - the devices that made ARPANET work had programs running on them that defined how to send frames from one node to another, why can't that be SDN?

[![sdn](/assets/2013/02/sdn.png)](/assets/2013/02/sdn.png)

## Definition of Whole

We've stumbled onto the reason why everyone and their mother is claiming to have an SDN product right now - because no one can argue with them. The product does networking, it's a software solution, so.....SDN!

From where I sit, SDN used to be much more well-defined (pun intended) than what it is today. We have vendors to thank in part for this, but the discussions around SDN have also changed what it is perceived to be. Literally speaking, SDN _can_ be said to mean anything that changes or configures networks to do something different based on some kind of predefined criteria. For instance, mechanisms like NETCONF/YANG, SNMP, and OpenFlow exist to provide the communication definitions between the control plane and the forwarding plane, but by which standard is SDN judged?

Some solutions may use a few of these, but the best ones will pick one, do it well and offer mechanisms to integrate with the others. OpenFlow was originally intended to serve this purpose but [as Greg Ferro points out](http://etherealmind.com/is-openflow-open-i-ask-compared-to-what/), the state of OpenFlow is currently not great, and a very important point is made - there is a big difference between open software, and open protocols sitting in front of proprietary software created by big companies with questionable motivation.

Now - where does this leave the SDN discussion? Is it enough to be content with XML-based interfaces to input commands for us on our network devices? What level of control plane abstraction is required to truly be called SDN? Or is everything considered to be under this big SDN umbrella, and various points of abstraction are simply varying degrees of SDN?

Well, the benefits of true control plane abstraction is seen quite plainly in any product with a distributed linecard / centralized supervisor. Chassis based switches like the Cisco Nexus 7000 or Catalyst 6500 are designed so that the intelligence of forwarding packets from port to port is handled by the supervisor modules, and the line cards are specialized ASICs that do what they do best - forward the traffic.

Even software solutions like the Cisco Nexus 1000v or the Juniper vSG accomplish the same architecture, but it's applied to the virtual environment. Is it SDN because the "supervisor" is running as a virtual machine (in most cases) inside an x86 architecture? NO. Is it SDN because the supervisor is created by a community of folks that open-source it's code for the benefit of the networking industry? No, because none of that is true. But what if it was? What if we had the benefit of a distributed line card architecture, while maintaining independence and openness of not only the protocols used to instruct the forwarding plane, but also the controller itself?

Fortunately, [there are a few promising examples of this](http://www.openflow.org/wp/openflow-components/), but none that are currently receiving public attention because frankly, the vendors have just stomped their feet loudly enough that everyone's too busy trying to figure out the myriad of new products that describe themselves as SDN.

One of my favorite pieces of networking software - Vyatta, was recently acquired by Brocade. [I wrote about this the day of the announcement](https://oswalt.dev/2012/11/the-formation-of-brocatta-brocade-acquires-vyatta/), and I'll say now what I said then: software networking, or networking in software is NOT (I believe) inherently SDN, despite what the two companies are plastering [all over their blogs](http://www.vyatta.com/learn/vyatta-and-software-defined-networks). The benefits of "SDN" according to them sound like the benefits of virtualization, or simply the benefits of virtual appliances. This doesn't mean they're not headed in the right direction, but its an example of a message that's just muddying the waters. The mechanisms that communicate between the control plane and the forwarding plane, the controller itself, and some kind of UI (GUI, CLI, API) to allow a human to make decisions is something that should be thought of as a vital component to any SDN solution. The question is, which protocols? What kind of UI? Does SNMP/NETCONF fit this description? Absolutely! Time will tell which protocol and controller flavor does the job the best.

## "SDN is going to put me out of work!"

The idea that software engineers will at any point be solely responsible for building scalable, efficient data networks, whether through software or not, is laughable. Networking - ANY networking, requires the mindset of a network engineer, someone who understands bits and bytes and knows what it takes to form intelligent communications between two machines over a medium. Now - will a network engineer that does not embrace change be put out of work? Possibly. It is not the profession that is in danger, it is the aging mindsets and bad habits inherited by years of "build-on" networking that is in danger. After all, it is the [Unified Engineer](https://oswalt.dev/the-unified-engineer/) that will both contribute and benefit the most from this paradigm shift, seeing both the network requirements and challenges of today, and the software-based solutions of tomorrow.

Keep this in mind as you approach any problem, mindset shift, or new job. Old habits and "set-in-your-ways" mentalities are any IT professional's worst enemy. SDN will not arrive on a white horse as some revolutionary new protocol that shakes mountains, changes the direction of rivers, or walks on water. It will sneak in subtly, defining itself by whoever is carrying the message at the time. The engineers that get involved and steer the conversation in the right direction while protecting the industry's interests, not a corporations' will be responsible for where this thing goes. No matter what though, SDN will be 1 part technology change, and 99 parts mindset change.
