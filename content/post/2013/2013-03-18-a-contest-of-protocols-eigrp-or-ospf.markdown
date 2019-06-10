---
layout: post
title: 'A Contest of Protocols: EIGRP or OSPF?'
author: Matt Oswalt
comments: true
categories: ['Networking']
date: "2013-03-18"
wordpress_id: 3110
slug: a-contest-of-protocols-eigrp-or-ospf
tags: ['cisco']
---


Ah, the age old question that nearly every CCNA and CCNP candidate asks of themselves and others at some point. We see a minimum of 4 routing protocols in our networking studies, more if you decide to take on the Service Provider track. What makes one routing protocol better than another? I think it's clear **why** (at least mostly) these particular two protocols are different, keeping in mind that one is distance vector (yes, distance vector, not hybrid distance vector) and the other is link state. At this point, we at least have [a fundamental understanding of what's different](https://keepingitclassless.net/2011/10/link-state-vs-distance-vector-the-lowdown/) between those two families of protocols, so it's also likely that you already realize one is not necessarily _better_, but rather just different. Both are simply tools in the tool chest we can use to solve a problem they're well suited to solve.

Unfortunately, any curriculum on either protocol doesn't go into too much detail on WHY we would use one or the other. It's true, OSPF is powered by the very powerful [Dijkstra Algorithm](http://en.wikipedia.org/wiki/Dijkstra's_algorithm), which does require more resources on the device than most other protocols, such as the relatively light DUAL algorithm that sits behind EIGRP. However, OSPF gives us a bit more control, seeing as each router knows about every other link in an OSPF area, allowing us to get really granular path selection. EIGRP is, after all, routing by rumor (as is every distance vector protocol).

So is it simply a matter of using OSPF when you have beefy equipment and EIGRP when you don't? One of EIGRP's biggest hurdles was that it wasn't available on non-Cisco gear, but the fact that this is changing now doesn't mean the service providers are just going to jump to it. The choice used to be pretty clear, but since [EIGRP is kinda-sorta open now](http://www.cisco.com/en/US/prod/collateral/iosswrel/ps6537/ps6554/ps6599/ps6630/qa_C67-726299.html) and OSPF doesn't really impact modern routers resources the way it does on older equipment, the lines are blurred. Now it's less of a performance issue, and more of an "it depends".

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Mierdin">@Mierdin</a> <a href="https://twitter.com/robg485">@robg485</a> <a href="https://twitter.com/cjinfantino">@cjinfantino</a> So I think we&#39;ve all come to the conclusion that &quot;It depends.&quot; And yes, put Linux on my routers and switches.</p>&mdash; Matthew Stone (@BigMStone) <a href="https://twitter.com/BigMStone/status/303916897387302912">February 19, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

It always is, isn't it? Well, rather than leave it at that, let's do a feature comparison and identify the pros and cons of each.

## Integration

EIGRP is known widely as a proprietary protocol. While it's true that the informational RFC by Cisco will allow other vendors to use EIGRP as a routing protocol, the adoption of EIGRP by other vendors is still quite distant, if it ever happens at all. After all, this "openness" only happened a short time ago. So, the possibility of integrating Cisco gear with other non-Cisco gear using EIGRP is a possibility, but the likelihood of other vendors to jump at the opportunity to integrate with EIGRP is pretty slim. Big name non-Cisco vendors like Juniper have done a fantastic job of proliferating OSPF as the go-to protocol of choice for people that want to avoid vendor lock-in, and get the granular visibility that OSPF allows.

I mean, I happen to really like Cisco's product offering in this space and in general, as does a vast majority of the industry, but I don't like vendor lock-in any more than the next guy. I like to have the option to go non-Cisco where it makes sense.  So even the slim possibility of integrating with other vendor's equipment makes EIGRP just that much more interesting. However, there are other factors too - lets take a look at...

## Path Selection

OSPF (and link state protocols in general) is pretty cool because it allows us to decide the path through the network by being aware of all links in a given logical topology (usually an OSPF area). While this does place some additional load on the router, it means that each router guarantees the shortest path, even through other routers, because they're all using the same algorithm, and they all have visibility to the same links.

[![screen1](/assets/2013/03/screen1.png)](/assets/2013/03/screen1.png)

The below output is not the same topology, but you can still see that each link has a Link-State Advertisement associated with it. We make forwarding decisions based off how the entire network looks, not just the parts a certain router is touching.

    R3#show ip ospf data
    
                OSPF Router with ID (123.123.123.1) (Process ID 1)
    
                    Router Link States (Area 1)
    
    Link ID         ADV Router      Age         Seq#       Checksum Link count
    1.1.1.1         1.1.1.1         23          0x80000002 0x00B789 1
    123.123.123.1   123.123.123.1   23          0x80000002 0x00F172 1
    
                    Net Link States (Area 1)
    
    Link ID         ADV Router      Age         Seq#       Checksum
    123.123.123.1   123.123.123.1   23          0x80000001 0x006E6D
    
                    Summary Net Link States (Area 1)
    
    Link ID         ADV Router      Age         Seq#       Checksum
    1.1.1.0         1.1.1.1         85          0x80000001 0x0051E3
    2.2.1.1         1.1.1.1         85          0x80000001 0x0038F8
    2.2.2.1         1.1.1.1         85          0x80000001 0x002D03
    2.2.3.1         1.1.1.1         85          0x80000001 0x00220D

With EIGRP and other distance vector routing protocols, we lose this visibility. Distance Vector has also been informally dubbed "routing by rumor, since forwarding decisions rely entirely on route advertisements from the neighboring and adjacent routers.

[![screen2](/assets/2013/03/screen2.png)](/assets/2013/03/screen2.png)

> Please, save your applause for my introduction of the term "Distance Vector Fog of War" for the comments.

Now, it's not enough to simply say that distance vector is "bad", and link-state is "good". After all, the protocol that is powering the internet, BGP, is distance vector, and it's doing great! Can you imagine if BGP were a link-state protocol? Every link on the internet would have to be known by all routers at any given time. The internet infrastructure would be melted down to a pool of hot metal in no time flat. There are times when this level of visibility is not only not needed, but not even wanted. Protocols like BGP and EIGRP are perfect for use cases like this.

## Route Summarization

The practice of route summarization is one of my favorite concepts. It's like the opposite of subnetting. It's SUPERNETTING! (I know, I'm a glutton for punishment) What this does is allow you to combine two or more routes that are pointing in the same direction to a single or at least much fewer routes, resulting in smaller routing tables. When routing tables are smaller, the routers don't have to work as hard to forward traffic. It's overall a best practice, especially in large networks.

In fact, Classless Inter-domain Routing (CIDR) was originally rolled out for this purpose. Most view CIDR as the handy slash notation at the end of routes that usually indicate subnet masks. While that's certainly a result of CIDR, the original intent was to simply get rid of classful routing in a way that didn't bomb out the global internet routing tables.

EIGRP is able to summarize on any interface running EIGRP, and OSPF is only able to do this at Area Border Routers, or routers at that join multiple areas together. There are a couple ways of looking at this, but I'd like to make one very clear point. Any large network that actually requires summarization is likely managed by a team of route/switch individuals that have more or less a good idea of what proper network design looks like.

In a properly designed routed topology, address spaces are contiguous and networks are hierarchical. Therefore, the ability to summarize at any point in the network really isn't really something we need too terribly bad. EIGRP may allow us to summarize routes anywhere, but in a properly designed network at scale, the OSPF areas are in place to allow summarization where it makes sense.

## DMVPN/Stub Routers

Cisco has NOT made the functionality of stub routers or the integration with DMVPN part of their "open" EIGRP standard, so this is still proprietary. So if you're looking for these features on a non Cisco device, don't hold your breath.

I can't exactly blame them here - I mean, it's their protocol, they designed and optimized it to work well in these scenarios, so it's their right to keep some of the secret sauce to themselves. What does get me a little irritated, however, is the plethora of blog posts that came out around the announcement of the IETF draft proclaiming to the world that "EIGRP is open now! Hoo-rah!"

## Ease of Use

Finally, it can be said that OSPF is "more difficult" to understand than EIGRP, which I guess is reasonable. It certainly shows us more about the path selection process, but OSPF has EIGRP beat in terms of how the metric is generated (look it up, the day I learned this in my CCNP studies was the day I lost control of my brain).

Up to you on this one, but I don't really place one over the other in this regard.

## Conclusion

Again, a classic case of "it depends", but hopefully I correctly covered some of the high-level talking points. OSPF makes a lot of sense when that shortest path is really worth pursuing, typically but not always in larger networks, and EIGRP seems to be effective for shops with Cisco and a need for simplicity and support.

I highly encourage you to read my other three related posts. These go into a bit more detail on how distance vector and link state are different, as well as additional detail on the way EIGRP performs path selection in redundant networks.

* [Link State vs. Distance Vector: The Lowdown](https://keepingitclassless.net/2011/10/link-state-vs-distance-vector-the-lowdown/)

* [EIGRP Unequal Cost Load Balancing](https://keepingitclassless.net/2011/09/eigrp-unequal-cost-load-balancing/)

* [EIGRP Feasible Successors](https://keepingitclassless.net/2011/07/eigrp-feasible-successors/)
