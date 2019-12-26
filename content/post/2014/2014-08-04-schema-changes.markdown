---
layout: post
title: Dealing with Schema Changes
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2014-08-04"
wordpress_id: 5920
slug: schema-changes
tags: ['api']
---


It's not often I get to write about concepts rooted in database technology, but I'd like to illuminate a situation that software developers deal with quite often, and one that those entering this space from the network infrastructure side may want to consider.

Software will often communicate with other software using APIs - an interface built so that otherwise independent software processes can send and receive data between each other, or with other systems. We're finding that this is a pretty hyped-up buzzword in the networking industry right now, since network infrastructure historically has had only one effective method of access, and that is the CLI; not exactly ideal for anything but human beings.

These APIs will typically use some kind of transport protocol like TCP (many also ride on top of HTTP), in order to get from point A to point B. The data contained within will likely be some kind of JSON or XML structure. As an example, here's the output from a Nexus 9000 routing table:

{{< highlight xml >}} 
    <?xml version="1.0"?>
    <ins_api>
        <type>cli_show</type>
        <version>0.1</version>
        <sid>eoc</sid>
        <outputs>
            <output>
                <body>
                    <TABLE_vrf>
                        <ROW_vrf>
                            <vrf-name-out>default</vrf-name-out>
                            <TABLE_addrf>
                                <ROW_addrf>
                                    <addrf>ipv4</addrf>
                                    <TABLE_prefix>
                                        <ROW_prefix>
                                            <ipprefix>172.16.41.1/32</ipprefix>
                                            <ucast-nhops>1</ucast-nhops>
                                            <mcast-nhops>0</mcast-nhops>
                                            <attached>FALSE</attached>
                                            <TABLE_path>
                                                <ROW_path>
                                                    <ipnexthop>172.16.1.1</ipnexthop>
                                                    <ifname>Po1</ifname>
                                                    <uptime>P1DT12H38M3S</uptime>
                                                    <pref>110</pref>
                                                    <metric>2</metric>
                                                    <clientname>ospf-1</clientname>
                                                    <type>inter</type>
                                                    <ubest>TRUE</ubest>
                                                </ROW_path>
                                            </TABLE_path>
                                        </ROW_prefix>
                                    </TABLE_prefix>
                                </ROW_addrf>
                            </TABLE_addrf>
                        </ROW_vrf>
                    </TABLE_vrf>
                </body>
                <input>show ip route</input>
                <msg>Success</msg>
                <code>200</code>
            </output>
        </outputs>
    </ins_api>
{{< /highlight >}} 

Typically, we prefer methods like this if we're performing configuration changes in some software that we've written, since this makes the effort of looking up a particular piece of information - say, the next-hop IP address for a particular prefix - very painless. We simply iterate through the fields that have already been parsed for us until we get what we want - usually by understanding that this next-hop address uses a tag of "ipnexthop".

The knowledge of where to expect certain types of data is known as this document's **schema** - essentially a common understanding of how this XML information is to be laid out. We write software with the expectation that the next-hop address will always be at that "ipnexthop" tag.

This came up in a conversation I had last week - what if someone changes this schema without our knowledge?

[![alteredschema](/assets/2014/08/53236038.jpg)](/assets/2014/08/53236038.jpg)

In an ideal world, this would never happen. We would be able to write scripts and software once, and it would work for the rest of time. Unfortunately, this is just not realistic. The creators of the API may realize down the road that they need to create a new tag, or rename an old one in order to make way for a new feature. Even the CLI is impacted - those that have written CLI-scraping utilities have seen their awesome regular expressions brought down by a simple character change by a vendor.

## Schema Enforcement Through Communication

Now - in a purely software-development world, it's often that an app developer has to write software to access and make changes to a production database. That database may have been laid out by an internal database team, and made to be efficient through normalization, etc. This is not an uncommon situation.

The application developers will have to come to an agreement with the database team on a logical schema for this database, so that the application can be written to properly access and change the data stored within. Even though this isn't a high-level XML or JSON API as we discussed in the previous section, there still has to be a consistent standard layout, otherwise it would be very difficult to write code to consume this data.

In my research on the topic, I ran into this interesting [StackExchange discussion](http://programmers.stackexchange.com/questions/235785/how-to-handle-unexpected-schema-changes-to-production-database) on the topic - it's worth a read. The general undertone, regardless of the specific answer, seems to be centered primarily around human communication. In essence, a better question might be "What is an appropriate process to ensure that changes to an existing schema is properly communicated to anyone that might be affected?" Though you'll see plenty of folks falling back to the "shit happens" approach (basically that production changes happen no matter what) - the best preventative measure is to establish a clear line of communication, so that when changes are made, they're done as safely as possible.

To bring the discussion back to the networking world, we have a plethora of communication schemas. We inherently deploy heterogenous, distributed systems whenever we deploy data networks. Out of necessity, we've come up with standardized protocols like BGP or OSPF so that no matter how the routing topology is implemented in software on a Cisco or Juniper device, the format by which we communicate this information follows a certain standard. These standard protocols are built so that we don't have to guess at the data being sent to us, in neither the RPC operations, or the data contained within. In this model, the communication is passed down from standards bodies like the IETF, and the vendor software developers implement these protocols in a (hopefully) standards-based way.

Even simple APIs like NX-API as shown above can be changed, as long as the vendor provides ample notice in the form of change notes when a firmware upgrade implements a new version of an API.

## Schema Enforcement Through Code

Now, all this is well and good but something has to be done about the times when - for some reason - standards are not followed. Your database admins will make a change that they don't think needed to be communicated, a vendor will fail to add a certain XML tag under conditions they didn't test for, et cetera. These things do happen. So how can we deal with it?

I [recently wrote](https://oswalt.dev/2014/07/handling-multiples-cisco-nx-api/) about anticipating a certain quirkiness with a vendor API I was working with. This is a good example of putting mechanisms into place that help "soften the blow" when APIs don't act like they're supposed to.

The methods vary on implementation, but you can use techniques like XML validation to ensure that a particular document follows the intended schema. [Libxml](http://xmlsoft.org/) is a very popular tool, and I've used a very similar [Python equivalent](http://lxml.de/) on multiple occasions.

You can get more granular with the datatypes represented in code as well. For instance, it might be simple enough to throw the results of an NX-API request into a Python dictionary like below:

{{< highlight python  >}} 
    #!/usr/bin/env python2.7
     
    from cisco.nxapi.nxapiutils.nxapi_utils import NXAPI
    import json
     
    #Create new NXAPI connection
    thisNXAPI = NXAPI()
    thisNXAPI.set_target_url('http://10.2.1.8/ins')
    thisNXAPI.set_username('admin')
    thisNXAPI.set_password('cisco')
    thisNXAPI.set_out_format('json')
    thisNXAPI.set_msg_type('cli_show')
     
    #send command and create a dictionary to hold the response JSON
    thisNXAPI.set_cmd('show ip ospf')
    returnDict = json.loads(thisNXAPI.send_req()[1])
{{< /highlight >}}

Of course, returnDict is totally at the mercy of the vendor API, since all data is blindly passed in. The more complicated the API or protocol, the less sufficient this will be. Eventually it might be worth building entire classes (moving out of scripting and into full-blown development) that represent the datatypes you want. Here, [a class file defines the Bridge table](https://github.com/opendaylight/ovsdb/blob/master/schemas/openvswitch/src/main/java/org/opendaylight/ovsdb/schema/openvswitch/Bridge.java) in an Open vSwitch Database Protocol (OVSDB) schema.

> More on OVSDB in a later post - there's a lot to discuss here. Suffice it to say that I have learned so much from the folks in the OpenDaylight community, and continue to do so.

When this is done, the methods used to populate each of the fields in a class like this can have their own specific checks to ensure the data contained within is built the way it is supposed to. If an exception needs to be raised, it can be raised on the specific dataset in question, limiting the impact on the application as a whole.

If a received schema deviates from a standard, there should be some kind of notification to the user, and as much effort should be taken to continue normal operation if possible. For instance, in our earlier example it may not be totally necessary to have a next-hop IP address, rather just a next-hop interface. Our code should be able to handle either case, and we as the human beings should write code that reflects our internal priorities of data fields like this.

## Conclusion

I was talking to someone about protocol design not to long ago (if you remember, speak up - would love to give credit) and I heard some advice along these lines - "Transmit Strictly, Receive Loosely". The idea is that you ensure that the schemas you send in your applications or even scripts, adhere as closely as possible to a chosen standard, but should also be flexible enough so that if something malformed does come into your software, it takes every effort to continue operating normally.

We're spoiled as network folks because we typically don't have to deal with things like this, it's the vendor developers writing our NOSs that implement these tactics. However, as more brains enter the software-development-meets-networking space, concepts like these are good, core programming concepts to ponder and reinforce as we graduate from simple scripts.