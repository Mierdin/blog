---
layout: post
title: Introduction to Open vSwitch
author: Matt Oswalt
comments: true
categories: ['Virtual', 'Networking']
date: "2013-10-07"
wordpress_id: 4727
slug: introduction-to-open-vswitch
tags: ['linux']
---


In the early days of my quest to cut through the jungle of hype regarding SDN, it was difficult to go a single day without hearing about Open vSwitch, or OVS.

I've been tinkering with Open vSwitch in my lab for a few months now, and realized that I haven't yet written an introductory post about it for those that haven't tried it out.

If you're involved with data center like I am, you're probably familiar with the concept of a vSwitch. Simply put, this is the idea of performing ethernet switching in a hypervisor. This could be something complicated, but at a minimum it needs to be little more than a simple bridge (KVM implementations commonly used the Linux bridge to accomplish this).

The main reason one would use OVS is to greatly improve the capabilities of each hypervisor switch beyond simple bridging capability.

The configuration of OVS is controlled by a database schema organized into several tables, all held in userspace (the kernel module is used strictly for forwarding). This database is persistent across restarts, and is JSON-based (though we'll get to that later).

There are two tools used to configure an OVS instance: OpenFlow and OVSDB. These two protocols are what allow us to do really cool stuff with OVS beyond simple bridging, in a multi-hypervisor fashion.

[![diagram2](/assets/2013/10/diagram2.png)](/assets/2013/10/diagram2.png)

These protocols, however, are used for different things, so let's explain.

## OpenFlow

Open vSwitch is one of the most popular implementations of [OpenFlow](https://oswalt.dev/2011/06/introduction-to-openflow/). OpenFlow allows us to use just about any field in a frame of traffic (L2 to L4) and make decisions. This decision might be to modify some fields, or to encapsulate the frame inside something else, or simply forward out a port.

OpenFlow is a leading example in SDN of a controller-based network architecture. The idea in this case would be to use the OVS as an access layer to the virtual environment, taking instructions from some kind of centralized controller that pushes flows down to the vSwitch.

[![openflow](/assets/2011/06/openflow.jpg)](/assets/2011/06/openflow.jpg)

OpenFlow is where we get the most bang for our buck when it comes to Open vSwitch. While OVS can do things like tunneling, QoS, and SPAN natively, the real value comes from being able to directly influence flow tables, creating powerful L2-L4 service insertion, right in the hypervisor. Because of this L2-L4 visibility, we can do basic routing and security right there in RAM.

If you haven't yet heard much about OpenFlow, I recommend reading the [OpenFlow 1.3 specification](https://www.opennetworking.org/images/stories/downloads/sdn-resources/onf-specifications/openflow/openflow-spec-v1.3.0.pdf). While there are many aspects of networking where OpenFlow might not fit very well, it can't be denied that it's becoming a powerful tool in nearly every SDN solution coming to market these days, in some form or fashion.

## OVSDB

Now - I usually like to draw an analogy between OpenFlow and routing protocols to illustrate exactly what OpenFlow does or does not do. Like OSPF, OpenFlow directly influences the forwarding behavior of a networking devices (albeit way differently than OSPF) but isn't able to actually change the configuration of that device. OSPF cannot disable a router's interface, or create a GRE tunnel, for instance. For that, we need a management plane protocol.

In the world of OVS, this role is filled by [OVSDB](http://tools.ietf.org/html/draft-pfaff-ovsdb-proto-04). This allows us to use well-understood wire protocols (namely JSON-RPC) to send commands to an OVS instance to do things like create tunnels, turn on/off certain features, get configuration data, and more.

OVSDB messages are returned to the manager when they have been either committed to the OVS database, or failed.

As was mentioned by Ben Pfaff in the comments below, you can use the "next_cfg" and "cur_cfg" columns in the Open_vSwitch table to verify if the configuration has actually taken effect in vswitchd. I had previously made a more general statement that falsely indicated OVSDB messages weren't returned until the configuration was applied - which is not the case.

The database is also persistent across restarts, as it's immediately written to disk. Therefore, OVSDB is used as a very reliable way of configuring OVS instances.

OVSDB can be used in very simple scripts (like [this one](https://oswalt.dev/2013/10/ovsdb-echo-in-python/) I threw together in python) or as part of a larger framework like OpenDaylight. In fact, OVSDB support is one of the big projects [going on right now](https://wiki.opendaylight.org/view/Project_Proposals:OVSDB-Integration) inside ODL. OVSDB can be used locally on the host running OVS or remotely, using tools like ovsdb-client, or by serializing your own JSON-RPC and sending it to OVS.

A simple example of this is the OVSDB "echo" function, provided simply by sending the following:
    
    {
    	"method": "echo",
    	"id": "echo",
    	"params": []
    }

I highly recommend heading over to [Brent's post on networkstatic.net](http://networkstatic.net/getting-started-ovsdb/) which walks through OVSDB in far more detail. In the following weeks, I will be spending a lot of time with OVSDB, as it is becoming the de-facto protocol for configuring OVS instances, as well as other solutions that have adopted the OVS database model.

## Configuration

As mentioned before, the OVS configuration is contained within several database tables, all written persistently to disk. These tables contain varying amounts and types of configuration data, and all refer to each other in various ways, much like a relational database would (In fact, nearly every value stored in these tables gets it's own UUID for the lifetime of that data).
	
  * Bridge Table	
  * Capability Table
  * Controller Table
  * Interface Table
  * Manager Table
  * ...and more!

The details on how these tables work or how they're related would be way too long-winded for this post, so for this I recommend reading the detailed [documentation on ovs-vswitchd.conf](http://openvswitch.org/ovs-vswitchd.conf.db.5.pdf)

Basic configurations can be done simply through the "ovs-vsctl" command. A "show" function off of this gives us the current running configuration:
    
    root@kvmovs-test:~# ovs-vsctl show
    3952f363-f6d0-4425-94c1-c5735c0a799c
        Manager "ptcp:6634:10.12.0.30"
        Bridge "ovsbr0"
            Controller "tcp:10.12.0.30"
            Port "tap0"
                Interface "tap0"
            Port "ovsbr0"
                Interface "ovsbr0"
                    type: internal
            Port "tap1"
                Interface "tap1"
            Port "eth0"
                Interface "eth0"
        Bridge "ovsbr1"
            Port "ovsbr1"
                Interface "ovsbr1"
                    type: internal
        ovs_version: "1.4.0+build0"
    root@kvmovs-test:~#

A quick note on this config:

  * The "tap" interfaces are virtual ports where virtual machines "plug in"
  * The "eth" interfaces are physical ports. Physical ports can only belong to a single bridge at a time.
  * The interface named "ovsbr0" is akin to the vmkernel port in vSphere lingo. You can assign an IP address to this interface so that this bridge can have it's own controller connection.
  * "Manager" refers to an OVSDB client. The "ptcp:<port>:<addr>" syntax means that OVS is passively listening on that port and local address for incoming JSON-RPC data.
  * "Controller" refers to an OpenFlow controller. The "tcp:<addr>" syntax means that OVS proactively reaches out to a controller at that address  to establish the relationship. (Standard port of 6633 is being used here)

Displaying things a little more visually, we basically end up with this:

[![diagram1](/assets/2013/10/diagram1.png)](/assets/2013/10/diagram1.png)

Not too complicated at first glance, but keep in mind that we can do some really powerful stuff with OVSDB and OpenFlow to build advanced services on top of this.

## Conclusion

This video is not only a good introduction to OVS, but also shows some configuration walkthroughs.

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/_PCRNUB7oNw" frameborder="0" allowfullscreen></iframe></div>

When you're done watching, head on to [openvswitch.org](http://openvswitch.org/download), download the latest copy, and get cracking!
