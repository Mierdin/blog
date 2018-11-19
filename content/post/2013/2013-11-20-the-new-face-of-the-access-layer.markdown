---
layout: post
title: The New Face of the Access Layer
author: Matt Oswalt
comments: true
categories: ['Virtual', 'Networking']
date: "2013-11-20"
wordpress_id: 5028
slug: the-new-face-of-the-access-layer
tags: ['1000v']
---


The role, and the features of the access layer in the datacenter has changed dramatically in such a short time. Prior to virtualization, the DC access layer was still relatively simple. Now that the majority of workloads are virtualized, we're seeing some pretty crazy shifts. Many simple network functions like routing and security, as well as some advanced functions like load balancing are moving into software. This follows the general best practice of applying policy as close to the edge of your network as possible.

Five years ago, a vSwitch provided little more than direct Layer 2 connectivity between virtual machines and the physical network (think Linux bridge). Today, thanks to things like Open vSwitch, we're able to do a bit more like routing and basic security directly in the hypervisor. This functionality can easily be controlled through local instantiation, but since it's software, the low-hanging fruit is to provide this functionality centrally through a controller.

Thus, technologies like [VMware NSX](http://www.vmware.com/products/nsx/) and Juniper's recently open-sourced [Contrail](http://opencontrail.org/), were born. These technologies make use of the programmable nature of these vSwitches, and orchestrate their configuration, as well as provide oversight for the construction of virtual networks between hosts using VXLAN, GRE, etc. All of this being done in the name of enhanced business agility by making the network more responsive - which ultimately is what all of this is about.

Cisco's new ACI product family that I spoke about a few weeks ago plays a role here too. One of the least-visible parts of the announcement in New York was that they were rolling out an Application Virtual Switch, or AVS. This immediately struck a nerve with many folks, including me, because the Nexus 1000v exists and does quite well. In short, Cisco will tell you that the 1KV isn't going anywhere, and that there's a migration path if you go ACI, and so forth. I'm interested, instead, in how this technology will actually work.

> From what I can tell, the AVS is basically going to be a modified VEM (in 1000v nomenclature) that is intended to be used only with an ACI fabric. AVS will provide us with a place to connect virtual machines and apply policy, which would also probably mean that the AVS is going to do VXLAN encap and coordination with the fabric.

Thinking about vSwitches in the context of ACI and NSX means that the vSwitch's primary role is to apply and migrate policy effectively. Connectivity is important, but also easy. 2014 will be the year of "policy". Therefore, in order to effectively apply policy, we must also be effective at identifying applications, no matter where they are, so that we can apply policy to them.

## Application Classification

So how do we do this today? I'll spoil it for you - an access list is a great example because it's 99% of the time the biggest reason why applications don't move forward.

> "Hey network guy!"
> 
> "What?"
> 
> "My app isn't working"
> 
> "Write it better, then."
> 
> "No, you jerk, I need a port open!"
> 
> "Submit a change request ticket, I have to spend 7 days looking through the existing rules first."

You think this is sad? What's even worse is that most businesses reject these inefficiencies because the business just needs to move faster. They don't have a technology solution to solve the problem, so everything get's opened right up.

Look at what's in your pocket right now. Smart phone. Worst invention ever from the perspective of security. We now have apps that control the security of our house from the most insecure devices on the planet. Utter rubbish. But you see how convenience and usability trumps common security sense. Every. Time. But I digress.

The logical next-step is twofold:

  * Move this "ACL-like" classification closer to the edge, so that it can move with the virtual or physical workload

  * Enable the creation of these policies to take place centrally, in a way that is closely aligned with the applications and business processes.

Plexxi has done this since their inception with their concept of "affinities". Cisco's doing it now with the concept of ACI. Even the OpenDaylight project is implementing these ideas in a way, by abstracting the specific network logic away from the interpreted language of the business, programmable at a central point.

Keep in mind that when I say "ACL" I'm talking about what we usually use ACLs to permit or deny - L3 and L4 addressing information. A vSwitch is able to use the properties it has access to by virtue of being co-resident with the hypervisor to define the communication upstream. So let's say we want the vSwitch to tag all frames with a VXLAN tag of X that are coming out of a virtual machine we specify. We could also, in theory, get more granular with this, and send different VXLAN tags depending on what TCP or UDP port addressed on traffic coming out of that virtual machine. This assumes, of course, that the vSwitch is able to view L4 information, which we're starting to see hit the market.

## Application Virtualization

Every once in a rare while, I run into organizations that are actually virtualizing their applications through the use of containers, rather than strict operating system virtualization as we know it (though admittedly sometimes it's both - App Virt on a Linux host that is also a VM)

In my mind, the end-game for a vSwitch in the application realm is to provide complete Layer 7 awareness by providing software constructs that are used by the applications on a given host. This kind of connectivity wouldn't even get into L3-L4 until passed through this module, and outside the host. We could then apply VXLAN tags based on what daemon or service initiated the network transaction - we wouldn't have to rely on IP or port information, because the "vSwitch" is now an "aSwitch".

Candidly, we're probably quite a ways off from a time where this functionality is really all that useful. Right now we're getting the ball rolling with network-centric terms because it's a period of disruption, and that's our bridge to the next world. I've actually spent a lot of time dreaming up architectures where we could read into L7 information with things like ADC appliances from F5 and Citrix and tag VXLAN accordingly, but ultimately there's not a huge need for that right now. It's fun to think about, though.
