---
layout: post
title: Learn Programming or Perish(?)
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2017-03-27"
slug: learn-programming-or-perish
tags: ['networking']
---


I was honored to return to Packet Pushers for [a discussion on programming skillsets in the networking industry](http://packetpushers.net/podcast/podcasts/show-332-dont-believe-programming-hype/). I verbalized some thoughts there, but even 60 minutes isn't enough for a conversation like this.

To be clear, this post is written primarily to my followers in the networking industry, since that's largely where this conversation is taking place.

# Scripting is NOT Programming

I want to put something to rest right now, and that is the conflation of scripting and software development. You may be hesitant to pick up any skills in this area because you feel like you have to boil the ocean in order to be effective, which is not true.

As I briefly mention in the podcast, I spent the first 4 years or so of my career making networking my day job. Because of that, I picked up a lot of useful knowledge in this area. However, as I started to explore software, I realized that networking wasn't something I wanted to do as a day job anymore, but I still greatly value the networking skillset I retain from this experience.

Making this leap over 2 years ago revealed a multitude of subskills, fundamental knowledge, and daily responsibilities I simply wasn't exposed to when I wasn't doing this full time. Things I even take for granted now - like code review, automated testing, and computer science basics like algorithms. While I wouldn't ever discourage anyone from learning these kinds of things, it is very understandable that a network engineer doesn't deal with these things, because they go way beyond simple scripting.

> That said, you may run into challenges as your scripts become more complex. It may be useful to pair with someone that writes code for a living, and learn how to make your scripts more modular, scalable, and reusable.

In short, don't conflate **skillset** with **occupation**. Don't feel like you have to boil the ocean in order to get started. You don't have to become a programmer, but you should be able to write and maintain scripts using a modern language.


# Stop Talking, Start Building

Hopefully the previous section drew a clear line between the **skill** of scripting and the **occupation** of software development, and that as a network engineer, you no more "need" to become a software developer than a car mechanic "needs" to become a heart surgeon. Now that this is out of the way, it's time to have some real talk about this whole debate.

One thing I've noticed since joining a team that has ties to just about every area of IT, including networking, is that other disciplines realized long ago that these skills are necessary for reasonably modern operations. There is no "should sysadmins learn code" discussions going on right now - they've all picked up Python, bash, or similar. It's not a discussion of whether or not being able to augment their workflows with code is useful; it is assumed. Yet in networking we're still debating this for some reason. It pains me when I hear perspectives that paint basic scripting skills as something that only engineers at Facebook or Google need to worry about, when other disciplines, even at smaller scale, simply assume this skillset exists in their operational model.

Frankly, I am a bit disturbed that this is still so much of a discussion in networking. I worry that the vast majority of the industry is primarily interested in having their problems solved for them. This is something I observed about 3 years ago, and is a big reason I wanted to make a change in my own career - I didn't feel like I was building anything, just operating something that someone else built. We alluded to this in the podcast - the industry seems to be trending away from "engineering", and towards "administration". Of course, this is a generalization. It's obvious that the rather explosive growth of communities like ["Network to Code"](http://networktocode.com/community/) are indicating at least some interest, but I worry that it's not enough.

There are only two possible conclusions that I can draw from my observations:

- People assume that in order to be useful, they have to learn everything a software developer has learned. 
- The difference between software development and scripting is understood, but even scripting is viewed as something "only for Facebook or Google".

Hopefully the previous section sufficiently refuted the first point. This just isn't true. Don't conflate occupation with skillset.

Regarding the second point, I am not sure how to solve this, to be honest, other than to advise that you look at how other disciplines have incorporated those skillsets. Attend conferences that don't explicitly focus on networking. I attended [SREcon](https://stackstorm.com/2017/03/23/stackstorm-srecon-2017/) recently and was blown away by the difference in mindset towards these skillsets, compared to my experience at networking conferences. I worry that we get into this networking echo chamber where we listen to each other reject these skillsets, and use that to justify not picking them up ourselves.


# Focusing on REAL Fundamentals

All of that in mind, I want to wrap up with a brief discussion about the difference in types of skillsets, since this often comes up when bringing up software skills in networking. For instance, headlines like "Learn Programming, or get CCIE?" piss me off, frankly. It just misses the point entirely, and subverts the tremendous amount of nuance that needs to be explored in this discussion.

I believe strongly that focusing on fundamentals, especially if you're just starting in your career, **and regardless of which discipline you fall under**, will set you up best for success in the long run. It will allow you to make a lot more sense of specific implementations like CLI syntax. Don't be afraid to lean on the user guide when you need to look up the syntax for a command. Commit the concepts that sit under that command to memory instead of the syntax itself.

As an illustration, consider the artist/painter. If painters learned like the network industry wants us to learn, then art schools would only teach how to replicate the Mona Lisa. Instead, artists learn the fundamentals of brush technique. They learn what colors do when blended on the palette. They use their own creativity and decision making to put these fundamentals into practice when it comes time to make something. Similarly, programmers learn fundamentals like sorting algorithms, Big-O notation, CPU architectures, etc, and rely on knowledge of these tools to solve a problem when it arises.

It's worth saying, that because of where this industry is right now, implementation knowledge is important too, especially since the networking industry is in love with certifications that demonstrate implementation knowledge. It's obvious that the networking industry places a lot more value on specific implementations - just look at the salary estimates for a CompTIA Network+ vs just about any Cisco certification.

However, vendor certs are basically a way of putting the vendor in control of your career. On the other hand, fundamental knowledge puts YOU in control. It lets YOU dominate interviews, instead of the vendor you've tied yourself to. Always emphasize learning the fundamentals, and consider that the "real" networking fundamentals may not be on any popular curriculum.

To build your career, you will likely have to balance implementation-level knowledge like certs, and fundamental knowledge. Certs let you get in the door - that's just a reality for the current state of the interview. But don't let this keep you from going way deeper - it will do wonders for your career long-term.


# Conclusion

To wrap up; if you only take two things away from this post, they are:

- Scripting is for everyone. Yes, that includes you. It's something you can start with today, because it's not magical. We're just talking about the description of the logic you already use in your day-to-day operations as source code. That's it.
- Emphasize fundamental knowledge. Learn enough about implementations to get in the door, but make sure you know how TCP and ARP work (as an example) regardless of platform.

