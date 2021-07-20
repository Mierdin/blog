---
layout: post
title: The Pros/Cons of Public DNS
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2012-09-11"
wordpress_id: 2437
slug: the-proscons-of-public-dns
tags: ['dig']
---


I strongly believe that every route/switch engineer, even highly experienced ones, should have at least a fundamental understanding of DNS architectures and best practices. More importantly, it should be understood how DNS is being used in today's service providers and enterprises. DNS is one of those services that has been applied to many different use cases, such as [a form of load balancing](http://en.wikipedia.org/wiki/Round-robin_DNS), or even an additional layer of security.

What is frustrating to me is that, while DNS has made it's way into so many areas of technology, most of the route/switch guys I talk to have little to no idea how DNS works, how to build a best-practices DNS infrastructure. Nearly 9/10 don't even know what "dig" is. (You know who you are, [start reading](http://en.wikipedia.org/wiki/Dig_(command)).) I've heard it a million times - DNS is one of "those layer 7 things" and therefore, falls outside the purview of a route/switch engineer's responsibility. Well, I'm calling bullcrap - DNS is close enough to many engineers' day-to-day that we no longer have the luxury of ignoring it, while still calling ourselves networking experts.

If you're in networking and you don't fall into this category, kudos - I will be striving to keep up with you as my studies continue.

Now - I've seen a lot of misleading talk on the internet and in a few in-person conversations regarding DNS with respect to security and performance. Google (8.8.8.8) and Verizon (4.2.2.2) both offer fantastic public DNS services and for the most part, they work great.

However, it's not like they're seeing a large percentage of use on the internet. OpenDNS is reporting that 2% of all internet traffic is resolved by their servers, which is no small number considering the scale, but still pales in comparison to requests resolved elsewhere. Reason is, you have to manually specify that you want to use services like these, since most ISPs hand out DNS servers locally operated by them.

So why would someone use these DNS services? Well, [Google tries to point out](https://developers.google.com/speed/public-dns/docs/intro) that the big reasons all have to do with performance. Whether it's about high utilization of local ISP DNS servers, or the fact that Google's DNS servers are super awesome and powerful, Google says that your internet experience will be faster by using their public DNS service. Granted, Google already has a lot of visibility into the internet because of their little search engine project, so it makes sense to add some visibility into their DNS offering powered by these indexes.

However, using public DNS has one big caveat - many requests to CDNs like Akamai will not pick up your exact location by using these DNS services. Those services will think that you're in the vicinity of the DNS server you're using, which in my case, is across the continental United States - not exactly an ideal place to pull high-density content from. I'd prefer that the CDN pass me traffic from the datacenter down the street.

This means that the claim made by OpenDNS and Google is misleading. Yes, their DNS servers may be fast so that DNS requests are responded to reliably, but that doesn't inherently mean that general internet performance magically speeds up.

I won't go through the details of this, as there are other articles that already have. I was VERY pleased to find articles on [Lifehacker](http://lifehacker.com/5788230/why-you-might-want-to-stick-with-your-isps-dns-server-after-all) and the [Economist](http://www.economist.com/blogs/babbage/2011/03/internet_plumbing) that explains the problem.

As these articles point out, OpenDNS and Google have started to work on [a technology](http://tools.ietf.org/html/draft-vandergaast-edns-client-subnet-00) that would supposedly fix this issue without users having to change back to a DNS server that's more local. I've already pointed out my feelings on this issue, though at this point, it could go either way. I wrote an article [when this draft was first published](https://oswalt.dev/2011/09/the-global-internet-speedup-not/); keep in mind that a few of my views have changed since then. I'm interested in seeing the standard emerge so that I can put it to the test, but I'm still a skeptic.

So....my main point is that we as engineers must be empowered to finding out the best solution for ourselves and those we provide services to. First off, I mentioned the "dig" tool - very useful for finding out detailed DNS information. [This article](http://www.labnol.org/internet/changing-dns-servers/18996/) goes through a few ways to use dig to see exactly how public DNS is or isn't impacting the performance of content being delivered to you.

Also, Google has put together a tool for benchmarking DNS performance called [namebench](http://code.google.com/p/namebench/). Before I go any further, I want to point out that articles like [this one](http://www.pcworld.com/article/184697/namebench_boosts_internet_speed.html) have are misleading. The namebench tool does a good job of evaluating DNS performance, but keep in mind that this does not necessarily mean that your internet performance will dramatically increase by using OpenDNS (which the tools recommends to you, by the way).

The speed at which DNS servers turn your requests around and responds is only one part of good internet performance. Figuring out if DNS is a bottleneck is good, but make sure you do your homework to ensure that the end-user is getting the best experience in either case.