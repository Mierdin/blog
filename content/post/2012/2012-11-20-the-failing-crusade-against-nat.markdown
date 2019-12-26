---
layout: post
title: The Failing Crusade Against NAT
author: Matt Oswalt
comments: true
categories: ['IPv6']
date: "2012-11-20"
wordpress_id: 2624
slug: the-failing-crusade-against-nat
tags: ['ipv6']
---


After watching the recent epic that was the [comment thread](http://networkingnerd.net/2011/12/01/whats-the-point-of-nat66/#comment-2575) on [networkingnerd](https://twitter.com/networkingnerd)'s NAT66 blog post from last year, I was initially persuaded to sit and watch from afar.

I've had the opportunity to work with IPv6 quite a bit, and though [I've done a few IPv6-related posts on the site](https://oswalt.dev/category/blog/ipv6-2/), I still feel like there's always something missing. After all, much of IPv6 is still just talk (sadly) and not enough wide-spread adoption to really put it through it's paces. The "network engineers" to whom the gods have gifted the great power of omniscience speak against IPv6 IN GENERAL on something as petty as NAT, keeping us as an industry from moving forward.

Here's what we **know**. NAT is a band-aid. I don't care if it's baked into every Linksys device you buy your grandmother - I don't care if it's included in every curriculum and enforced at every internet boundary you've ever seen in your life. It started as a band-aid, and has resulted in a big tourniquet.

We've known for a while that NAT was merely a stopgap, brought on purely by the explosive growth of the internet. Vint Cerf has said on multiple occasions, that he never intended the IPv4 address space to fulfill the requirements of a modern internet. The math (2^32) proves it, anyway.

Lets just play devil's advocate then - what if NAT was not needed for this purpose? What if the internet didn't grow like it has, and we didn't require the use of it to make maximum use of the available address space? Can you imagine what the proposal for NAT would sound like then?


> "Hey, what if we hack out the IP address manually out of the IP header and not worry about what it does to the other portions of the datagram? Damn the applications, man, this is war!"

[![Clearly, this is the inventor of NAT](/assets/2012/11/mad_scientist.jpg)](/assets/2012/11/mad_scientist.jpg)

They would be laughed out of camp.

What does NAT truly accomplish? NAT binds a pool of addresses to a pool of addresses, or in address-starved cases (yes I know they're common), to a pool of Layer 4 ports. NOWHERE in there am I checking anything in the packets to ensure that the packets flowing through these NAT translations are valid. This is a fundamental misunderstanding of NAT that perhaps is contributing to the confusion.

I don't know if it's a plethora of network engineers brain-dumping exams and not grasping the concepts, or maybe the definition for "network engineer" has changed in the short time since I even initially hit the job market, but of all the things NAT **is**, it is **not** a security mechanism. Please, please understand this. You are no more secure with NAT then without it. If you don't believe me, would you kindly turn off the firewall functions of your internet-edge device, and I will show you.

From a compatibility perspective, we've known for a long time that NAT is harmful. Most don't realize this, but for EVERY SINGLE PROTOCOL in existence that uses IP address information in the data portion of a packet, an Application-Layer Gateway must be created so that this information can also be rewritten in the same way. Most common use case: FTP. Nearly every NAT-capable router, SOHO included, has an FTP ALG built in, so you can do FTP from behind NAT. Do you really want application developers in an IPv6-enabled future to continue this madness?

Vint Cerf himself has said:

> "Some of us feel NAT boxes are sort of an abomination because they really do mess about with the basic protocol architecture of the Internet."

Now, about the rogue commenter on Tom's blog - no, I don't want to pick on him, but I do want to call out one paragraph:

> I also wonder when the first time I will turn on the news and hear about some guy's life being destroyed because his wifi handed a routed IP to someone who cracked his WEP key and hosted a kiddie porn site off the line. It'll be inevitable. Well, I guess it's his fault for not having a properly configured firewall and not being a network engineer, huh?

[No, I didn't make that up, I am incapable of making that up, please read for yourself.](http://networkingnerd.net/2011/12/01/whats-the-point-of-nat66/#comment-2575)

Like I said, it's not my goal to speak ill of anyone - I merely want to point out that this is an education problem. If we're at the point where we're coming up with paragraphs like this, it's time for change.

Obviously, those of us that generally embrace the idea that NAT is bad are not recommending that it be stricken from history and never thought of again. Clearly there is a use case for it, and that is why I've decided to issue a proposal:

I submit to you, the SFW version of Rule 36:

> If it exists, there is a use case for it.

Undoubtedly, there is a use case for NAT66, just as there (obviously) has been a use case for NAT44. There are even use cases for NAT64 if you really think about it. My issue with this whole debate is this: Are there really **that many** use cases? I mean, if we provide the tools necessary to do NAT66, does it just go to the one-off crazy guy that has that one unique situation that absolutely requires it? I'm not talking about today, we all know that IPv6 still has some wrinkles, I'm talking about long-term evolution of the networks our children and grandchildren have to support. The answer is no, if it exists, the general majority will flock to it, because it's comfortable, it makes sense, and in their mind, makes them more secure.

My plea to the industry - do your homework. You say you've heard NAT keeps you safe. Do you **know** that? Have you fought off the dragons of the internet with the sword named NAT? Get off your ass and challenge these ideas yourself - don't just read from a book and take it for granted.

If we're going to move forward as an industry, we need engineers that are willing to do the research to make the internet _better_, not just scream and shout when things don't go our way.