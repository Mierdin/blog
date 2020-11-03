---
layout: post
title: '[SDN Protocols] Part 3 - OVSDB'
series:
- SDN Protocols
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-08-28"
wordpress_id: 5882
slug: sdn-protocols-3-ovsdb
tags: ['api']
---


Today, we will be discussing the Open vSwitch Database Management Protocol, commonly (and herein) referred to as OVSDB. This is a network configuration protocol that  has been the subject of a lot of conversations pertaining to SDN. My goal in this post is to present the facts about OVSDB as they stand. If you want to know what OVSDB does, as well as does NOT do, read on.

> I would like to call out a very important section, titled "OVSDB Myths". I have encountered a lot of false information about OVSDB in the last year or so, and would like to address this specifically. Find this section at the end of this post.

If you're new to OVSDB, it's probably best to think of it in the same way you might think of any other configuration API like NETCONF, or maybe even proprietary vendor configuration APIs like NXAPI; it's goal is to provide programmatic access to the management plane of a network device or software. However, in addition to being a [published open standard](http://tools.ietf.org/html/rfc7047), it is quite different in it's operation from other network APIs.

## Control vs Management

In order to really know what OVSDB is all about, we should first understand it's intended role and purpose. There has been a lot of confusion around OVSDB, specifically as it pertains to OpenFlow, which I'll discuss in detail in the "OVSDB Myths" section at the end of this post.

For now, suffice it to say that OpenFlow and OVSDB do not have inherent dependencies on each other, However, they are often used together, as they have very complementary purposes.

[OpenFlow](https://oswalt.dev/2014/07/sdn-protocols-1-openflow-basics/) is a control plane protocol. It's goal is to manipulate the forwarding pipeline on a networking device using imperatively stated match and action rules. It is not capable of making other configuration changes to a switch or router. OpenFlow cannot, for instance, create a tunnel interface, or shut down a physical port. Some kind of configuration protocol is needed for this.

OVSDB has filled this void in many ways, primarily because Open vSwitch has become the de facto platform on which to innovate with SDN, and OVSDB is obviously very supported on this platform. If you take a look at the [OVSDB RFC](http://tools.ietf.org/html/rfc7047) you'll notice a diagram that simply outlines the complementary but very clearly separate relationship between the control and management processes:

[![ovsdb-openflow-difference](/assets/2014/07/Screenshot-2014-07-29-10.07.44.png)](/assets/2014/07/Screenshot-2014-07-29-10.07.44.png)

In an Open vSwitch deployment, there is a dedicated process  - "ovsdb-server" - made specifically to accept configuration changes from an OVSDB client. This OVSDB client can be a [piece of software co-resident with a controller platform like OpenDaylight](https://wiki.opendaylight.org/view/OVSDB_Integration:Main), or it could be a simple, interactive client like "[ovsdb-client](http://openvswitch.org/cgi-bin/ovsman.cgi?page=ovsdb%2Fovsdb-client.1.in)", which is also typically packaged with Open vSwitch builds.

> Hopefully you are now starting to see what I learned about Open vSwitch a while ago - that it is much more than virtual switching, it also comes packaged with much more badassery. Where other platforms "have an API", the OVS community has taken ownership of both sides of a programmable interaction.

The above diagram represents a very popular paradigm, since OVSDB and OpenFlow have very complementary strengths, but it shouldn't be assumed they require each other.

Let's take a step back from OVSDB and OpenFlow for a second and analyze the protocols we're all running in production today. The vast majority of networks use some kind of routing protocol, like OSPF. Is OSPF capable of establishing tunnel interfaces, or setting SNMP information? No - you use a routing protocol to inform your network devices of reachability information.

Similarly, your configuration protocols - whether this is a proprietary API like NX-API, or something like NETCONF - shouldn't have any dependencies on what routing protocol is used. These protocols do not manage forwarding state, they manage all of the other configuration options on a networking platform. Even if you're doing everything manually, your human network administrator doesn't have any more dependency on the routing protocol being used as NETCONF does - it is just a slightly different implementation detail.

![ovsdb1](/assets/2014/08/ovsdb1-1024x396.png)

In summary, the role of the management plane is fundamentally different from the role of the control plane. OVSDB and OpenFlow certainly work very well together because they each fill one of these two important roles, but that doesn't mean it's the only possible combination.

## OVSDB the Wire Protocol

Now that we've established the intended role of OVSDB, let's get into how it works.

OVSDB is based on JSON-RPC 1.0. If you're not familiar with this, take a look at the [specification ](http://json-rpc.org/wiki/specification)- it's basically an agreed-upon format for using JSON as a remote procedure call markup language. The JSON-RPC specification provides a format for performing RPC requests:
    
    {
    	"method": "subtract",
    	"params": [42, 23],
    	"id": 1
    }

and also responses to those requests:

    {
    	"result": 19,
    	"error": null,
    	"id": 1
    }

Protocols like OVSDB that choose JSON-RPC as their wire format only need to worry about implementing JSON-RPC methods (referenced in the "methods" field). Because of this, existing JSON-RPC libraries can be leveraged.

As a result, the [OVSDB specification](http://tools.ietf.org/html/rfc7047#section-4) really contains two main sections. The first section defines all of the potential JSON-RPC methods implemented by the protocol. The "transact" method, for instance is what you'd use if you want to make changes to the configuration database. However, there are other methods implemented by the specification, many of which are very useful to a client implementation, such as "get schema" (we'll get into schemas in the next section). For now, read that section of the RFC for more on what the various methods do.

One method that I've always enjoyed using is the "monitor" method. This essentially subscribes a client to receive updates whenever any of the listed tables/columns receives changes. In the event that another entity, such as libvirt, makes changes to OVS, it's important that OVSDB clients are made aware of these changes right away - there might be other things that need done in reponse to such an action:

    {
    	"method": "monitor",
    	"id": 0,
    	"params": ["Open_vSwitch",
    	null,
    	{
    		"Port": {
    			"columns": ["external_ids",
    			"interfaces",
    			"name",
    			"tag",
    			"trunks"]
    		},
    		"Controller": {
    			"columns": ["is_connected",
    			"target"]
    		},
    		"Interface": {
    			"columns": ["name",
    			"options",
    			"type"]
    		},
    		"Open_vSwitch": {
    			"columns": ["bridges",
    			"cur_cfg",
    			"manager_options",
    			"ovs_version"]
    		},
    		"Manager": {
    			"columns": ["is_connected",
    			"target"]
    		},
    		"Bridge": {
    			"columns": ["controller",
    			"name",
    			"ports"]
    		}
    	}]
    }

You can see that this follows the JSON-RPC notation we discussed earlier. In the case of the "monitor" method, we simply ensure all of the JSON-RPC fields are filled out appropriately, and for the rest of the information in "params", which contains all of the additional information needed to run this method, we adhere strictly to RFC 7047. Each method works in a similar way, but obviously with varying parameters per the specification.

For the purposes of this introduction, let's focus on the "transact" method - this is the RPC method used when an OVSDB client wants to make a change to the configuration database on an OVSDB server. This brings us to the second main section of the OVSDB specification - [database operations](http://tools.ietf.org/html/rfc7047#section-5).

OVSDB works in a very similar way to a traditional database language like SQL - and configuration information on an OVSDB server is stored in tables with rows and columns, just like most common relational database implementations out there. Just like a relational database implementation, there needs to be some kind of  standardized mechanism of interacting with the data in these tables, whatever it is.

The "database operations" section of the OVSDB specification defines these operations - and they will sound very familiar to anyone with any DBA experience in their past. The SELECT operation will retrieve rows from the table specified, INSERT will create new rows in the table specified, and DELETE will....yes, delete rows from a table. There are a few other database operations, but as with before, read the specification for more information.

And that's IT! OVSDB is nothing more than:

  * A list of specified JSON-RPC methods
  * A list of database operations to pass within one of those JSON-RPC methods

There's really not that much to OVSDB....it's what I like to call "beautifully simple", in that it is very flexible and you can do a lot with it, but in a way that's not terribly complicated. It is a very straightforward protocol.

## OVSDB Schemas

So - all of this database talk, and RPC methods, and open standards is great, but what does this have to do with networking? How does an OVSDB client use all of this to make network changes? The purpose of any database is to hold data, right? We don't invent syntaxes like SQL just for fun....we do it so that we can interact with data. In the world of OVSDB, this data comes in the form of an OVSDB schema.

The OVSDB specification intentionally leaves out any references to the data being manipulated - the writers didn't want to make any assumptions as to the particular implementation, for the sake of keeping the standard as open and flexible as possible. Can you imagine if the inventors of the SQL language mandated that certain tables and rows be created in a database in order to use the language? Laughable, indeed.

In the same way, the OVSDB specification and the tables it manipulates are very separate in their definition. Open vSwitch is easily the most common implementation of OVSDB today, and this implementation has it's own [OVSDB schema](http://openvswitch.org/ovs-vswitchd.conf.db.5.pdf), defined on it's own, outside of the OVSDB specification. Such a schema defines what tables are implemented, how they're related, and other various facts about this structure.

> This is very similar to the way Wordpress has it's own database schema, created on install. Is it the only way to use MySQL? Of course not....but it's probably very optimized for Wordpress.

[![OVSDB Schema and Table Relationships](/assets/2014/08/ovsdb2-1024x384.png)](/assets/2014/08/ovsdb2.png)

Because of this separation, you could implement a completely different schema, and still use the same old OVSDB protocol. You could even create your own schema, if none of the existing schemas fit your use case. Nothing about OVSDB prevents anyone from doing this. Again, if this were the case, it would be analogous to the SQL language dictating what kind of tables or data you can create - obviously not useful.

If you'd like to take a look at the schema being used within Open vSwitch, with all of the current rows installed, use the ovsdb-client(truncated for brevity):

    root@kvmovs-test:~# ovsdb-client dump
    Bridge table
    _uuid                                controller                             datapath_id        datapath_type external_ids fail_mode flood_vlans mirrors name     netflow other_config ports                                                                                                                                                                                                                                sflow status stp_enable
    ------------------------------------ -------------------------------------- ------------------ ------------- ------------ --------- ----------- ------- -------- ------- ------------ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ----- ------ ----------
    8c33976c-701c-40c8-80da-d5d077492d6a [3df5a221-b2cf-4226-a5b2-e7c00b6a6684] "0000000c2995abf9" ""            {}           []        []          []      "ovsbr0" []      {}           [2317f4cf-c1ad-4ef1-bbfb-784e44327fbc, 2dc41e20-1469-438d-ae8f-378cea7687de, 87e60bf7-61f8-4549-af79-f376b268b8f9, bd5021aa-abaa-4359-ba6f-0539d3b12cef, cc3dfc87-200d-4a50-be7b-31a8287f2cf0, efdd2db3-ef34-4c5a-9be5-633234c76538] []    {}     false     
    
    
    Controller table
    _uuid                                connection_mode controller_burst_limit controller_rate_limit external_ids inactivity_probe is_connected local_gateway local_ip local_netmask max_backoff role  status                                                                                               target                
    ------------------------------------ --------------- ---------------------- --------------------- ------------ ---------------- ------------ ------------- -------- ------------- ----------- ----- ---------------------------------------------------------------------------------------------------- ----------------------
    3df5a221-b2cf-4226-a5b2-e7c00b6a6684 []              []                     []                    {}           []               false        []            []       []            []          other {last_error="No route to host", sec_since_connect="600344", sec_since_disconnect="3", state=BACKOFF} "tcp:10.12.0.173:6633"
    
    Interface table
    _uuid                                admin_state cfm_fault cfm_mpid cfm_remote_mpids duplex external_ids ingress_policing_burst ingress_policing_rate lacp_current link_resets link_speed link_state mac mtu  name     ofport options other_config statistics                                                                                                                                                                                     status                                                                      type    
    ------------------------------------ ----------- --------- -------- ---------------- ------ ------------ ---------------------- --------------------- ------------ ----------- ---------- ---------- --- ---- -------- ------ ------- ------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------- --------
    dac29d3c-311f-4132-b043-6402be83a847 []          []        []       []               []     {}           0                      0                     []           []          []         []         []  []   "Jvif0"  -1     {}      {}           {}                                                                                                                                                                                             {}                                                                          ""      
    f22dc0d0-73de-4c86-842a-97f3004b9719 []          []        []       []               []     {}           0                      0                     []           []          []         []         []  []   "tap2"   -1     {}      {}           {}                                                                                                                                                                                             {}                                                                          ""      
    8050fbd5-a850-48ac-ab5b-75ca86f93380 up          []        []       []               []     {}           0                      0                     []           1           []         up         []  1500 "ovsbr0" 65534  {}      {}           {collisions=0, rx_bytes=15668271, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_over_err=0, rx_packets=344962, tx_bytes=73332545, tx_dropped=32, tx_errors=0, tx_packets=302912} {driver_name=openvswitch, driver_version="", firmware_version=""}           internal
    75ab81af-7a13-41a6-b51c-0e38b5b7c16c up          []        []       []               full   {}           0                      0                     []           0           10000000   up         []  1500 "tap0"   5      {}      {}           {collisions=0, rx_bytes=10046, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_over_err=0, rx_packets=106, tx_bytes=62775842, tx_dropped=0, tx_errors=0, tx_packets=607590}        {driver_name=tun, driver_version="1.6", firmware_version=""}                ""      
    59ffe6d4-b60d-4342-88b8-2bae621ed0d9 up          []        []       []               full   {}           0                      0                     []           0           10000000   up         []  1500 "tap1"   9      {}      {}           {collisions=0, rx_bytes=0, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_over_err=0, rx_packets=0, tx_bytes=16933852, tx_dropped=0, tx_errors=0, tx_packets=152227}              {driver_name=tun, driver_version="1.6", firmware_version=""}                ""      
    6af5851e-ea7b-4d07-a5dc-ae37f9e5cbbb up          []        []       []               full   {}           0                      0                     []           0           1000000000 up         []  1500 "eth0"   1      {}      {}           {collisions=0, rx_bytes=73486400, rx_crc_err=0, rx_dropped=2, rx_errors=0, rx_frame_err=0, rx_over_err=0, rx_packets=303698, tx_bytes=15651245, tx_dropped=0, tx_errors=0, tx_packets=344809}  {driver_name="e1000", driver_version="7.3.21-k8-NAPI", firmware_version=""} ""      

This relationship between transport and schema has been a bit confused in the past - some look at the Open vSwitch schema and draw the conclusion that OVSDB is specific to Open vSwitch ([or coin the term "OVSDB PLUS"](http://packetpushers.net/network-break-13/)). In truth, both the schema and the OVSDB transport are published specifications, and a vendor may may want to implement it's own schema to fit the use case.

> The presence of the Open vSwitch schema, as well as a neutral [Hardware VTEP schema](http://openvswitch.org/docs/vtep.5.pdf), is addressing most of the use cases for a OVSDB implementation, in my opinion.

In truth, any OVSDB implementation should be agnostic of the specific schema being used. The Helium release of OpenDaylight will have some huge improvements in this area - being completely agnostic of which schema is used.

## OVSDB Myths

I considered putting this list at the beginning, since they are a bit irritating to me, but I'm glad I provided a little context first. Nevertheless, I've seen a lot of misinformation out there about OVSDB, and I'd like to provide a list of myths I've heard, and my response to them:

  * **"OVSDB was invented by VMware, and only VMware can use it"** -- OVSDB is a network configuration protocol, as open as any other protocol. It is not inherently specific to VMware, or to Open vSwitch. There are [software](https://wiki.opendaylight.org/view/OVSDB_Integration:Main) as well as [hardware](http://www.slideshare.net/CumulusNetworks/vmware-nsx-cumulus-networks) switch implementations of OVSDB outside of VMware, even today. Much of the confusion here likely is because Open vSwitch is the most common implementation of OVSDB (specifically, ovsdb-server). This doesn't mean OVS contains the ONLY implementation of OVSDB, however.
	
  * **"OVSDB forces lowest-common-denominator functionality"** -- Hearing or seeing this phrase makes me immediately question the credibility of whoever wrote or said it. This phrase is a common attack against OpenFlow, since OpenFlow is aimed at abstracting diverse, proprietary forwarding pipelines. Even when used to describe OpenFlow, this phrase is wildly open to interpretation. Using it AND confusing OpenFlow with OVSDB at the same time demonstrates a bit of ignorance. I am ashamed to admit I have heard this multiple times, from multiple sources.

  * "**Using OVSDB means you have to use OpenFlow (or vice versa)**" -- This is untrue. Neither protocol requires the other. OpenFlow requires some kind of configuration protocol, since it is not able to - for instance - turn up/down a port, but this does not have to be OVSDB. Could be manual configuration, NETCONF, OF-CONFIG, etc. The point is these two protocols are not as married as some would have you believe.

  * "**Central points of management like an OVSDB-based controller introduces a single point of failure**" -- This myth represents a fundamental misunderstanding of the difference between the control and management planes on a network. Using a centralized point of management to control switch configuration using OVSDB does not introduce a single point of failure. Configuration elements do not magically disappear when the controller running OVSDB goes down. Again, this seems to be an unfortunate confusion between OpenFlow and OVSDB.

My words, however, pale in comparison to those of Ben Pfaff, OVSDB's creator. OVSDB in 140 characters:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/colinmcnamara">@colinmcnamara</a> <a href="https://twitter.com/virtualswede">@virtualswede</a> <a href="https://twitter.com/scott_lowe">@scott_lowe</a> <a href="https://twitter.com/mcowger">@mcowger</a> OVSDB is a database. You can use it to configure a switch or track your stamp collection.</p>&mdash; Ben Pfaff (@Ben_Pfaff) <a href="https://twitter.com/Ben_Pfaff/status/453333818653417472">April 8, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The point of this post is to stay true to the facts. There are many other considerations to make when designing a programmable network, all of which depend entirely on the big picture business drivers, and is obviously out of scope for this blog post. The point of this post was to stay out of the religion, and keep everyone honest.

## Conclusion

I left out a few details because one of my OVSDB mentors Brent Salisbury covers so much more in [his post](http://networkstatic.net/getting-started-ovsdb/). He, and the rest of the community have been awesome resources to rely on as I get more and more involved in software development. The #opendaylight-ovsdb and #openvswitch IRC channels on freenode are fantastic places to hang out and get more ideas.

Hopefully I whet your appetite for more knowledge, and straightened out any misconceptions you may have had. Thanks for reading, and stay tuned for more in this series!