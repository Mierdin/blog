---
layout: post
title: Nuage Networks at Network Field Day 6
author: Matt Oswalt
comments: true
categories: ['Tech', 'Field', 'Day']
date: "2013-09-26"
wordpress_id: 4661
slug: nuage-networks-at-network-field-day-6
tags: ['bgp-mp']
---


Nuage is tackling the "rapid provisioning" problem when it comes to networking.  How can we convince customers or LoB owners to not push everything up to AWS, when the provisioning mechanisms behind a private solution are not nearly as good? The ultimate goal is to have the network immediately ready upon instantiating a workload, physical or virtual. The key focus we heard about is that an SDN solution must provide this policy automation framework across virtual AND non-virtual workloads.

Nuage was a presenter at Networking Field Day 6. We definitely made our share of interruptions and questions, but I think it ended up going really well, and we got into some serious nerd knobs that I think everyone was happy to see.

The solution includes three layers: a virtual networking agent, an OpenFlow controller, and a directory server that communicates policy information to and from each controller instance.

[![pic1](assets/2013/09/pic1.png)](assets/2013/09/pic1.png)
	
  * **VRS** - hypervisor-based networking agent (pretty much vanilla Open vSwitch with nuage-specific module in userspace)
	
  * **VSC** - Control Plane. This runs the same OS as the Alcatel-Lucent code that's been out there for 20 years or so. Obviously the new features aren't so battle-hardened, but at the very least the main code train is. The point is that they didn't have to spend a whole chunk of time re-creating a controller.

  * **VSD** - Policy is created and applied here.

There are a few other protocols and technologies used in the Nuage product. Let's take a dive into these details.

## Controller-based Networking with Federation

The idea of scale-out with federation helps to answer one of the biggest hurdles in SDN, which is the fate-sharing nature of the controller-based approach. BGP-MP is used to federate between controllers. This is only for reachability information, not policies (can't propagate ACLs over BGP, etc).

The controllers use BGP-MP to share reachability information with each other. This is done because of awesome vSwitch features like distributed ARP. Responding to ARP messages right in the hypervisor drastically cuts down on the amount of broadcast traffic in the network, but in order for this to work, all hypervisor switches need to share the same state information. This is easy to do if all of your hypervisors are connected to the same controller. However, if you're using the Nuage solution, you might use a number of controller clusters for scalability. In this case, the controllers need to share state with respect to features like ARP, and BGP-MP is used to do this.

One quick note about scalability. If you have under 1000 servers, you just get a controller cluster, no big deal. If you need to scale beyond that, you cut-n-paste clusters throughout your environment. Each cluster communicates upstream with the policy server, but they all also communicate with each other using MP-BGP federation.  BGP-MP is used as a scaling point, as well as an open interface for communicating reachability information in, for instance, a hybrid cloud, so for smaller, isolated deployments, no BGP-MP is necessary - just use a standard controller cluster deployment.

## Networking Unicorns

Nuage is taking the increasingly popular approach of simplifying the core (pure IP fabric) while at the same time increasing the intelligence of the edge through an advanced hypervisor-based networking agent. "Tunneling" is used primarily for namespace isolation. VXLAN is used for traffic encapsulation, and OpenFlow/OVSDB for communication with the hypervisor switches.

> The term "tunneling", as mentioned by other, smarter folks, in this session and others, is an inaccurate term. The term "stateless tunneling" is essentially analogous to using 802.1q for VLAN tagging. These tunnels aren't pinned up all the time, traffic is applied a tag, it's given a destination IP, and it's sent. No tunnel.

Another cool feature is that the Nuage network is intelligent enough to know that if the next hop is an actual PE router, then it uses GRE-based VPNs, not VXLANs. This is a compelling mechanism to use to get traffic to the PE, because it's easy, it has considerably less overhead than VXLAN (not to mention the PE probably doesn't understand VXLAN) and it continues the namespace isolation all the way to the PE, which will likely re-encap to MPLS or something like that. Of course, intra-DC traffic still uses VXLAN.

Of course, they are implementing basic L3/L4 services in the hypervisor, in addition to the aforementioned distributed DHCP and ARP.

## The "Underlay"

Nuage has taken the position of using an in-band control path, so the data plane and control plane share the same fate. This way, we can detect the failure and do something about it.

The controllers are actually able to peer using OSPF/ISIS/BGP so that they can discover the underlay topology. As a result, the controller will also be made immediately aware of failures in the underlay.

In cases where a failure is not able to be detected in this way (for instance a failure in the L2 connection between ToR and server) then we simply rely back on the fact that the control path and data path use the same physical link. In this case, the TCP connection between hypervisor and controller will go down, and we still have our failure detection.

## Policy

Nuage makes the point that application developers in environments like AWS are still required to configure routers, routing protocols, IP addressing, ACLs, and LB/FW sizing, etc. Do you really want app developers doing all this? Instead, we can expose only simple policy concepts to those consuming compute resources, without going into details on the underlying network-specific stuff.

> You should definitely stick around to the end of this post, where I've posted the demo video that goes into all of this.

These policies can get approved by the various teams, and then simply used as many times as the application stacks need them.

This hits home with me, because I'm already used to the concept of things like port profiles in the vSphere Distributed Switch, or vNIC and vHBA Templates within UCS. It's all about defining ACLs, services, policies, etc. once, and simply allow those spawning compute instances to select this connectivity from a list. Almost like "Networking As A Service".

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">&quot;<a href="https://twitter.com/Mierdin">@Mierdin</a>: Think defining port profiles in vSphere. Define network behavior ahead of time, let the apps select from dropdown <a href="https://twitter.com/hashtag/nfd6?src=hash">#nfd6</a>&quot;&lt;&lt;This.</p>&mdash; Ivan Pepelnjak (@ioshints) <a href="https://twitter.com/ioshints/status/378302698350968832">September 12, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I found this to be a suitable analogy for the "policy" portion of Nuage's VSP solution.

XMPP is used to not only ask the policy server what to do, but to also push new policies down to the controller from the policy server when policies are changed/created.

## Baremetal Workloads

These are VTEPs (VXLAN Tunnel Endpoints) - sort of a translation device between the virtual networks, and the old VLAN model, providing traditional connectivity to baremetal workloads.

Their big use case is that gateways are still needed for physical workloads and should be part of this solution. They make the case that gateways being used for WAN connectivity (like dedicating machines or VMs for translating to VLANs, etc.) is a bad model. We saw earlier that this connectivity is established directly between the hypervisor and the PE router through GRE tunnels without the extra hop.

The VTEP is not just a L2 translation device - to be part of this "big virtual router" it also needs to be able to provide L3/L4 services before connecting into the main network as well. Essentially this functions like all of the other vSwitches in the network, in a physical package.

Nuage offers a simple software gateway, and they also work with a few vendors to bake in their agent to ToR offerings (probably very close to the same list of partners that NSX announced last month). They also took the time to announce the Nuage 7850 VSG switch, purpose-built to serve as the physical edge to a network virtualization deployment.

## Demo

I was REALLY impressed by the zone-based ACLs, not using explicit IP subnet statements. We're abstracting over the subnets, and defining access using business rules. If I'm an apps guy, this is perfect - I don't care about subnets.

[![pic2](assets/2013/09/pic2.png)](assets/2013/09/pic2.png)

The subnet is defined in the creation of these zones. So the ACL can be created by someone with limited knowledge of the actual network itself. On the controller side, these are evaluated into actual subnets. This simplification is only reflected on the policy side.

Note that everything that you can do in the GUI, there's a REST API function for. AUTOMATE ALL THE THINGS!

## Conclusion

Dmitri (and the rest of the Nuage team) is obviously very knowledgeable and passionate about their product. We threw a ton of questions their way, and they had a solid answer for nearly every single one of them, which says a lot. Kudos to them for a great discussion and great demo.

Videos below:

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/hcZHkYhE1_M" frameborder="0" allowfullscreen></iframe></div>

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/S9iDUm07_Zo" frameborder="0" allowfullscreen></iframe></div>

> Nuage was a vendor presenter at [Networking Tech Field Day 6](http://techfieldday.com/event/nfd6/), an event organized [by Gestalt IT](http://techfieldday.com/about/). These events are sponsored by networking vendors who thus indirectly cover our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter's beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don't ask for, nor are they promised any kind of consideration in the writing of my blog posts ... and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))
