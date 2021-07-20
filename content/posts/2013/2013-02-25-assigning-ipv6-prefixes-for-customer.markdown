---
layout: post
title: Assigning IPv6 Prefixes for Customers
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-02-25"
wordpress_id: 3174
slug: assigning-ipv6-prefixes-for-customer
tags: ['addressing']
---


Now we arrive at the question of how much address space to allocate for...anyone. You may be a service provider, you may be a business, you may be a home user. Today, this question is quite easy to solve. If you're a business-class customer, you ask your ISP for a block of addresses, and based off of your need (or ability to justify the need), you'll be allocated some addresses. For many small-to-medium businesses, this can be as small as 8, or even 4 addresses. Let's face it - in light of the current availability of globally routable IPv4 addresses, plus the fact that most organizations are using NAT/PAT anyways, this is typically no big deal. A few addresses for public-facing 1:1 NAT type stuff, and then a few addresses for NAT/PAT pool usage, and we're good to go, even with relatively large RFC1918 internal LANs. So in the IPv4 world, address acquisition is just that - the acquisition of addresses. You ask for addresses, you get them.

In IPv6, it no longer is necessary to ask for addresses, since we already know that the de-facto standard subnet size is a /64. So rather than ask for addresses in multiples of 18 quintillion, we ask for them in terms of prefixes, or networks. "Hey Mr. ISP, can I have a /64? How about a /56? Or a /48, even?" We might even say how many routable networks we want, and the prefix is adjusted accordingly. Regardless - a standard answer for each use case, be it a business, service provider, or home customer, needs to be in place. There needs to be a standard way of providing prefixes to each of these use cases.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/Mierdin">@Mierdin</a> <a href="https://twitter.com/cjinfantino">@cjinfantino</a> Yeah, but that&#39;s kind of my point. A /56 is already &quot;wasteful&quot;. Heck a /64 is wasteful. So why not keep it simple?</p>&mdash; Matthew Stone (@BigMStone) <a href="https://twitter.com/BigMStone/status/305776712220803072">February 24, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

With the old IPv4 way of thinking, a /56 is indeed wasteful. After all, you're allocating 4.7 sextillion **addresses** to that particular entity. For really any organization, this is an absurd number of addresses. Heck, so is a /64, as Matt Stone states. However, this is the problem with address-based thinking. We have to assume that each org wants to use /64s for most of their networks, as has been the industry recommendation since the inception of the protocol. With a /56, we may have 4.7 sextillion addresses, but only a mere 256 networks, if this /64 mentality is to be held true. 256 is not a lot, folks, not for small to medium customers, and not nearly enough for large customers, and service providers, such as cloud providers.

So it stands to reason that we now consider prefix allocation to be the highest priority. We don't worry so much about the number of addresses in a given subnet. In fact, with IPv6 we can pack even more hosts (assuming you don't NEED separation as in client:server) into a single subnet because of cool mechanisms like [neighbor solicitation](https://oswalt.dev/2011/10/neighbor-solicitation-ipv6s-replacement-for-arp/). For the larger customers, we can recommend that this approach be taken first, then a good evaluation of exactly how many of these networks are needed can follow. Granted, with cloud providers this may just be unavoidable, since their prefixes will be used as their customers/tenants see fit, and there's no way to get around this.

So how about the small guys, like small business or home users? Should they get a /48? How about a /56?

Take a look at [RFC 6177](http://tools.ietf.org/html/rfc6177). There, the idea is clear. Home users of the future may require multiple subnets, so we should allow this. The authors specifically mention that a /48 for home "sites" is indeed too wasteful, but instead, a /56 or something similar would be acceptable for a residential customer.

My question is, do we implement this kind of thinking now, or later? Why not just use a /64 per residential customer now, but offer the ability to expand to a /56 later if the customer requests it. At least this way we'll have the expansion capability without wasting those prefixes up front. We'll know exactly when our residential users start wanting to route packets internally.

> Spoiler Alert: I have a really good imagination, and I can't think of a reason, present or future why Joe Schmo the typical residential internet consumer would ever need more than a /64. If you have a use case that is reasonable, please enlighten me, because I genuinely would like to know. Clearly the folks of RFC 6177 had something in mind but didn't care to elaborate.

The argument that we keep allocations the same for everyone to keep it *clean* is less compelling than the argument to eliminate prefix waste for users that will just simply never ever need anything remotely approaching a /48, or even a /56. I am aware of the size of the IPv6 address space. I've heard all of the analogies - a quintillion addresses for every millimeter on planet earth, or comparisons of golf balls to the sun, or whatever. Believe me, I know this - one of the greatest things about IPv6 is it's fantastic address space. But before you jump into the pool of kool-aid, consider this. We're shifting mentalities away from IPv4, and into IPv6. We don't think about allocations in terms of addresses, but in terms of entire prefixes.

Since we're talking about using /64 in most places, we now have to watch out for the number of prefixes we assign to entities. Is there a corner case where a home user would need more than a /64? Of course there is - I'd be one of them. But I know, as well as most of you reading this, that 99.9999% of home users will NEVER require more than a single routed /64. Try setting up an IPv6 tunnel through Hurricane Electric (it's free!). You'll notice that the default allocation is a /64, but you can request a /48 with no justification needed! Keep in mind, though, that this service is OBVIOUSLY used for the technical users among us. For home use, I would say that a default allocation of /64 is the best option. In the rare event that the home user knows enough to realize that additional subnets are needed, an option to expand to a /56 can be made available.

For medium to large entities, I want to emphasize the fact that there are 65,536 /64 subnets in a single /48. Many many many organizations have nothing close to this number of networks. Some do, but many do not. Assuming a /48 for all business-class customers is truly wasteful, and again, I realize how many addresses there are to choose from. Still wasteful. I know we have 2^128 worth of address space to choose from. If we keep handing out blocks of 80 bits worth of address space to gas stations, we'll find the end of that pool real quick.

For those of us that don't work for IANA, we adopt this new mentality of thinking in terms of prefixes, and not just addresses. Prefixes become FAR more of a finite resource than addresses, and although we don't have to necessarily be misers about it, we could benefit from adopting a responsible method of distributing these prefixes. The 32-bit address space that we run on today was originally aimed at a fledgling internet, and no one could have possibly anticipated the scale of the modern-day internet. Who knows - in 30 years, 128 bits may not be enough.
