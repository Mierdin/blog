---
layout: post
title: 'BGP: Weight and Local-Preference'
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2011-09-26"
wordpress_id: 1491
slug: bgp-weight-and-local-preference
tags: ['bgp']
---


It's important to remember that since BGP is the routing protocol of the internet, there are quite a few attributes that it uses to give preference to a single route out of several redundant paths to a given destination.

I was recently contemplating several of these and it occurred to me that two of these attributes in particular are pretty similar. I'd like to compare and contrast them and give reasoning for situations that call upon one or the other.

I'll be referring to this diagram throughout the article, use it for reference. We'll be trying to use weight and local preference to modify the default routing behavior from R1 to a remote network not pictured that's available through both R2 or R3.

[![](/assets/2011/09/diagram6.png)](/assets/2011/09/diagram6.png)

## Weight

First, I'd like to discuss the "WEIGHT" attribute. This is a cisco-proprietary attribute that is really just a marker placed **on a per-neighbor basis** that instructs the local router that it should prefer routes that it receives from that neighbor, if there is a tie.

Take a look at a sample BGP table:
    
    R1# show ip bgp                                     
    
       Network          Next Hop            Metric LocPrf Weight Path
    *>i200.50.2.1/32    10.1.13.2                0    100      0 777 711 i
    * i                 10.1.12.2                0    100      0 777 911 711 i
    *>i200.60.2.1/32    10.1.13.2                0    100      0 777 711 i
    * i                 10.1.12.2                0    100      0 777 911 711 i

The first thing you should notice is that we're receiving two networks via BGP. Both of these networks offer redundant routes - that is to say we can reach those networks via one of two possible routes, through R2 or R3. These two routers are BGP neighbors of R1.

The carot ">" indicates the routes given to us by R3 (10.1.13.2) have been placed in the routing table. The first two attributes that are checked when two redundant paths are found are weight and local preference, which we'll discuss soon. These are both tied, so the route that goes through fewer autonomous systems is chosen, which is what R3 can offer us. That's why the routes through that neighbor are preferred.

Since this is essentially default behavior, we want to be able to change this functionality by giving more weight to the OTHER neighbor. Sometimes this isn't desired, but perhaps we can somehow guarantee that despite the fact that the route through R2 (10.1.12.2) goes through more autonomous systems, it is better because the links are faster, or something. Whatever your reason, this is a situation that warrants a "weight" change.

It's a simple process to change the weight, but remember that it is applied to the entire neighbor, so that all routes through that neighbor are given the same weight.
    
    R1(config-router)#neighbor 10.1.12.2 weight 300

It doesn't have to be 300 - I chose it randomly, more or less. The important thing is that it is higher than the other neighbors. Let's check the BGP table once more to see how our changes impacted things:
    
    R1# show ip bgp
    
       Network          Next Hop            Metric LocPrf Weight Path
    *>i200.50.2.1/32    10.1.12.2                0    100    300 777 911 711 i
    * i                 10.1.13.2                0    100      0 777 711 i
    *>i200.60.2.1/32    10.1.12.2                0    100    300 777 911 711 i
    * i                 10.1.13.2                0    100      0 777 711 i

You'll have to look at the next-hop to notice the changes, but if you do, you'll notice that the next-hop has changed to 10.1.12.2 or R2, which we just gave higher weight to. The weight is shown to the right under the "weight" column. Regardless of it's longer AS path, this route is chosen because we said it should be.

My thoughts on this are that it could be useful if you want to make sure a specific neighbor is given higher priority, but there are some things to remember. First, it is Cisco-proprietary so you can't use it on any other type of router. Second, it's important to realize this value doesn't leave this router in any way. Some attributes are communicated with BGP route updates, but this is not.

## Local Preference

This is another BGP attribute that's important in the decision process for multiple redundant paths. In fact, if you're concerned about the order of things, you should know that on Cisco routers, the "weight" attribute is checked first, so that if a given neighbor has a higher weight, the local preference isn't even checked. However, it's still quite important because it is an important attribute on all routers, and it affects the BGP routing process in much the same way.

Local Preference does much the same thing as Weight.  Look at the diagram shown above. With the "weight" attribute, we were able to influence R1 in a way that it preferred routes through R2 instead of the default route through R3. However, as I mentioned above, this is an attribute that remains local to the router it's configured on. That means that if there were more routers in the diagram that we wanted to instruct to prefer R2, we'd have to configure it on each router. Local Preference is a way of configuring a router to be the preferred router, and it notifies all it's neighbors of this.

This way, we only have to make a decision regarding which router should be preferred, and set the local preference higher than other routers. Here's our trusty BGP tables, with the weight returned to the default of 0 so that the path through R3 is chosen because of its shorter AS path.
    
    R1# show ip bgp
    
       Network          Next Hop            Metric LocPrf Weight Path
    *>i200.50.2.1/32    10.1.13.2                0    100      0 777 711 i
    * i                 10.1.12.2                0    100      0 777 911 711 i
    *>i200.60.2.1/32    10.1.13.2                0    100      0 777 711 i
    * i                 10.1.12.2                0    100      0 777 911 711 i

Since the local preference is configured on the actual router you'd like to be preferred, we go over to R2:

    R2(config)#router bgp 5500
    R2(config-router)#bgp default local-preference 300

Take another look at R1's BGP table and we notice that the path through R2 is again placed in the routing table.
    
    R1# show ip bgp
    
       Network          Next Hop            Metric LocPrf Weight Path
    * i200.50.2.1/32    10.1.13.2                0    100      0 777 711 i
    *>i                 10.1.12.2                0    300      0 777 911 711 i
    * i200.60.2.1/32    10.1.13.2                0    100      0 777 711 i
    *>i                 10.1.12.2                0    300      0 777 911 711 i

R1 has been instructed by R2 that it has a local preference of 300, and since it is higher than the big fat zero that R3 is sending out, R1 will prefer the path through R2. Note that we did not change anything on R1, nor would we be required to change anything on any other router within this autonomous system

Now, (and this is a very good thing) local preference is NOT communicated outside an autonomous system, that is to say it is not sent over EBGP connections. Only IBGP neighbors receive this information. If you think about it, you should not allow your routers to be influenced by the local preference set on a router in another autonomous system that may or may not be under your control. That's why this is the case. However, it is useful to communicate to routers in the same AS that a particular router should be preferred.

## Matt's Mind

The more I looked at it, the more I realized these two attributes aren't really in direct competition of each other, since they serve somewhat unique purposes. However, they can be used to accomplish route preference, and since Local Preference is not Cisco proprietary, and it also is communicated to my IBGP peers, which makes things much easier for me, I'll probably be using that and leaving the weight to it's default.

Do you have any particular instance where you used weight over local preference? If so, let me know in the comments, or on the [Keeping It Classless Facebook Page](http://www.facebook.com/keepingitclassless)!
