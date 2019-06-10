---
layout: post
title: The Global Internet Speedup (NOT)
author: Matt Oswalt
comments: true
categories: ['Opinion']
date: "2011-09-02"
wordpress_id: 955
slug: the-global-internet-speedup-not
tags: ['akamai']
---


I recently saw posts from a few sources on a new initiative backed by a consortium that includes Google and OpenDNS to attempt to improve the overall speed of the internet by optimizing the way DNS works on the internet.

![](/assets/2011/09/ODandGoogInBed.png)

If you think about it, a great deal of internet traffic is high-volume requests for things like photos, music, video, and the like. You may know, then, that content providers like Akamai have positioned themselves globally around the world to provide this content at a relatively close physical location to those requesting it. This greatly decreases the length of time required for content to get from point A to point B, and the result is more reliability.
DNS has become the catalyst for this concept. Authoritative nameservers receive requests from intermediate recursive resolvers, which is typically a DNS server provided to an end-user by their respective ISP. The authoritative nameserver will recognize the source address of this request, which would be the address of the recursive resolver. Since this server is usually geographically close to the end-user requesting content, the authoritative nameservers are able to correctly identify the content provider that's best positioned globally to provide content reliably.

The problem occurs when the end-user doesn't use a DNS server near them. An increasing number of users are using third party DNS services like Google and OpenDNS, because those organizations offer enhanced services, such as policies that dictate what can or cannot be accessed. The downside to this is that the DNS server is usually not geographically representative of the end-user's location. When authoritative nameservers receive requests from these servers, they'll resolve to an IP address of a content provider that's geographically close to that 3rd party service. This means that the end-user will probably be forced to retrieve content over a much longer distance.

[![](/assets/2011/09/diagram2.png)](/assets/2011/09/diagram2.png)

[Section 7.8 of "IPv6 AAAA DNS Whitelisting Implications"](http://tools.ietf.org/html/draft-ietf-v6ops-v6-aaaa-whitelisting-implications-06#section-7.8) has also cited this as the cause of a problem in DNS whitelisting.

The proposed solution to this problem involves creating a new field in a DNS request that contains the original requestor's IP address. The consortium behind this has created [a new IETF Draft titled "Client Subnet in DNS Requests"](http://tools.ietf.org/html/draft-vandergaast-edns-client-subnet-00) which explains how this can be done. I read through this draft. The technical term for this option is referred to as EDNS0, and it looks like this (taken and condensed from the draft):

    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |                        OPTION-CODE                        |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |                       OPTION-LENGTH                       |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |                          FAMILY                           |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |        SOURCE NETMASK       |        SCOPE NETMASK        |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |                         ADDRESS...                        |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+

This results in having the ability to pass the originating IP address, that is - the IP address of the end user, with the DNS request, so that when a decision needs to be made as to which location is best to serve up content, the result is geographically accurate.

One of the world's largest content providers, and arguably the largest - Akamai  - does not agree that this is the best way to speed up the internet. Their argument is that the proposed solution would benefit less than 1% of their users, as this is the estimated number of users that do not use local intermediate recursive resolvers.

## Matt's Mind

So, what do I think about this proposed solution? I think it's a load of bull cookies.
	
- First, Google and OpenDNS are backing this solution because they both have 3rd party DNS offerings that they wish to bring attention to. I'm sure they recognize this would only matter to a small number of internet users, and their aim is to increase that number by trying to publish a specification that tries to solve a problem (poorly) that only impacts their users. This proposed solution is hardly more than a PR ploy, and not a very subtle one. Articles from ZDnet like [this one](http://www.zdnet.com/blog/networking/google-and-opendns-join-forces-to-speed-up-dns/1394) or [this one](http://www.zdnet.com/blog/networking/changing-dns-probably-wont-help-your-video-streaming/467) talk about these proposed changes, carrying with them lengthy quotes from OpenDNS CEO David Ulevitch as well as other leading figures about how they're "proud to be the pioneers in carrying the internet forward" blah blah blah. Stop writing bloat.
	
- Second, from a strict cost-benefit perspective , this solution would significantly improve speed/reliability for only a small fraction of internet users. The majority of users on the internet utilize DNS recursive resolvers provided by their respective ISPs, which are geographically close to the end-users themselves. Authoritative nameservers will usually pick a content delivery network node that's pretty reliable as a result. Only a very small portion of internet users break this mold by using 3rd party DNS services like OpenDNS and Google. As I mentioned before, Akamai, which is a huge presence in the content delivery space, has said that they are not behind this as the best option for speeding up the internet, and they're probably the most interested in making sure content is provided to end-users optimally and reliably.
	
- Third, has everyone forgotten about anycast? The Internet Protocol has had the capability to direct traffic for quite a while by using anycast to place the burden of choosing the best path to content on the network layer. In fact, [the internet's root DNS servers have been using anycast to mirror each other](http://www.securityweek.com/content/anycast-three-reasons-why-your-dns-network-should-use-it) around the world for quite some time now. Content delivery networks have had similar capabilities for a while, but I'm not sure if they're utilizing it's full potential (could be waiting for larger adoption of IPv6). Anycast addresses can be placed in DNS records so that this decision-making process is placed on the network layer.
	
Finally, and this is sort of a sub-point, but I have my doubts as to how this will work behind NAT. The RFC has a VERY brief section titled [NAT Considerations](http://tools.ietf.org/html/draft-vandergaast-edns-client-subnet-00#page-17), and it seems to say that there shouldn't be any problems, but doesn't explain why. That section seemed kind of shady.

In my opinion, making better use of anycast is the way to go. IPv6 makes anycast much easier and it's really the only legitimate long term strategy to fix this problem. I propose that the decision-making process at the authoritative nameservers will give way to anycast IP addresses being placed in DNS records for content providers. Many content delivery networks are already using anycast - if this flexibility is extended to the end-users by resolving DNS names to anycast addresses, we arrive at an effective solution to this problem, and it is done using existing tools at the network layer, as opposed to introducing more bloat to an application-layer protocol.

Remember [RFC 1925](http://www.faqs.org/rfcs/rfc1925.html)? You should. I'd like to specifically cite Truth 12:

>     In protocol design, perfection has been reached
>     not when there is nothing left to add, but when there
>     is nothing left to take away.

Let's refrain from trying to reinvent the wheel for the sake of improving a corporate brand. Let's stop writing articles praising a technology without doing the appropriate research. Let's work towards a solution using the tools we already have.

(If you'd like to learn more, read the [IETF Draft](http://tools.ietf.org/html/draft-vandergaast-edns-client-subnet-00) or visit the website for the project [here](http://www.afasterinternet.com/howitworks.htm), if you can bear it, or [this Wall Street article](http://blogs.wsj.com/digits/2011/08/30/new-address-scheme-aims-to-speed-up-the-net/) I found if you're in for a laugh.)
