---
layout: post
title: Cisco NX-API 1.0 Update
author: Matt Oswalt
comments: true
categories: ['Code']
date: "2014-10-08"
wordpress_id: 5948
slug: cisco-nxapi-10-update
tags: ['cisco']
---


If you weren't paying attention, it was easy to miss. NX-API, Cisco's new JSON/XML switch API is now shipping as version 1.0. NX-API originated on the Nexus 9000 platform created by the Insieme group, and I've explored this [in detail before](https://keepingitclassless.net/2014/02/cisco-aci-nexus-9000-nxapi/).

In review, NX-API is a new, programmatic method of interacting with a Cisco Nexus switch. In many ways, Cisco is playing catch-up here, since this interface is really just a wrapper for the CLI (admittedly with some convenient output parsing), and most of their competitors have had similar interfaces for a while. Nevertheless, it is better than scraping an SSH session, so it's worth looking into.

I'd like to go over a few new things you should know about if you are or will be working with this interface.

## NX-API 1.0 Updates

From a strictly API perspective, not a lot seems to have changed. I would be more specific, but as of yet I've been unable to find release notes from Cisco on what's changed from 0.1 to 1.0. If I ever find something like this, I'll get my hands on it - part of publishing a good API means publishing good documentation, and Cisco would be wise to make such information really easy to find.

One thing that is definitely new is the introduction of JSON-RPC as an option for communication. In summary, JSON-RPC is a standardized format of communicating information bidirectionally using JSON.

Previously, NX-API was limited to a proprietary XML or JSON structure specific to NX-API. Those options still exist, but the introduction of JSON-RPC (NX-API uses the JSON-RPC 2.0 standard) means that existing JSON-RPC libraries can be leveraged, rather than writing everything from scratch.

> I am looking into several Python-based JSON-RPC libraries, and will provide more information in another post. This post will focus instead on what the sandbox suggests for us, which is statically defined JSON-RPC markup, and the very popular and easy to use "requests" library.

The JSON-RPC mechanism with NX-API simplifies a few things. No longer do we have to specify "cli_show" or "cli_conf" to indicate if we want to run a command in configure mode. We simply send a command, and the switch is smart enough to figure out what we need to do. This is made possible with the "cli" JSON-RPC method. The only other method supported at this time is "cli_ascii" which provides the output of the command you sent in plain, unparsed text. This means that at this time, you can't use JSON-RPC to run Bash commands on the switch.

Here's an example of a JSON-RPC 2.0 structure you might send to the switch to get a list of OSPF neighbors:
    
    [
      {
        "jsonrpc": "2.0",
        "method": "cli",
        "params": {
          "cmd": "show ip ospf nei",
          "version": 1
        },
        "id": 1
      }
    ]

and the response from the switch:
    
    {
      "jsonrpc": "2.0",
      "result": {
        "body": {
          "TABLE_ctx": {
            "ROW_ctx": {
              "ptag": "CLOS",
              "cname": "default",
              "nbrcount": 2,
              "TABLE_nbr": {
                "ROW_nbr":
                  {
                    "rid": "172.16.3.1",
                    "priority": 1,
                    "state": "FULL",
                    "uptime": "P4DT16H27M6S",
                    "addr": "192.168.10.1",
                    "intf": "Po100"
                  }
              }
            }
          }
        }
      },
      "id": 1
    }

As you can see, the content provided in the response, under the "result" tag, is all the same NX-API stuff we've seen before. So a lot of the code that we've been working on to parse this structure will still apply. Really, JSON-RPC just brings a small level of standardization to this mechanism. There is more that can be done, but it is a standardized format, and therefore a step in the right direction.

I was pleased to get a comment on this article, pointing out that there are two valid ways to send JSON-RPC params, and that NX-API supports both of them. The first is what the sandbox will suggest to you, a JSON object that specifies the parameters in "dictionary" form:
    
    [{
        "params": {
            "cmd": "show ip ospf nei",
            "version": 1
        },
        "jsonrpc": "2.0",
        "method": "cli",
        "id": "1"
    }]

You are also able to submit the params in an (assumed) ordered list:
    
    [{
            "jsonrpc": "2.0",
            "method": "cli",
            "params": ["show ip int br", 1],
            "id": 1
    }]

For more info on parameters in JSON-RPC 2.0, check the specification, under the section labeled "[Parameter Structures](http://www.jsonrpc.org/specification#parameter_structures)". That's the part of the spec I'm referring to.

There are a few limitations in the JSON-RPC implementation present in NX-API 1.0. First, [the issue I brought up about "multiples"](https://keepingitclassless.net/2014/07/handling-multiples-cisco-nx-api/) still exists. Not a huge deal, but you will have to continue to handle the difference in JSON described in that post, even when using this new JSON-RPC functionality.

Also as mentioned before, there is no JSON-RPC method for accessing the bash shell, so if you want to send those commands, you'll have to use the traditional XML/JSON interface.

None of these limitations are huge showstoppers, just things to watch out for as you build code to consume this API. Overall, it's clear the API is showing progress, and progress is always good.

As I mentioned, there really isn't any documentation on NX-API generically, only specific switch implementations. So for now, refer to the [Nexus 9000 programmability guide](http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/6-x/programmability/guide/b_Cisco_Nexus_9000_Series_NX-OS_Programmability_Guide/b_Cisco_Nexus_9000_Series_NX-OS_Programmability_Configuration_Guide_chapter_0101.pdf).

## New NX-API Sandbox

The NX-API sandbox has also been re-vamped (and it looks MUCH better). Here's the sandbox present on older versions of code, and what was provided on the initial launch of Nexus 900:

[![nxapi1](assets/2014/10/nxapi1-1024x637.png)](assets/2014/10/nxapi1.png)The new sandbox looks much better:

[![nxapi2](assets/2014/10/nxapi2-1024x715.png)](assets/2014/10/nxapi2.png)

Again - you'll only use this sandbox to test requests. This is not a very useful tool for experienced developers, but for those that are looking to get into how an API works, and using it to make switch configurations, it's a great place to start.

If you look at the request box, not only does the new sandbox provide the JSON-RPC, JSON or XML required to form the request, it can also provide you with a snippet of Python code that utilizes the core "requests" library to make the request on your own machine.

[![nxapi3](assets/2014/10/nxapi3.png)](assets/2014/10/nxapi3.png)

This is useful for those that are new to Python and making REST calls.

## NX-API: Now on the Nexus 3000!

I also wanted to call out the fact that NX-API has FINALLY made it's way to another switch platform. The Nexus 3000 was the first switch series to receive the blessings of NX-API outside of the intial 9000 line. There don't appear to be any differences between the implementations - hopefully there are none. Again, without a published NX-API "standard" it's hard to tell. For features present on the 3000 series that are not present on the 9000 series, there are likely unique data structures for those features, obviously.

Read more on the [Nexus 3000 programmability guide](http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus3000/sw/programmability/6_x/b_Cisco_Nexus_3000_Series_NX-OS_Programmability_Guide.pdf) - NX-API was introduced to the Nexus 3000 series starting with [NX-OS 6.0(2)U4(1)](http://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus3000/sw/release/602_U_4/n3k_rel_notes_6_0_2_u4_1.html#pgfId-528407).