---
layout: post
title: Free-Form Discussion at CLEUR
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2015-02-18"
wordpress_id: 6033
slug: free-form-discussion-cleur
tags: ['cisco']
---


I was fortunate enough to be invited out to Milan, Italy for Cisco Live Europe, and we had a few interesting discussions about a multitude of topics. One of them was more free-form than the others, and focused on defining SDN, what it's value is, and where that value is most realized.

Check out this video recording of the session; it was good to get a few perspectives from non-networkers, since I'm sure their perspective is different from the network administrator's as it pertains to the ongoing shift in this industry:

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/PHKYKDqRbSw" frameborder="0" allowfullscreen></iframe></div>

For the record, it's not fair to say that VLAN provisioning takes two weeks, even after change approval. What the server administrator is usually asking for is an entirely new logical network, and there's much that has to happen in order to do this, the easiest of which is tagging the server port on the ToR. These networks have dependencies, like IP space, firewall and load balancer contexts. Sometimes, routing configurations have to be changed. Is the current provisioning model optimal, or even acceptable? Of course not - that's why I'm focusing on the newer, more automated methods. However, there's more than meets the eye here.

I also want to reiterate one of the ways compute and even storage have advanced past networking, and that is something I've discussed before. Networks are still thought of in terms of discrete devices, while storage and compute are now discussed in terms of "pools".

> Even in the smaller shops, we are moving to this model (though now our "pets" are just virtualized which arguably isn't much better)

## Test-Driven Networking

I also want to elaborate on something that's becoming an increasingly interesting topic for me, and that is the concept of test-driven development. At around 23:30 in the video, we began discussing something that - in essence is network automation. Hans wanted the "easy button" to bring these services online more quickly, so that once they're approved, they just go happen. One large hurdle to accomplishing this is the testing that must take place after such a change, to make sure it was applied successfully and that the business is still making money. Automating the change is one thing - but if someone has to go back in and make this verification, we've lost the advantage.

> These are all good points, and frankly I am pleased as punch we got to this level of detail. The networking industry seems to still be clamoring about "APIs vs CLIs" and this discussion about pure methodology pleases me to the core.

TL;DR, test-driven development - in it's strictest form - is the idea of building your tests before you write any code to actually do the thing you want. This implies that you know generally how your software will work, and that you truly understand the use cases (you're testing for them, duh!). This was one of the fundamental building blocks of Continuous Integration, and now, testing is not some behemoth phase that takes place only at the end of a 6-12 month release cycle - it occurs every time a change is made to the codebase, because it is woven into the codebase itself.

Networking is in dire need of this level of discipline and rigor. The change rate to a software project that uses this approach is staggering. If we can somehow couple our test cases with the same tooling that we use to make changes in our network, it becomes less of a burden to think about testing, and we gain much more confidence that we're doing what we need to do safely.
