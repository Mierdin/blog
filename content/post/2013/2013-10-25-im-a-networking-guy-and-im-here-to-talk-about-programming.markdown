---
layout: post
title: I'm a Networking Guy, and I'm Here To Talk About Programming
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2013-10-25"
wordpress_id: 4878
slug: im-a-networking-guy-and-im-here-to-talk-about-programming
tags: ['api']
---


I'm fortunate enough to work and be connected with some stellar networking professionals. I mean it - they're rock stars. In my quest to surround myself with smart folks like this - in an attempt to at the very least learn by osmosis - I've clearly succeeded.

I haven't been in the industry for that long - but I've chosen networking (among other things) to be what I want to focus on professionally, and these are the best people to learn it from.

**Every last single one of them** has heard the schpiel: "If you're in networking, you need to learn how to write code." This doesn't have to be anything heavy, maybe just a scripting language.

For about the last year, I've tried to approach this subject with those that I could, and ask what their thoughts are. What do they think when they're told that they'll have to learn a programming language?

**Every last single one of them** has basically said "Bulls**t." Granted, it may not have been that brutal, maybe it was something like "I just don't see the point in doing that right now" but it all kind of feels the same.

Normally I'd dismiss this as a simple unwillingness to learn - but I know most of these guys personally and this isn't a trait they possess. Much of what I learned about vigilant studying and time management, as well as "thinking outside the box" came from guys like this. That's not the problem here.

I started thinking about the reason why, then, they would be so dismissive of the idea that they'll need to learn a programming language - these guys are the opposite of lethargic or unwilling.

I've seen some stellar articles like this one from [this one from Steven Iveson](http://packetpushers.net/programming-101-for-network-engineers-why-bother/), essentially pleading with the typical network engineer to go out there and learn a programming language, and in many ways, doing a great job explaining why it's necessary to do so. Steven is absolutely right - it starts with an open mind, and I think the network engineers out there generally don't have that problem. They want to learn - they want to figure this stuff out. So why is there still a problem?

There's another issue that hasn't really been addressed. While it's likely that many reasons are given for tackling this new skillset, the biggest one they've heard is that it will help automate repetitive tasks - for instance, configuring VLANs on a set of 10 switches. If we're doing this manually, one at a time, of course this is not going to work:

[![diagram1](/assets/2013/10/diagram13.png)](/assets/2013/10/diagram13.png)

Network engineers aren't gluttons for punishment - they've  actually figured out how to automate many of their tasks already. The single biggest argument for learning code - while in my eyes a very valid one - is totally invalid to the network engineer that has already learned how to write just enough VBA or Excel macros to be able to provide a customer with a spreadsheet, say "Fill in the blanks", and plop out some IOS configs that they then hand off to a junior engineer to paste into each device using a console cable.

> Learn code so I can automate my repetitive tasks? I did that a long time ago. Go back to your Python loving cubicle, hippy!

To network guys, the need to learn code then becomes someone else's need, not theirs. They have an automated solution. They don't even feel the need to pursue anything further.

[![diagram2](/assets/2013/10/diagram23.png)](/assets/2013/10/diagram23.png)

Guess what? It's not just the networking industry that has this problem. Every platform in the data center uses some kind of GUI and/or CLI interface, whether it's a storage array, or a switch, a server platform or a hypervisor. While many of these products may have some kind of interface like an API you can consume programmatically, the vast majority of engineers doing deployments or operations on these platforms either aren't aware of them or don't use them.

## So why do we need code?

Clearly there's more discussion to be had. As a network engineer that has IOS and NX-OS CLI commands burned into my retinas, learning a programming language is about a lot more than automation. To me, it's about:
	
  * Creating reusable functions that don't have any human dependency on input or output. You simply create a modular piece of logic where you plug information in, and you get information out.
	
  * Removing the human element from both ends of the function mentioned above. I want infrastructure providing data to my functions, and I want the function to pipe it back to the infrastructure.
	
  * Getting real data out of the infrastructure, in real time, in a format that isn't created to be consumed by human eye balls, but by the applications that need it.

[![diagram3](/assets/2013/10/diagram31.png)](/assets/2013/10/diagram31.png)

I've written before about the [value of infrastructure APIs](https://oswalt.dev/2013/09/the-benefit-of-infrastructure-apis/) and why we need them. If you're unfamiliar with the term, go read that article.

I have a really good example, and it happened very recently. I write quite a few scripts to automate various tasks of mine, but one that I wrote lately felt different to me. It reaches into a Cisco UCS domain, pulls out all of the Fibre Channel WWPNs for each Service Profile, then reaches into the Netapp storage system - a completely different entity - and uses the data from UCS to create the necessary LUN masking configuration. [Take a look at the script](https://gist.github.com/Mierdin/7094271) - there's not a single WWPN written anywhere. It's built to generate a data-set in real time, then use that data set to configure another system. This script is going to be used in one of my customer's orchestration tools so that they can simply and easily create more boot LUNs when they add additional compute resources, with zero human interaction.

The beauty of all of this? The script isn't even that complicated! It's a little snippet, really! But it's powerful - because I am no longer doing that task. My customer is no longer doing that task. Neither of us now have any influence in this configuration, nor should we. Typos cease to exist, and scaling the compute resources is now faster by a matter of at least a few hours.

However - it's not just about speed. If it was, the Excel spreadsheet model might still work. The emphasis here is acknowledging that the human component of the three diagrams above is the weakest link. By taking the human out of this path, and instead placing them as a creator of these functions, and not a critical component of them, we improve our consistency, our speed, and the ability for the infrastructure to essentially configure itself.

What happens when network requirements change multiple times a day? In a cloud DC this is becoming a distinct reality - are you still going to configure the switches in your DC individually? How about when an application gets retired? Are you sure that all of your firewall rules are still relevant? Are you **sure**? There are new tools being made available where ACL-like functionality is being driven by puppet requests, or API calls. It's important that we learn how these work, because they are the key to keeping our network configuration relevant and agile.

Interestingly enough, this actually ends up making the network engineer **more**** **relevant, not less. Now the engineer can focus on designing things the right way, providing integrations where needed, and furthering their own understanding of the applications that are running on their network.

## It's All About The Apps!

Why learn code? Why is an API the new CLI? Networking is going back to it's roots - it's going to be all about the application once again. I'm a network guy - so I know that it can be hard to see it this way sometimes, but when it comes down to it, the network isn't a revenue generator. When we first decided we wanted to connect two computers together, we did it because we wanted to connect two applications together, or a user with another application somewhere else.

The applications took off from there. Networking changed over time, too, but not at the same pace. We've been working with the same tools for a long time, and now that the apps are reaching critical mass, these tools just aren't going to cut it. So if it's all about the apps, then the tools used to run the network have to be all about the apps too.

So do you need to go out and learn how to be a programmer? Maybe someday, but not now. For now, check to see if that black box you work with every day has some kind of interface that allows for these kind of things, and try to move your excel spreadsheet into a script - something like Python, which will definitely be around for this use case for a long time. The importance isn't in picking a programming language - I just did that for you. The important is understanding basic logical constructs like "if" statements, loops, and functions, but also knowing why we need them when we're trying to operate our infrastructure.

I think it's obvious that there are ALWAYS exceptions to the rule. By no means am I writing this article to point out that our industry is screwed because us networking people just don't get it - in fact, I'm writing this article because I do believe that we're on the precipice of something great. We've got the talent today. The network engineers of tomorrow exist and many are already in the workforce. Lots of today's network engineers come from a computer science background, and already have these skillsets - but when they entered the industry, the need wasn't nearly as great as it is today, so they understandably stopped using them. The role of the network engineer is changing - not going away. The tools are changing. The methodology is changing. The way we identify and solve problems is changing.
