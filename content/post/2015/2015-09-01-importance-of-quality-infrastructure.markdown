---
layout: post
title: The Importance of Quality in Infrastructure Software
author: Matt Oswalt
comments: true
categories: ['Code']
date: "2015-09-01"
slug: importance-quality-infrastructure-software
tags: ['networking']
---


Infrastructure doesn't matter.

That's what we keep hearing, right? The ongoing effort to commoditize infrastructure has generated a lot of buzzwords and clickbait taglines, and this is one of the biggest.

IT infrastructure has had a long history of hero culture, and it's easy to make the assumption - given how low many of these technologies sit in the stack - that we are the important snowflakes and that we run the whole show. The reality is that we don't, and every time an application engineering team has to hold a series of meetings on how to properly work on the existing infrastructure, that is time spent not creating new features.

The reality is that the underlying infrastructure never stopped being important. The call to simplify these layers was never borne out of a desire to sweep the carpet out from beneath ones own feet. It was a call for help; application teams barely have time to meet the feature requirements laid out by the business, and having to deal with downtime or overbearing change management procedures makes a bad situation worse. The business is not measuring software project success by the number of challenges they overcame on our way to their objective, but rather on their ability to meet that objective in the time allotted.

The point is, infrastructure should be invisible. I believe the real-world, practical point behind saying "infrastructure doesn't matter anymore" is that we are finally getting around to practicing the absolute truth that for the vast majority of organizations, the infrastructure is not a revenue generator. As a result, what really enables the business to grow is for the infrastructure to simply get out of the way (and by that I mean always be up and secure, and etc.). This is the harsh reality of running infrastructure today.

I was trying to think of a different (and perhaps less bleak) way of describing this idea when I happened to be listening to [The Cloudcast Episode #211 on Apache Mesos](http://www.thecloudcast.net/2015/08/the-cloudcast-211-mesosphere-dcos.html). In it, [Ben Hindman](https://twitter.com/benh) says (start at the 15:50 mark - I'm slightly paraphrasing):

> ...if organizations can deal with failures in data centers and doing maintenance on top-of-rack switches...and that's completely disconnected from the people that are actually trying to write/run their software, that's a really big win.

The key takeaway here is that infrastructure improvements and changes should be able to coexist in parallel with applications, not provide roadblocks, and still provide stability, security, etc. In the same way that your car relies upon solid roads in order to travel quickly, applications need infrastructure that allows the application development lifecycle to continue unhindered.

I believe that one of the keys to achieving this goal is better quality, at every layer of the stack.

> Another key to achieving this is a vast improvement to people and process, but I'll save that for another post.

# Open Source Infrastructure Libraries

Lately, vendors have been releasing open source libraries for consuming infrastructure products. This is a relatively new idea, especially for network technologies, and it's a great step in the right direction. However, not all of these libraries are created using the same rigor and discipline as existing infrastructure products, and as a result can suffer when it comes to quality.

To me, this makes the whole thing moot, because as a customer I would be relying on both the library, as well as the product that library consumes. The poor quality of the library means it is a liability, making me just as unlikely to use the whole thing as if the primary product itself was buggy.

I'd like to call out just a few illustrative examples, in a friendly, balanced way, in the interest of promoting better quality all around. I have more, but I think these three will help illustrate the point I'm trying to make.

- Cisco's [ACI Toolkit](https://github.com/datacenter/acitoolkit) pleasantly surprised me if I'm being honest. Pylint rates it at an 8.46/10 (which is pretty good), and the repo contains unit tests and instructions for running them. However, there is no file for listing dependencies, so I have to do this manually when first working with the software. I also noticed quite a few examples where non-idiomatic imports were used - this can cause problems when trying to reference this library externally. That said, this repository houses a lot of the automated testing artifacts that are missing from a lot of other vendor repositories.
- Juniper's [OpenClos](https://github.com/Juniper/OpenClos) is a great idea, but the code is VERY difficult to read, and this makes it difficult for me to modify this to suit my needs. They also include unit tests but don't seem to mention how these are run. It would be nice to see something like Tox used to run these unit tests (no tox.ini). There are also far too many PEP8 violations to ignore (pylint gives a nearly 1/10 rating on average - I couldn't run even run pylint on the whole thing because of a broken import)
- I am a huge fan of the folks over at Nuage, and was excited to see them publish a [library for their VSP product](https://github.com/nuagenetworks/vspk), so I was disappointed to see that this library earns a -9.76/10 in pylint, and contains no unit tests that I can see. I also am not entirely sure why they decided to publish different versions of the SDK in different directories of the repository, and not simply leverage git tagging for this purpose. It's worth mentioning that this library was published only days ago, but I feel like the first attempt could have been significantly better.

The point of these examples is not to trash the hard work these vendors have done, but rather to help illustrate what I mean when I say I see indications of poor quality - or at least indications that the language isn't being used in the right way (i.e. Python not being written Pythonically). Even more so, I hope I'm making the point that quality is a difficult challenge everywhere, not just in one place.

> I want to make it clear that I am not a fan of [PEP8-ing a bunch of code](https://www.youtube.com/watch?v=wf-BqAjZb8M). I'd much rather talk about how to write Pythonically than to call out instances of incorrect whitespace, or lines that exceed 80 characters. However, when these kinds of failures happen in large groups like this, it shows a clear lack of automated testing, which means more serious issues can come up easily.

Look, it's an AMAZING first step to have code in the open. I fully appreciate the legal hurdles it takes to get code into github or PyPi, and not hide it behind a paywall. Look at the vendors that did this at [NFD10](http://techfieldday.com/event/nfd10/). It's no longer "expected" that you have to sign a EULA to download a library of code, it's actually expected that you don't! The EULAs are now the exception, and not the rule. This is a phenomenal start. Trust me, I really know how difficult this is. However, it's not enough to just have the code in the open. It needs to meet certain quality standards.

The solution to this problem is that each library needs to conform to the same quality standards by the existing product set. Perhaps these libraries are created in an effort to win a particular account, and therefore have a tight timeline, but in my eyes, this doesn't matter. The large customers that are asking for this probably have their own quality standards anyways.

I really appreciated Ken Duda's perspective on infrastructure software quality when we sat down for a chat at Arista Networks during Network Field Day 10. If you're involved with software at all, I highly recommend watching it. He has the right mindset for someone in his position, and we need more of this in IT.

<iframe width="560" height="315" src="https://www.youtube.com/embed/VdJZq4dRjf4" frameborder="0" allowfullscreen></iframe>

In summary, throwing code on github isn't really the ultimate goal here. What matters is fostering a community. In the long-term, it is more important to define and enforce standards for quality than to rush to get a library out because some customer requested it. The customers that really need these libraries are typically of the scale where quality is absolutely crucial.

# Conclusion

Quality may not always be sexy, and it may not always be what closes a big account, but it is crucial in order allow the business to win. IT as a whole needs to focus on paying back some of it's technical debt and start insisting on a quality infrastructure, at every point in the stack.

> I attended Network Field Day 10 as a delegate as part of [Tech Field Day](http://techfieldday.com/about/). Events like these are sponsored by networking vendors who may cover a portion of our travel costs. In addition to a presentation (or more), vendors may give us a tasty unicorn burger, [warm sweater made from presenter’s beard](http://www.youtube.com/watch?v=oQrJk9JzW8o) or a similar tchotchke. The vendors sponsoring Tech Field Day events don’t ask for, nor are they promised any kind of consideration in the writing of my blog posts … and as always, all opinions expressed here are entirely my own. ([Full disclaimer here](https://keepingitclassless.net/disclaimers/))