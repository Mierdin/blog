---
layout: post
title: Handling "Multiples" in Cisco NX-API with Python
author: Matt Oswalt
comments: true
categories: ['Code']
date: "2014-07-24"
wordpress_id: 5903
slug: handling-multiples-cisco-nx-api
tags: ['code']
---


A few weeks ago, I was working with the NX-API currently found on Cisco's Nexus 9000 series switches, and ran into some peculiar behavior.

NX-API returns all information in terms of Tables and Rows. For a specific example, let's look at what NX-API returns when I ask the switch for running OSPF processes:

> There's actually a lot more information in this snippet that pertains to the OSPF process itself, but I have omitted it for brevity. This specific example focuses on the section that describes the areas in this OSPF process.

    {
      "ins_api": {
        "sid": "eoc",
        "type": "cli_show",
        "version": "0.1",
        "outputs": {
          "output": {
            "code": "200",
            "msg": "Success",
            "input": "show ip ospf",
            "body": {
              "TABLE_ctx": {
                "ROW_ctx": {
                  ### OSPF process information omitted for brevity ###
                  "TABLE_area": {
                    "ROW_area": {
                      "age": "P15DT15H27M6S",
                      "loopback_intf": "1",
                      "passive_intf": "0",
                      "last_spf_run_time": "PT0S",
                      "spf_runs": "9",
                      "lsa_cnt": "5",
                      "no_summary": "false",
                      "backbone_active": "true",
                      "stub": "false",
                      "aname": "0.0.0.0",
                      "total_intf": "2",
                      "auth_type": "none",
                      "act_intf": "2",
                      "nssa": "false",
                      "lsa_crc": "0x18d91"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
NXAPI uses a special tag that starts with TABLE, and within that, tag(s) that start with ROW, whenever it needs to describe something that would normally be listed - things like OSPF processes, entries in the routing table, .

In the above example, when you look at the output of “show ip ospf”, all OSPF processes fall under the tag TABLE_ctx, and each process gets it's own dictionary under the ROW_ctx tag. The same applies to that process' areas (shown under TABLE_area). Fairly straightforward.

If I configure a new OSPF area within this instance and re-run the command, I get this response:

    {
      "ins_api": {
        "sid": "eoc",
        "type": "cli_show",
        "version": "0.1",
        "outputs": {
          "output": {
            "code": "200",
            "msg": "Success",
            "input": "show ip ospf",
            "body": {
              "TABLE_ctx": {
                "ROW_ctx": {
                  ### OSPF process information omitted for brevity ###
                  "TABLE_area": {
                    "ROW_area": [
                      {
                        "age": "P15DT8H18M55S",
                        "loopback_intf": "1",
                        "passive_intf": "0",
                        "last_spf_run_time": "PT0S",
                        "spf_runs": "8",
                        "lsa_cnt": "5",
                        "no_summary": "false",
                        "backbone_active": "true",
                        "stub": "false",
                        "aname": "0.0.0.0",
                        "total_intf": "2",
                        "auth_type": "none",
                        "act_intf": "2",
                        "nssa": "false",
                        "lsa_crc": "0x2194b"
                      },
                      {
                        "nssa": "false",
                        "age": "PT5S",
                        "loopback_intf": "0",
                        "passive_intf": "0",
                        "last_spf_run_time": "PT0S",
                        "spf_runs": "1",
                        "lsa_cnt": "0",
                        "no_summary": "false",
                        "stub": "true",
                        "aname": "0.0.0.1",
                        "total_intf": "0",
                        "auth_type": "none",
                        "act_intf": "0",
                        "stub_def_cost": "1",
                        "active": "false",
                        "lsa_crc": "0"
                      }
                    ]
                  }
                }
              }
            }
          }
        }
      }
    }

If you're writing some Python to interact with these switches, you may encounter issues when you retrieve information in this way. Look carefully at the ROW_area tag - you'll notice in the first example that the child of this tag is just a single dictionary with all of the key/value pairs that pertain to the single OSPF area being displayed. In the second example, after I added a second OSPF area to the configuration, there are multiple dictionaries (one per area) contained within a list (the bracket [] notation in the JSON is what denotes this list)

## Python

Let's look at a small Python snippet that pulls this stuff down into a Python dictionary.

> In this example I'm using my own modified fork of the NX-API serialization code provided by the Cisco team [here](https://github.com/datacenter/nexus9000) but you could use your own XML or JSON tool as well.

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
    
    #print the area ID
    print returnDict['ins_api']['outputs']['output']['body']['TABLE_ctx'] 
            ['ROW_ctx']['TABLE_area']['ROW_area']['aname']
{{< /highlight >}}

With a single area in the switch - which is reflected in the first JSON example from earlier, this works. I can refer directly down into the dictionary that I want, and the output is a simple "0.0.0.0".

However, if I add an area, as shown in the second JSON example, I encounter a TypeError exception:

    ~ $ python nxapi_ospf.py
    Traceback (most recent call last):
      File "nxapi_ospf.py", line 21, in <module>
        ['ROW_ctx']['TABLE_area']['ROW_area']['aname']
    TypeError: list indices must be integers, not str

This is because, when there are multiple areas, the value type of the ROW_area changes from a dictionary to a list (which contains multiple dictionaries). So lets change it up a little bit to handle this list:

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
    
    #iterate through the list at ROW_area and print each area ID
    for area in returnDict['ins_api']['outputs']['output']['body']['TABLE_ctx'] 
            ['ROW_ctx']['TABLE_area']['ROW_area']:
        print area['aname']
{{< /highlight >}}

The above Python will successfully print our areas, but if we go back to a single area, we get another TypeError:

    ~ $ python nxapi_ospf.py
    Traceback (most recent call last):
      File "nxapi_ospf.py", line 21, in <module>
        print area['aname']
    TypeError: string indices must be integers

So the best long-term fix would be to simplify the source of this information - the JSON provided to us by the API. My preference would be to make all tags that start with ROW provide a datatype of list (with the bracket notation) regardless of how many dictionaries are contained within - even zero. I'd be able to use a loop to iterate through the items regardless of how many there are.

However, that's just not the case right now - so this is fairly easy to fix with Python. We can use the traditional Pythonic method when it comes to data types - "it is better to ask for forgiveness than for permission". This is another way of saying that for examples like this, we should proceed with the code that addresses the most popular use case, but use error handling to take care of times when the data is not provided in the type you expected. For example:

{{< highlight python  >}}
    #!/usr/bin/env python2.7
    
    from cisco.nxapi.nxapiutils.nxapi_utils import NXAPI
    import json
    
    #Create new NXAPI connection
    thisNXAPI = NXAPI()
    thisNXAPI.set_target_url('http://10.2.1.8/ins')
    thisNXAPI.set_username('admin')
    thisNXAPI.set_password('Cisco.com')
    thisNXAPI.set_out_format('json')
    thisNXAPI.set_msg_type('cli_show')
    
    #send command and create a dictionary to hold the response JSON
    thisNXAPI.set_cmd('show ip ospf')
    returnDict = json.loads(thisNXAPI.send_req()[1])
    
    try:
        #Assume the data type is a list
        #iterate through the list at ROW_area and print each area ID
        for area in returnDict['ins_api']['outputs']['output']['body'] 
                ['TABLE_ctx']['ROW_ctx']['TABLE_area']['ROW_area']:
            print area['aname']
    except TypeError:
        #The data type is NOT a list - need to handle like a single dictionary
        print returnDict['ins_api']['outputs']['output']['body'] 
            ['TABLE_ctx']['ROW_ctx']['TABLE_area']['ROW_area']['aname']
{{< /highlight >}}

This way I can use the same snippet of Python regardless of how many areas there are. I am using the same approach whenever there's the potential for multiple "things". It's not that hard, and frankly it's a popular way to handle this problem in Python.

Hope this was useful!
