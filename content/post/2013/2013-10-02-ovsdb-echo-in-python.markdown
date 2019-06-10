---
layout: post
title: OVSDB Echo in Python
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2013-10-02"
wordpress_id: 4712
slug: ovsdb-echo-in-python
tags: ['code']
---


I don't mind coding in Java (i.e. OpenDaylight) but I wanted something quick and easy, so I'm writing a utility-esque script that sacrifices extensibility for speed. And since Python is something I've been meaning to stretch my muscles in, I decided to throw this together.

> Keep in mind that this can all be done by ovsdb-client natively via Linux command line, but I wanted to write it in Python to learn it, as well as provide it for a cool (technically) cross-platform language.

Simple idea, send an OVS echo function through JSON-RPC to the address and port of your choice. Assumes you've already set up OVS to listen passively on an interface for manager OVSDB requests:
    
    ovs-vsctl set-manager ptcp:6634:10.12.0.30

Suggestions welcome.

{{< highlight python >}}
import socket
import json
import time
 
def pingOVS(HOST, PORT):
    
    #Create socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 
    #Establish TCP session via IP address and port specified
    s.connect((HOST, PORT))
 
    #Send JSON to socket
    print "Sending echo request =====>"
    s.send(json.dumps({'method':'echo','id':'echo','params':[]}))
 
    #Wait for response and print to console
    result = json.loads(s.recv(1024))
    print "<========" + str(result)
    time.sleep(2)
 
while True:
    pingOVS("10.12.0.30", 6634)
 
#Exit
s.close()
{{< /highlight >}}

[![python](/assets/2013/10/python.png)](/assets/2013/10/python.png)




