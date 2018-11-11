---
layout: post
title: ' [Quality of Service] Part 3 - Nexus 1000v: The Servers are Doing QoS Now?!?'
series:
- Cisco QoS
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-05-10"
wordpress_id: 3740
slug: quality-of-service-part-3-nexus-1000v-the-servers-are-doing-qos-now-2
tags: ['1000v']
---


I'm going to talk a little bit about performing QoS functions from within the Nexus 1000v. Since it's been awhile since I made the last post in this series, a recap is in order:
	
  1. In my [first post](https://keepingitclassless.net/2012/11/cisco-quality-of-service-part-1-types-of-qos-policies/), I explained what the different types of QoS policies were in the context of Cisco's MQC
	
  2. In my [second post](https://keepingitclassless.net/2012/11/qos-part-2-qos-and-jumbo-frames-on-nexus-ucs-and-vmware/), I went through the actual configuration on specific platforms like the Cisco Nexus and Unified Compute platforms, as well as a brief mention of vSphere's participation, but less on the QoS aspects and more on MTU.

  3. I also made a [QoS-related post](https://keepingitclassless.net/2013/04/the-importance-of-qos-in-a-converged-infrastructure/) that explored why it's important to have a proper QoS configuration, especially in a converged infrastructure like so many data centers are becoming.

In today's converged environments, it's no longer acceptable to simply group all traffic on a single interface into a QoS policy, if the end device is not performing marking of it's own. While there are many ways to classify traffic, the most efficient way is to use L2 markings, otherwise known as Class of Service (CoS). Since this is in the Ethernet header, performing classification does not require deep inspection of the packet.

Take most VoIP phones out there on the market, Cisco included. The majority allow you to plug that phone into the wall jack, and on that phone, there's another port that allows you to plug in your PC. The phone essentially serves the purpose of an extremely small switch, allowing both your PC as well as the phone itself to get network connectivity. Therefore, the phone will send both types of traffic upstream. However, it's important to give the traffic that originated from the phone priority, while traffic that was simply passed through the phone from the PC should get less priority. This is done on the switch level, but the switch can easily figure out which frames are which if they're marked appropriately.

With the dawn of virtualization, servers are now no different. We have so many applications converging into the data center, we need to make sure that our QoS trust boundary is close enough to the "packet generators" so that we're classifying priority traffic specifically. There are two ways to do this.

  1. Use a server with a lot of NICs. Configure the hypervisor so that the VMs with high priority can only use some subset of physical links, and put all the other VMS on other links. Classifying the traffic is pretty simple in this case - merely treat traffic that arrives on that set of switchports differently than the other switchports. This is essentially physical classification.
	
  2. Classify traffic within the hypervisor, based on the originating _virtual_ switchport (or port group). Use this classification to tag relevant traffic with a CoS value so that the upstream switch can immediately identify the proper class to place the traffic in

Most of the time, if QoS is absolutely needed, and no hypervisor solution is available, then number 1 works....okay. With virtual networking solutions like Cisco UCS where vSphere NICs are no more physical than the virtual machines riding on top, then yeah it's probably no big deal to rely on the separation of NICs to classify traffic. However, method number 2 isn't that far-fetched.

By far, the most widely used solution on top of vSphere that allows us to use the second method is the Cisco Nexus 1000v. This product is not for everyone - I think the biggest users of the 1000v are the network people, and some organizations have not been built so that those two silos can interact well. Sad, but true.

This isn't a sales pitch for the 1000v, but the fact is that right now it's one of the only solutions that allow you to do this. Classification is fairly easy - just like anything else in MQC, you must define a policy-map in order to do anything:
    
    n1000v(config)# policy-map mark-silver
    n1000v(config-pmap)# class class-silver
    n1000v(config-pmap-c-qos)# set cos 3

Pretty simple, right? Now we apply it to a vethernet port-profile (where VMs plug in):

    n1000v(config)# port-profile type vethernet SILVER_VMS
    n1000v(config-if)# service-policy input mark-silver

Traffic that egresses hosts on this port profile will now have a CoS tag of 3 in their Ethernet header, allowing you to easily classify traffic out of a single NIC if you wanted to.

> The 1000v is actually capable of some pretty advanced QoS features, considering what it is. Check out the [QoS configuration guide](http://www.cisco.com/en/US/docs/switches/datacenter/nexus1000/sw/4_2_1_s_v_1_4/qos/configuration/guide/n1000v_qos.html) for info on  policing, classification, marking, and more.