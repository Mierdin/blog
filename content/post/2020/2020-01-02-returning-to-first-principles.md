---
layout: post
title: 'Returning to First Principles'
author: Matt Oswalt
comments: true
categories: ['Programming']
featured_image: https://oswalt.dev/assets/2020/01/blocks.jpg
date: 2020-01-02T00:00:00-00:00
tags:
  - 'compsci'
---

I feel very strongly (and [have for some time](https://oswalt.dev/2017/03/learn-programming-or-perish/)) that fundamentals are really important in a technical career. I didn't start my career with a traditional CS degree, and while there were some fundamental knowledge to be picked up along the way, much of my education and early work experience bypassed a lot of the lower-level fundamentals and placed heavy emphasis on operating technology. This feeling of pulling levers and pushing buttons, rather than actually building things, in large part was responsible for me shifting back into software development full-time.

Python was a natural fit at the time, certainly since network automation was still in its nascent stages and I had already started tinkering with it while I was still doing infrastructure operations and consulting. However, getting into Go was probably the best thing for me to really complete the jump from infrastructure admin to software developer.

Go (not only the language but also the community around it) revealed to me an entirely different way of thinking about software. While Go does a good job of hiding a lot of the underlying complexity from you, the Go community really seems to "get" that it's still really important to know about how those things work, and build applications that are [mechanically sympathetic](https://dzone.com/articles/mechanical-sympathy) with the hardware. Sitting in a class by [Bill Kennedy](https://changelog.com/gotime/6) where he showed how to do this in Go is still what I consider to be a pivotal moment in my career.

While I have done my best to keep this lesson in mind, it's been somewhat difficult to truly understand what this means, since my experience has very much been about operating at a high level and building complex systems from that. [NRE Labs](https://labs.networkreliability.engineering/) is a really good example of this. NRE Labs is a complex beast of inter-related services and components, but none of these require deep knowledge of hardware or hyper-efficient memory allocation. Generally the bottleneck is outside of the NRE Labs components, so a "good enough" approach applies here.

That said, the lessons learned by digging into assembly, **really** understanding memory allocation, building an operating system from scratch - lessons learned by most with a more traditional upbringing - have been calling me for a long time, and I think it's time I responded.

<div style="text-align:center;"><a href="/assets/2020/01/blocks.jpg"><img src="/assets/2020/01/blocks.jpg" width="500" ></a></div>

In many ways I've already started this journey, with a few things having piqued my interest in the past few months.

For me, these first principles (or at least how I see them in my head) that I wish to pursue fall into one of three areas of focus:

- Computing History
- Systems Internals
- Low-level Languages

For any of these, please [reach out](https://twitter.com/mierdin) if you have any recommendations for additional resources, and I'll be happy to consider adding them.

# History of Computing

I was born in '88, and unlike a lot of folks in this space, didn't really have a ton of exposure to *real* computing until I was in college. As a result, I feel like I missed out on the really formative events in computing and how we got here. I pick up a few tidbits here and there but I haven't really spent the time to look back and learn from the past.

Maybe it's because I'm getting older and having kids, but I've become really interested in history lately - both military history, and the history of computing. I find there is tremendous value in understanding how we got where we are, no matter where you like to focus, and since I've decided to make a career out of technology, it's a really good idea to spend time understanding how things came to be. Here are a few ways I plan to do that:

- **Books** - I've picked up a few recommendations that I've added to my [bookshelf](https://oswalt.dev/bookshelf/). Some of the usual suspects are there, like Bell Labs, and Xerox PARC
- [**On The Metal Podcast**](https://oxide.computer/blog/categories/on-the-metal/) - this podcast is really great for several reasons, but I've especially enjoyed hearing the myriad of tech legends hop on the mic and share their experiences from the early days of computing
- [**History of Networking Podcasts**](https://rule11.tech/history-of-networking/) - this has been a favorite resource of mine for years, and it's impossible to separate the history of networking from the history of computing generally, since the two were so tightly intertwined.
- **Museums** - I've been pleasantly surprised to learn of the [Living Computer Museum](https://livingcomputers.org/) in Seattle which a bunch of working older computers for you to play with. Given that I live in Portland, OR, I'll definitely be visiting soon. In addition, the [Computer History Museum](https://computerhistory.org/) in Mountain View, CA is always a great spot to visit when I am in the Bay Area.

# Low-Level Languages

As I mentioned, my early experience transitioning from primarily Python to primarily Go was useful for several reasons. Languages like Go force you to think more intentionally about how your code should be tested. Types and concurrency are first-class citizens that can be used as well as abused. However, even Go is still a fairly high-level language. Sure, it's nowhere near as abstract as Python, but there are still a lot of abstract concepts in a language like that, and it's easy to take them for granted, and forget why they're in place. Remember, the goal is to be mechanically sympathetic, which requires an understanding of the layers beneath, even though we're using an abstraction layer to remain productive.

I have a few upcoming projects that could expose me to C and C++. "[The C Programming Language](https://www.amazon.com/Programming-Language-2nd-Brian-Kernighan/dp/0131103628)" has been on my shelf for a long time and I haven't yet dived into it. It's time I changed that. I'll be going through this book and providing summary blog posts on what I learned, probably in a few chapters at a time. I will likely move from there into a book on C++ (recommendations welcome). I expect that around this time, I'll already be getting involved with some projects on my horizon that will require this knowledge. I'm specifically looking for ways to gain practical knowledge with these languages, beyond the book learning.

My goal here isn't necessarily to be able to write future software in C, C++, or assembler (though the ability to be able to do that when needed is absolutely a nice byproduct) but rather to give me a better appreciation for the abstractions offered by languages like Go. Based on what I've seen and what my friends have been telling me, my medium-term goal is to adopt [Rust](https://doc.rust-lang.org/book/) as one of my primary languages. In fact, exploring Rust is one of the reasons I've chosen to deviate with C/C++ for a time - the major benefits of Rust seem to be aimed at those that want the same kind of power of C/C++ but with the right ideas about handling memory management and other lower-level concepts.

I find that in the year 2020, there are few reasons for me to continue to write software in super high-level languages like Python. Go and Rust seem to be right at the sweet spot where they're much more flexible than C, but without sacrificing a ton of performance like Python. Working for a time with C will give me not only an additional tool in the tool chest, but a much greater apprecition for the abstractions offered in Rust and Go, and the ability to use them to their full advantage.

# Systems Internals

Similar to my desire to spend some time with lower-level languages to gain an appreciation for more abstract languages, it's useful to spend some time diving into the internals of common systems we usually take for granted. Again, this is all about gaining perspective, and about making ourselves more effective when operating at a more productive, abstract level like a pre-built command-line interface.

I have two hacker-type projects in mind for this, but I imagine this will grow as I get more involved.

- **"Hello World" From Scratch** - A friend of mine recently told me about this [**really interesting**](https://www.youtube.com/watch?v=LnzuMJLZRdU) video series which goes through building a computer starting with nothing but an off-the-shelf microprocessor. This is an amazing idea, since it helps you really appreciate what you get when you go through something like a Hello World example in Python or Go. Even low-level languages like C give you a **lot**, and forcing yourself to start with only a microprocessor and a bread board ensures you **really** know what's going on.

- [**Linux from Scratch**](http://www.linuxfromscratch.org/lfs/) - this has been on my list for **years**. Obviously this is pretty opinionated towards Linux, but given how pervasive Linux is, and how long I've been playing the role of sysadmin with it, it's beyond time for me to do this. 

I actually do have a decent-sized workbench in my basement and the idea of setting up a hardware lab is becoming more appealing. Pictures will surely follow once I get to that point.

# Let's Get To Work

To better keep me up to date on current and future developments, I've purchased an [ACM membership](https://www.acm.org/). If you're not familiar, I recommend taking a look. There's a lot of great material available as a member, and it's a useful way to stay updated with the latest in computing news, including this [excellent article by Jessie Frazelle on open source firmware](https://queue.acm.org/detail.cfm?id=3349301).

You may have also noticed that the domain for the blog post you're currently reading is `oswalt.dev` instead of `keepingitclassless.net`. The latter has served me well for almost 10 years, and I've made a lot of fond memories on that domain. However, it really doesn't reflect my current focus, and is a bit of a mouthful. So, to keep things simpler and more focused on what I'm working to make my career, I've republished all my existing blog content on `oswalt.dev` and will be publishing future content here. For at least the next year, I'll be continuing to redirect requests from `keepingitclassless.net` here to ensure things stay working.

I'm excited about this new direction. For a long time, I've felt like I was missing something in my technical expertise, and while I don't think there's one thing I can do to fix this gap (I mean does one/should one ever finish learning?), I do feel like this a step in the right direction.
