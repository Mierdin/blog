---
layout: post
title: Networks! Now, With More DevOps!
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2015-03-12"
wordpress_id: 6043
slug: networks-now-with-more-devops
tags: ['devops']
---


> TL;DR - buzzwords suck and I want to rant about that.

I've been doing a lot of posts lately on the skillsets and technologies needed to move networking into the same level of productivity that other disciplines have reached. During this process, I've had time to contemplate labels and buzzwords.

By itself, I don't see much value in the term "DevOps", whether it's succeeded by the phrase "for networking" or not. These days, the person using this term might just mean "automation", or be describing a technical position.

> As in "We're looking for an experienced DevOp." I know, right?

Just today I heard yet another story that illustrated a total misuse of this term, undoubtedly confusing all involved. I say, what's in a name?

## DevOps For Networks

This leads me down the path of considering that the phrase "DevOps for networking" is just as useless. Although I'm sure this was certainly not intended, this phrase implies that there is a special sector of the DevOps movement that is specific to networking. Unless you're focusing on specific tools (which you shouldn't be) then this isn't the case. The underlying business value is precisely the same.

The DevOps culture and tooling that came about in compute was created because developers and operations needed to reduce the chasm growing between them Compute was a key part of both environments, and the disconnect between the two caused issues when moving code from dev to prod.

Networking, too, has a part to play in this relationship, and as such has a big part to play in the ongoing convergence between general infrastructure and the development and deployment of applications. It is just as much a consumed resource as compute, and is a crucial piece of the delivery of an application (certainly the more we pile on network services to improve application delivery). So why are we only now really tackling this piece of the puzzle?

On contemplating this, I quickly remember that the implications of network infrastructure are far more reaching. Networks don't just exist in the data center. It's not a stretch to imagine that the remote branch office network is just as much a part of the user experience as the ToR switch above your servers. How about the enterprise WAN? Is there a place for this in the DevOps movement? If I may speculate as to a reason why we're having this conversation now, it's likely because of these extra considerations. And it's not an easy problem to solve.

In summary, though the implementation details of the networking discipline can be unique, it is just as much of a consumed resource as compute, and storage. If you can get into this mindset, your individual network devices matter less, and you focus on what drives value, which is the network services you offer.

## Conclusion

This isn't to say I'm going to ban the term DevOps from my vocabulary. Though all these terms are way overblown, they still do help to serve their original purpose of putting at least some kind of label on an idea so we're at least aiming in roughly the same direction (even if it's into pitch black darkness with a broken slingshot).

The business value is key, and ultimately the dots start to connect themselves when viewed from that lens.

> If you are a network engineer that is interested in learning more about what's going to be driving network requirements in the next few years, I highly recommend you look into some of the stuff going on around containers. [The CloudCast](http://www.thecloudcast.net/) podcast is a great place to start, they've done a very good job of getting the right people on to make this all make sense.
