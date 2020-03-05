---
layout: post
title: 'Getting Rusty'
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://oswalt.dev/assets/2020/03/rusty.jpg
date: 2020-03-04T00:00:00-00:00
tags:
  - 'rust'
---

Early this year [I wrote](https://oswalt.dev/2020/01/returning-to-first-principles/) about returning to first principles. I think this desire to dive deeper is a natural continuation of my goal of becoming a more well-rounded technologist. While it's good to know and exploit your strengths, I think it's also healthy to try and fill gaps where you see them, and I feel this is an area that warrants some focus for me.

One way that I'll be working towards this focus in 2020 is learning [Rust](https://rust-lang.org).

<div style="text-align:center;"><a href="/assets/2020/03/rusty.jpg"><img src="/assets/2020/03/rusty.jpg" width="500" ></a></div>

So why rust? For me it's not about jumping on the next hot thing. I actually heard about Rust the first time around the same time I started getting into Go, and that was about 6 years ago. So in many ways I feel like I'm late to the game. Well, then why now? What's pulling me into learning Rust?

# Python -> Go

To tell this story, I think it's worth briefly describing my journey between using Python as my primary language, and now - where I really write very little Python, and do quite a lot of Go. I think it's fun to look at my motivations then, and compare them with my motivations now, which I feel are really quite different.

Conceptually, the move from Python to Go made sense for me for a number of reasons, none of which had to do with performance, really. Everyone likes to dunk on Python because "it's slow" but to be honest, that was never a motivation for me learning another language.

For me, Go was the first language I really worked with in a professional sense that was strongly typed, or compiled (mind you, my background is not traditional CS). If you're used to something like Python that is interpreted, and loosely typed this may sound like a bad thing. And it did for me. I got over it quickly, and now I can't live without it. When I have to get back into Python or Javascript, and I find myself wondering "okay, at this point in the code, `thisvar` should be a string.....right?", I am immediately reminded of my gratitude for a strong type system.

Once over the initial learning curve, I actually feel a lot more productive with Go than I ever did with Python. IMO, Go is more readable and its simplicity lends itself to generally being a pleasure to work on.

It should be said that I am not a believer in the idea of a language "winning". I still write some Python to this day, and a year from now I expect I'll still be writing plenty of Go. I don't believe it's healthy to try to force one tool to do all the things. Being a polyglot is a good thing, and gives you options to choose from when it comes time to solving problems.

# Why Rust?

I noticed Paul Dix (CTO, InfluxData) on Twitter discussing a similar journey from Go to Rust, and he was kind enough to [offer a pros/cons breakdown](https://twitter.com/pauldix/status/1234565878362013696). I think it's a good breakdown of the pros/cons of moving to Rust from Go.

<div style="text-align:center;"><a href="/assets/2020/03/pauldix1.png"><img src="/assets/2020/03/pauldix1.png" width="750" ></a></div>

Aside from the excellent points Paul made above, here are some additional personal motivations for pushing me in the Rust direction:

- Go made me a believer in letting the compiler do as much work as possible. Whether it's simple stuff like type checks, or the built-in race condition checker, the Go compiler gives you a lot of safety. Writing idiomatic Go, in many ways, is about reducing runtime uncertainty. Rust appears to take this same principle to the extreme. Its type system and ownership model gives you a lot of safety guarantees right at compile-time. No need even for garbage collection. 

- It's been about 5 years since I really chose to dive into a new language. I re-learned Javascript as far as I needed to in order to create the web front-end for NRE Labs, but I would still consider myself far from an expert, and I really have no desire to become a front-end developer. That whole ecosystem still scares the shit out of me.

- Go is still a fairly abstract language. It's not as abstract as Python, but there's a lot under the hood that it takes care of for you. Again, this is one of the reasons I love working with it. Its simplicity is one of it's biggest strengths. However, this can also lend itself to a bit of naivete when it comes to really knowing what's going on. Most folks describe Rust like a less insane form of C++, which appeals to me.

- Go's absolute **achilles heel** is dependency management. It has really butchered things here. I'd be lying if I said one of my biggest reasons for looking at Rust is that in my hello world experiments, they seem to have the UX around dependency management **nailed**.

# Use Cases for Forced Learning

The move to Rust to me seems like more of a tradeoff where I'm giving up a bit of reduced readability and a higher learning curve in return for more control and better performance in certain use cases.

For me the problem is simple - I don't really have those use cases right now. By **far**, my use cases for software projects are much more about developing the right abstractions, or getting an end-to-end complex system working right. Never about how to eek the last bit of performance out of the hardware. My kind of software deals with API calls that show up a handful of times a second. The kind of projects I work on usually work a lot more like [Rube Goldberg machines](https://en.wikipedia.org/wiki/Rube_Goldberg_machine) rather than the [Shinkansen](https://en.wikipedia.org/wiki/Shinkansen).

This is one of the biggest reasons why I haven't even thought about learning a low-level language like Rust or even C/C++ for that matter. The biggest arguments for learning languages like that are usually centered around control or performance, and I just didn't/don't have those use cases. 

So I clearly need to think about new use cases that force me to think about stuff like this. Some ideas:

- **High-performance networking applications** - I have some experience with network load testing, so maybe a continuation of this in Rust will have some results.
- **eBPF** - This is a new way to program the linux kernel, and I'm noticing that there is a growing trend of folks that want to use Rust for this. I may be able to knock out two birds with one stone here.
- **Game Engines** - a good friend of mine has given me some insights into his journey of writing a game engine in Rust, and how games in general are a huge performance use case. One of those things where it will always make use of better performance. I am admittedly a big gamer, so this may be a way to meld two passions.
- **Cryptocurrency Mining** - I have very little interest in becoming a crypto bro, but cryptocurrency mining is a use case where every bit of performance matters, so who knows - maybe this would teach me a few things. Even if I'm re-inventing a few wheels, and making no money, the journey may be worth the learning experiences.

In the near future, I'm hoping to be able to do some very intro-level Rust posts. It will probably be a bit noobish - like most blog spurts, I write as part of my own learning process. If something egregious needs corrected, please [let me know](https://twitter.com/mierdin) or email me using my name at this domain, I'm only happy to learn and grow from my mistakes!