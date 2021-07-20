---
layout: post
title: Cisco Nexus 9000 NX-API
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2014-02-18"
wordpress_id: 5520
slug: cisco-aci-nexus-9000-nxapi
tags: ['9000']
---


A robust built-in API is not something you traditionally see in a Cisco router or switch. My first experience with anything like this on Cisco was with Unified Computing System. Though it's a high-level API that interacts only with the UCSM application managing the entire stack, it's still a robust way to configure policy and resources within UCS.

ACI is recieving the same treatment, and though it's true that there will be a slew of programmability options built into the APIC controller that is the cornerstone of the ACI fabric that we'll be hopefully seeing later this year, there are also some very cool options on each individual switch in NXOS or Standalone mode as well. This series will cover the latter, since ACI mode is not yet available.

## NXAPI Resources

First thing you need to do is download the [N9K Programmability Guide](http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/6-x/programmability/guide/b_Cisco_Nexus_9000_Series_NX-OS_Programmability_Guide.html). Here, you'll learn about NXAPI, the official name for the XML and JSON based API present on each Nexus 9000 (this post will use a Nexus 9508 modular switch). In summary, you can send either JSON or XML data in the formats we'll explore in this post, and receive either JSON or XML back as well (you can specify your preference in the initial call).

Here's a video to get you started:

<div style="text-align: center"><iframe width="560" height="315" src="http://www.youtube.com/embed/0MGnUnIv3oU" frameborder="0" allowfullscreen></iframe></div>

As I state in the video, XML seems to be more supported. JSON is supported but there are some limitations you should be aware of. These are called out in the programmability guide. I will probably be sticking with XML going forward, since I convert everything to a dictionary in the example I'll go into shortly.

Second, I highly recommend you check out the [Nexus 9000 GitHub page](https://github.com/datacenter/nexus9000/). There, you'll find a myriad of examples for using this API, as well as others. I will be referring heavily to code found there in this post. The moderators of the page state that they accept contributions, so [I submitted a small example script](https://github.com/datacenter/nexus9000/blob/master/nx-os/nxapi/utils/RoutingTable.py) that uses the NXAPI to generate a local data structure for the device's routing table. This file contains a lot of the code I'll be talking about in this post.

## Example: Pull N9K Routing Table into Python Data Structures

> TL;DR at the end. :)

I've mentioned this generically in a past post, but in terms of a specific example, let's say we wanted to pull the full routing table from a N9K. With the tools available to most "common" Cisco switches or routers, we have to write a script, SSH in , and perform some kind of scraping of this data. Not ideal. I show in the above video why we need the data to be presented to us in a format that's more easily consumable, so we don't have to do this parsing ourselves. Here's what we have to work with if we use this "old" method:

    9KA# show ip route
    
    172.16.1.0/30, ubest/mbest: 1/0, attached
        *via 172.16.1.2, Po1, [0/0], 1d13h, direct
    172.16.1.2/32, ubest/mbest: 1/0, attached
        *via 172.16.1.2, Po1, [0/0], 1d13h, local
    172.16.3.1/32, ubest/mbest: 1/0
        *via 172.16.1.1, Po1, [110/2], 1d13h, ospf-1, intra
    172.16.33.1/32, ubest/mbest: 1/0
        *via 172.16.1.1, Po1, [110/2], 1d13h, ospf-1, inter
    172.16.41.1/32, ubest/mbest: 1/0
        *via 172.16.1.1, Po1, [110/2], 1d13h, ospf-1, inter

A big block of text. Not exactly the easiest way to get a list of routes, and easy to access properties, like metric, etc. We'd have to parse through this text to get to that point.

In order to get this data through the API, we will connect to the switch programmatically and send a request for it. The maintainers of the Cisco "datacenter" group on GitHub have done a great job of providing a lot of the "framework-y" code for us to use so that we can get to the meaty stuff right away. The [nxapi_utils.py](https://github.com/datacenter/nexus9000/blob/master/nx-os/nxapi/utils/nxapi_utils.py) script provides us with the means to do this. In my own script, I import this file and use the NXAPI class to send a request of my own:

    from nxapi_utils import *
    
    thisNXAPI = NXAPI()
    thisNXAPI.set_target_url('http://10.1.1.1/ins')
    thisNXAPI.set_username('admin')
    thisNXAPI.set_password('cisco')
    thisNXAPI.set_msg_type('cli_show')
    thisNXAPI.set_cmd('show ip route')
    returnData = thisNXAPI.send_req()
    
    print returnData #This will output the entire XML response

If you run that, you'll get this (I only included one prefix for brevity, but you get the point):

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

Now - for those that don't write a lot of code, I'm sure this looks WORSE. After all, there's a lot more text here. However, from a programmatic standpoint, this is a lot better. Whether it's XML or JSON, having your data organized into fields like this for you is a tremendous help.

To make it even easier, we can use [another Cisco-provided utility](https://github.com/datacenter/nexus9000/blob/master/nx-os/nxapi/utils/xmltodict.py) to throw all of this XML data into a big dictionary object (I was new to python dictionaries as well, I recommend reading up [here](http://docs.python.org/2/tutorial/datastructures.html#dictionaries)) that organizes everything into key-value pairs.

{{< highlight python  >}}
    doc= xmltodict.parse(returnData[1]) #Throw the returned XML from previous example to add it to xmltodict
    
    #A quick but ugly way to cut through a lot of the extra crap and get straight to the IPv4 routes. So for now, it's IPv4-only and default VRF only. More work to do here.
    for k ,v in doc['ins_api']['outputs']['output']['body']['TABLE_vrf']['ROW_vrf']['TABLE_addrf']['ROW_addrf']['TABLE_prefix'].iteritems():
            docsub = v
{{< /highlight >}}


At the end of this, "docsub" should be a dictionary object containing all of the routes prefixes in the RIB, and under each route prefix, the various next-hop solutions.

Object-oriented programming can lend us a hand here. Before we delve into getting the data out of this dictionary, let's write a few classes describing the data we want to retrieve:

{{< highlight python  >}}
class Prefix:
    '''A class to define a route prefix'''
    def __init__(self):
        self.ipprefix = ''
        self.ucast_nhops = ''
        self.mcast_nhops = ''
        self.attached = False
        self.nexthops = []

class NextHop:
    '''A class to define a next-hop route. Meant to be used in an array within the Prefix class'''
    def __init__(self):
        self.ipnexthop = ''
        self.ifname = ''
        self.uptime = ''
        self.pref = 0
        self.metric = 0
        self.clientname = ''
        self.hoptype = ''
        self.ubest = True
{{< /highlight >}}


These are merely custom data structure to describe a route prefix and the next-hop solutions under each prefix (note that the latter is meant to be used in an array inside the former). Will make it tremendously easier to access the data, as you'll see at the end of this post.

Next we need to extract the data from this dictionary and create instances of the classes we just put out. I'll write two methods, one for each class type, and both are responsible for creating a class object based off of the information in the dictionary.

> BIG thanks to [Kirk Byers](https://twitter.com/kirkbyers) for helping me write this out in the most efficient way.
    
{{< highlight python  >}}
def process_nexthop(next_hop):
    '''Processes nexthop data structure'''
    if not 'ipnexthop' in next_hop:
        # Ignore prefixes with no next hop - not attached?
        return None
    nexthop_obj = NextHop()
    for t_key,t_val in next_hop.iteritems():
        # use setattr to set all of the object attributes
        setattr(nexthop_obj, t_key, t_val)
    return nexthop_obj

def process_prefix(prefix_row):
    '''Takes a prefix from ACI XML call and parses it'''
    prefix_obj = Prefix()
    for k,v in prefix_row.iteritems():
        # Check for TABLE_path (nested next_hop structure)
        if k == 'TABLE_path':
            # Next hop is embedded in ['TABLE_path']['ROW_path']
            nexthop_obj = process_nexthop(v['ROW_path'])
            if not nexthop_obj == None:
                prefix_obj.nexthops.append(nexthop_obj)
        else:
            # Swap hyphen for underscore in field names
            k = k.replace('-', '_')
            # use setattr to set all of the object attributes
            setattr(prefix_obj, k, v)
    return prefix_obj
{{< /highlight >}}    

Once this is done, we can VERY easily create a list of these objects (called 'routes'), populate that list using our earlier defined methods, and then iterate through that list to print out its content. I used the IP prefix and the next hop as an example:

{{< highlight python  >}} 
routes = []

    for prefix_row in docsub:           #executes once for every prefix
        this_prefix = process_prefix(prefix_row)
        routes.append(this_prefix)

    # Print out routes
    for route in routes:
        print "The route to ", route.ipprefix, " has ", len(route.nexthops), " next-hop solutions"
        for nexthop in route.nexthops:
            print "via ", nexthop.ipnexthop, "out of", nexthop.ifname
{{< /highlight >}}

Here is the output from all that:

    The route to  172.16.1.0/30  has  1  next-hop solutions
    via  172.16.1.2 out of Po1
    The route to  172.16.1.2/32  has  1  next-hop solutions
    via  172.16.1.2 out of Po1
    The route to  172.16.3.1/32  has  1  next-hop solutions
    via  172.16.1.1 out of Po1
    The route to  172.16.33.1/32  has  1  next-hop solutions
    via  172.16.1.1 out of Po1
    The route to  172.16.41.1/32  has  1  next-hop solutions
    via  172.16.1.1 out of Po1
    [Finished in 0.7s]

## Conclusion

Okay so maybe I geeked out a little bit, but hopefully you stuck with me until the end and saw that this is a very dynamic and easy to use method for retrieving data from the Nexus 9000 switch. You could do all kind of things with this data - maybe make routing changes once this data is in a nice array like above, or maybe just log changes to the routing table as they happen. The possibilities are endless. The important thing is that Cisco now has parity with other vendors that have been offering this type of API for a while.

I hope this was useful - stick around for more posts on the Nexus 9000 series as well as the entire Cisco ACI family!
