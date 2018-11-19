---
layout: post
title: Big Flowering Thing
author: Matt Oswalt
comments: true
categories: ['Rant']
date: "2015-07-09"
slug: big-flowering-thing
tags: ['networking']
---


> This is a rant. It borrows emotional (and some verbal) inspiration from Lewis Black's "Big F**king Thing" bit. However, in order to keep things light and professional, I will be using the term "flower" in lieu of the four-letter word that I am using in my head.

It's not unreasonable that ongoing operations for existing applications, and as a result, remaining profitable, have been and always will be the priority. It's easy to sit atop an ivory tower and critique all of the shortcomings of the industry (applies anywhere, not even just IT), but the reality is, IT (and specifically network infra) is kind of a mess. And that's okay! It's the nature of growing organically - and few disciplines have had to learn this the hard way like network infrastructure. Most importantly, we're all running businesses here. Nothing takes priority over the need to provide ongoing products and services to customers, and to be honest, the rant contained in this post actually points out the need for changes in our industry to be more conducive to this imperative.

All of that said, I feel like the entire networking industry (as well as other, seemingly better-off disciplines to some degree) is accruing technical debt. We're unwaveringly focused on the wake of "thought leadership" coming out of the "DevOps", "Cloud", or "Software-Defined" camps, and we can't stop coming up with, and being willing martyrs for every new big project or product that is announced. We can't stop talking about "NSX vs ACI" despite the fact that I can't pay someone to build a reliable multicast stack, or support the myriad of services required by IPv6.

We keep talking about how the networking industry has been massively disrupted in the past few years, but honestly much of it seems to be centered on vendors and their new products, which is intensely discouraging to me. I believe the true disruption lies in improvements of methodology and culture, and technology improvements and vendor products are just one small part of that.

[As always, I speak for myself](https://keepingitclassless.net/disclaimers/), and not my employer. That said.....

# The Big Flowering Thing

Any time I hear about some big new project, product, initiative, standard, whatever...I think of that Lewis Black rant about a Big Flowering Thing. So that's what I'm going to use to refer to what I'm talking about.

In essence, we have a myriad of projects and products that are taking their own unique approaches to solving problems - which is not in and of itself a bad thing - but they are collapsing under their own weight, and end up being really useful by a fraction of the potential market. Just to call out some examples - we've got cloud software trying to solve every problem that has ever existed or will exist, "SDN" fabrics that no one wants to learn how to operate, and all developers, twitter accounts, blogs, and keynote speakers are affiliated with vendors in some way. So the Big Flowering Things described above invent a plugin system - which results in a hundred plugins, many of which do the same thing in a slightly different way. Call it plugins, projects, whatever.

And all of this amidst dump trucks full of "thought leadership". All this in the name of getting more tech magazine articles written about the Big Flowering Thing. Everyone wants to build a Big Flowering Thing, so they invent a protocol that works with the philosophy behind the Big Flowering Thing, and try to make everyone support BFTP (big flowering thing protocol/project). An RFC is written, describing BFTP. A Twitter personality is created to be the high priest/priestess of BFTP, and wage war against the heathens that would forsake it. Standards bodies are consulted to ensure that the BFTP has a formalized document describing it's innermost workings.

In the meantime, customers are in many ways afraid to look at any of this, as they are waiting for other organizations like them to take the plunge. I worry that the tech journalists are giving these Big Flowering Things more attention than the customers looking at deploying them.

Even companies that previously ignored the hype and decided instead to buckle down and do one thing really well [have caved](http://www.networkworld.com/article/2939120/cloud-computing/arista-has-a-controller-now-too.html) and built a big flowering thing. Because why flowering not.

> I've heard the term "open source is the new standards body". I agree in part, but the execution I've seen is lacking. We've used open source to replace standards bodies with big flowering thing projects that happen to be on Github. In fact, with improper execution, open source can actually make things worse with respect to becoming a big flowering thing - because rather than having one big flowering thing, we have multiple big flowering things sort of squashed together. Everyone wants their special feature in the Big Flowering Thing.

With big flowering things, you ask for a skateboard, and you get a dump truck full of crap you don't need, sitting on top of four skateboards. You can't remove the dump truck from the skateboards because the skateboards are flowering welded to the dump truck.

In short, networking needs a big dose of the [Unix Philosophy](http://www.catb.org/esr/writings/taoup/html/ch01s06.html) - an informal list of guidelines heavily rooted in systems experience rather than thought leadership. Go read that link, and especially focus on the rules of Modularity, Composition, Simplicity, Parsimony, and Diversity. The networking industry has a lot of work to do in each of these areas.

We need simple. We need composability. We need loosely coupled components that do one thing and do it well. We don't need big monoliths that try to cover all the bases - even if designed in a "modular" fashion.

> If you need to go to the grocery store down the street, [don't build a nuclear sub](https://youtu.be/4DqxTVloBX8?t=28m13s) in your front yard to get there.

<div style="text-align:center;"><iframe align="middle" width="560" height="315" src="https://www.youtube.com/embed/4DqxTVloBX8?rel=0&start=1693" frameborder="0" allowfullscreen></iframe></div>

We don't need any more thought leadership. We need quick wins and useful tooling. We need the components that are simple enough to assemble a big flowering thing ourselves, regardless of the scale at which we operate.

# Useful Tooling over Big Flowering Things

Take [etcd](https://github.com/coreos/etcd) for instance. Etcd is a key-value store. It provides a simple mechanism for storing and retriving key/value data, and for replicating that data to all nodes that need it. That's all! Is it getting all the headlines? No! But it's a flowering well-needed piece of software and it seems to do it's job well.

That's really what we need here. And having this modularity - and all of the other guidelines provided in the Unix Philosophy - are really conducive to operations.

The bigger an effort, the harder it is to know when something is not being done correctly. Software design thrives when subjected to small, rapid iteration cycles, but in infrastructure, we put ourselves in a position where we only change SOP once a decade. The problem with building big flowering things is that you don't know if they have succeeded until it gets all the features that everyone is asking for. It's really a scope definition problem - we like to poke fun at the popular examples where software projects have absolute totalitarian dictators at the head controlling what makes it in and what doesn't, but in reality, this can be the healthiest thing for a community - someone that's willing to say no. This is why open source projects are not automatically exempt from becoming Big Flowering Things, and because of feature creep, are in many ways more susceptible to this.

After all what happens to a person that eats everything in sight? They get fat. Sometimes you have to have the wisdom to say no.

# Evil, Lazy Marketing (And Their Followers)

I am sick of seeing technical people use buzzwords to describe what they're doing or thinking about. I'll be specific with this example - I think VMWare is a great company, and has a lot of really smart folks, many of which I look up to technically. That said - "software defined" is now totally meaningless, and the blame is not solely on marketing (a discipline that is annoying more times than not but is excused from this particular sub-rant). These buzzwords have been leveraged in documentation and technical design guides to the point where those who SHOULD KNOW BETTER are using these terms rather than describing practical business value and getting to the meat of what they're talking about.

I get that religion is pervasive in our industry (after all, I worked in the reseller space for a few years), but religion has become an excuse to bypass the technical discussion and get fully behind a solution purely by virtue of how many times it works the words "bacon", "magic", and "unicorn" into a discussion. This is not flowering productive, and I am only compelled to walk away when such terms are used.

Honestly, it's very possible that the reason terms like "unicorn" are used is mostly because these big flowering things are difficult to explain because they're so big and monolithic and complicated. Solutions that are simple and truly modular, inherently provide an easy to explain concepts. This is something that should be considered in software design, especially when that software is going to be used by non software engineers. However I don't believe it usually is when it comes to big flowering things.

# The Need for Operational Education

One thing we really need is proper education. We've got vendors mostly continuing to shove product down our throats, despite the recent "disruption" in networking (though arguably this disruption became an excuse to sell more product anyways) but what we really need is to know what the hell we're doing.

As mentioned, I believe end-users are getting more and more savvy. Those organizations small enough will offload most if not all of their resources to cloud/service providers, and the talent will leave to go to those organizations. What vendors could (and totally aren't) helping with is understanding basics of operating this infrastructure in a more methodology-focused (rather than product-focused) way. Call it infrastructure-as-code if you want, but the vendors (and their partners) are currently in a position where they're built only to sell you something (HW or SW). Every once in a while, if you're big enough, the VARs will throw you a senior engineer to shadow for a week or two, but it's usually aimed at sweetening a HW deal anyways, and that senior engineer is usually fairly specialized in one thing.

So - we need something different. What we need is the same kind of groundswell movement that was created when the top 1% of infrastructure operators started sharing their server operations methodologies. Eventually tools like Puppet and Ansible became popular, and we saw smaller and smaller organizations making use of them. We saw configuration data make it into source code revision control rather than an Excel spreadsheet in Dropbox. There were a myriad of benefits that trickled down and even found usefulness in the small-to-midsize organizations.

# Investing in People Rather than BFTs

Solutions with the best track record of succeeding have been built from loosely coupled components by actual engineers. I fully acknowledge this is hard to do - you need the right people, and many organizations prefer to invest in technology and maintenance contracts rather than obtaining and retaining good talent. Fortunately the math is simple: if you don't invest in people, you end up having to buy more than build. In this situation, you're usually not getting everything you wanted, and you're paying for a lot that you don't want. If you invest in people, you maximize your ability to get everything you want out of a solution, and not much extra. You become efficient. Some organizations aren't large enough to worry about such efficiencies, and I get that.

My point is that the "big flowering thing" doesn't really address the needs of any one individual organization very well because it's trying to do everything for everyone, rather than provide a good set of tools that solve smaller problems. We want tool 25 of 100 but the tools don't come separately, they come as a product/project. The fact that the big flowering thing is open sourced on github does not change this paradigm.

We are in a situation where small-to-midsize organizations (most of us) don't have the use case, budget, or talent to use a big flowering thing, and the largest organizations - that may have the use case and probably do have the talent - are building their own tools and not interested in the big flowering thing. So who is even interested in using the big flowering thing? The way I see it, a REALLY small sliver:

[![](assets/2015/07/bftcurve.png)](assets/2015/07/bftcurve.png)

I do believe that end-users are becoming increasingly able and willing to take greater control of their infrastructure - meaning the slider pictured above is starting to trend left. This is not to say that we don't need vendors anymore. However, going forward, I believe the role of the vendor will and should permanently change. We still need vendors to provide us with good equipment and good software. However, our reliance on vendors for giving us every answer to every problem should and I believe will decrease dramatically. I hope for a future where when a vendor builds a big flowering thing, they do so in a way that doesn't prohibit those of us that want to build it ourselves.

No longer are only the largest and most talented organizations able to bend the network to their will. With the right people, and an insistence on proper engineering discipline, I believe this behavior is already trickling down to the non hyperscale organizations. 


# Some Good Ideas

Here are some ideas that tech journals may not write about, but could probably help us out a lot.

First, I think networking should learn some flowering proper API design

- Structured data: standard markup like XML or JSON
- Schema documentation in the OPEN, not behind a paywall. (We don't NEED one API to rule them all if we have this. Duh!)
- FLOWERING VERSIONED APIs. FLOWER!

One thing about API formats - I was lucky enough to be on a "Software Gone Wild" podcast [recently](http://blog.ipspace.net/2015/05/network-monitoring-in-sdn-era-on.html), and we talked about the lack of good instrumentation in networking, and how this problem stll exists in SDN (or perhaps getting worse/more diverse). However, I think the answer isn't to try to figure out some successor to SNMP. The simple ideas mentioned above will go a long way in ensuring software can be written to consume this data without having to wait for someone to declare a formalized API for monitoring data. We can't trust vendors with this, as they'll make it some kind of big flowering thing manifesto as they have been doing, so we need to take the sexy out of it, in the name of getting shit done.

I think containers (e.g. Docker) have the potential to change the way we deploy network services. We need to get used to the idea of deploying network services in a manner that is not restricted to a single box, or even vendor. It is the network services - not the boxes they run on - that our applications rely upon, and containers could seriously provide operators with amazing tools to become more agile in this respect. As a result, network software needs to be built and deployed to be compatible with such a deployment model. Smaller, more specialized network functions will succeed over Big Flowering Thing software built to do it all.

If you're looking to contribute to an open source project - great! It's one of the best ways to get experience in a language, with revision control, with open source workflows...everything. You may be looking to contribute to one of the popular projects that's getting all of the press attention. That's not a bad thing - but please also take a look at some of the less popular projects as well. Some of the most relied upon software in infrastructure today is open source and at times very underfunded, run by a handful of tired people. While it's important that we continue to make progress with new features and technologies, it's also important to ensure we have a solid foundation. It seems at times that vendors largely only work on these kind of tasks when a big customer asks them to, so we may need to do this ourselves. My point is - don't rely on "buzz" alone to make a decision of where to help. Try to think through an operator's pain points as well.

# To The Vendors

Vendors, please stop devoting all of your energy to trying to build everything for us. Please start dedicating more energy to providing simple tools and APIS that enable us to build it ourselves. If you want to go build a big flowering thing on top of all that, feel free. But don't make us follow you down that rabbit hole by making it the only option.

The large organizations are already building their own tooling, so generally you won't be able to sell your big flowering thing to them anyways. You're just getting in the way when you bypass good instrumentation and keep trying to figure out how to sell them a Big Flowering Thing.

The small shops still need products that represent an easy button for them. That's fine! Improve the instrumentation so that you can empower them to do the simple stuff, while you make your engineers own lives easier because your products don't suck anymore. You can get your big flowering thing to market more quickly when it is built on a good foundation of simple tools that are actually seeing adoption.

# Conclusion

Thanks for sticking with me through this rant. I do believe that our industry (networking and others as well) is ready for disruption - the current operating model has way too many problems to feel otherwise. However, rather than simply become content that there are some new products on the market that look cool, let's focus on what matters.

What matters is continued uptime. What matter is greater agility. What matters is continuing to remain competitive and serve customers better than anyone out there. The MOST sustainable way to do this is for your people to give a shit, and for this to happen, you have to invest in them. Big Flowering Things come and go, as does good talent, it's true. However, with the right culture, your people will be more reliable. The culture and discipline you put in place now will persist after your people leave to pursue other opportunities.

I know it's not sexy, but the things our industry really needs to work on may not always be sexy. I believe strongly, however, that the results we will see by focusing on what's important, demanding proper tooling, and using that tooling to solve challenges, is absolutely sexy.
