---
layout: post
title: The Benefit of Infrastructure APIs
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-09-18"
wordpress_id: 4639
slug: the-benefit-of-infrastructure-apis
tags: ['api']
---


A lot of networking folks have heard of the concept of an API but have been too easily discouraged when they realize many of their favorite platforms don't really have a good one. As a result, the scripting-savvy networking guy is typically relegated to what I lovingly refer to as "SSH scraping", or the act of making a really nice script that, after it's all said and done, just sends SSH commands to the devices in the same way that a human would, only......faster.

> By the way this is essentially the same concept as screen-scraping, the generally accepted term for artificially crafted HTTP requests, emulating a human being. See what happens when you don't give us a proper API?

Let's say you've built a function (or used someone else's) that allows you to easily send and receive telnet traffic (telnet's used here for simplicity but also applies to SSH). If you wanted to retrieve the OSPF database on a router, you could run the relevant command inside your favorite terminal emulator, and get it:

    R1#show ip ospf data
    
                OSPF Router with ID (10.20.31.1) (Process ID 1)
    
                    Router Link States (Area 0)
    
    Link ID         ADV Router      Age         Seq#       Checksum Link count
    10.20.31.1      10.20.31.1      1117        0x80000004 0x001DDE 2
    172.16.3.1      172.16.3.1      1117        0x80000004 0x007474 2
    
                    Net Link States (Area 0)
    
    Link ID         ADV Router      Age         Seq#       Checksum
    10.20.31.1      10.20.31.1      1117        0x80000001 0x005B63
    
                    Summary Net Link States (Area 0)
    
    Link ID         ADV Router      Age         Seq#       Checksum
    172.16.0.0      172.16.3.1      1127        0x80000001 0x005170
    R1#

Of course, if you're trying to replace yourself with a script, this is exactly the same information that your script will receive. It's literally even formatted this way on a line-by-line basis, as shown in the packet capture:

[![screen1](/assets/2013/09/screen1.png)](/assets/2013/09/screen1.png)

Anyone with a decent amount of coding experience will know that this isn't exactly optimal. The reason for this is called object-oriented programming (OOP). In properly designed software, we would want to create an "object" of type "LSA" or something like that, and give that object properties like "type", "link ID", "age", and so on. This allows us to access the list of LSAs through an array, and access each LSA's properties very easily by simply referring to them.

Here's a little bit of pseudocode to convey the general idea:

    #LSAList is an array that will be populated with our LSA "objects"
    LSAList = []
    
    #getLSAList() is some function that reaches out to some router with a fancy API and
    #uses the function that returns a nicely formatted list of LSAs 
    LSAList = getLSAList("192.168.0.1")
    
    #This function iterates through the objects in the array and outputs each LSA's 
    #"advertising router" or "advRouter" property.
    for LSA in LSAList:
    	echo $LSA.advRouter;

As you can see, this is really cool and quite simple. However if using something like SSH or telnet scraping, there's another step we have to take to even get to this point. We would have to employ a software tactic known as "parsing", which is using string functions to pick out the data that we want from the output generated. We probably don't want all of those "/r/n" blogs in there, nor do we want the titles for each column. We really only want the values, and we want to keep track of which LSA each value belongs to.

Is it possible to do this with parsing? Don't be so fast to underestimate the tenacity and diligence of the desperate coder - while it is truly a pain, and very difficult to manage (all bets are off if the vendor changes output even a little bit) it is possible. Feasible even, if it's your only option.

One way that software vendors can make this easier on us is by returning the data in a format that's already well-understood. Technically it might still be parsing, but the parsing would be done by a library that's existed for a long time and has all of the necessary tools to make it non-visible to the person writing the code.

XML is a great example of this. In lieu of the telnet output we saw earlier, here's a snippet of XML I wrote up that I'd like to see instead:

{{< highlight xml >}}    
    <?xml version="1.0" ?> 
    <lsaList>
    	<lsa>
    		<lsaArea>0</lsaArea>
    		<lsaType>1</lsaType>
    		<lsaLinkID>10.20.31.1</lsaLinkID>
    		<lsaADVRouter>10.20.31.1</lsaADVRouter>
    		<lsaAge>1117</lsaAge>
    		<lsaSeq>0x80000004</lsaSeq>
    		<lsaChecksum>0x001DDE</lsaChecksum>
    		<lsaLinkCount>2</lsaLinkCount> 
    	</lsa>
    		<lsa>
    		<lsaArea>0</lsaArea>
    		<lsaType>1</lsaType>
    		<lsaLinkID>172.16.3.1</lsaLinkID>
    		<lsaADVRouter>172.16.3.1</lsaADVRouter>
    		<lsaAge>1117</lsaAge>
    		<lsaSeq>0x80000004</lsaSeq>
    		<lsaChecksum>0x007474</lsaChecksum>
    		<lsaLinkCount>2</lsaLinkCount> 
    	</lsa>
    	<lsa>
    		<lsaArea>0</lsaArea>
    		<lsaType>2</lsaType>
    		<lsaLinkID>10.20.31.1</lsaLinkID>
    		<lsaADVRouter>10.20.31.1</lsaADVRouter>
    		<lsaAge>1117</lsaAge>
    		<lsaSeq>0x80000001</lsaSeq>
    		<lsaChecksum>0x005B63</lsaChecksum>
    		<lsaLinkCount></lsaLinkCount> 
    	</lsa>
    </lsaList>
{{< /highlight >}}

This may look more complicated, but it's much better from a programmatic perspective. First off, it's already hierarchical (most API languages like JSON are) so we don't have to figure out whether or not a line is defining an LSA, or one of it's properties.

The other benefit is quick lookup. Most XML parsing libraries allow you to do cool stuff like iterate through the markup and output all nodes labeled "lsaSeq" for instance. Makes for some pretty fast lookups. As mentioned before, much of this can be done through manual parsing, but the point is to create an open interface that's widely understood and can be used immediately. Markup like XML and JSON allow us to do that.

Armed with this knowledge, go call up your favorite account manager and ask him/her to get proper APIs baked into the platforms you want to buy from them!
