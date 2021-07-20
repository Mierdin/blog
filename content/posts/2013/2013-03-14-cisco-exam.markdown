---
layout: post
title: Cisco Exams
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-03-14"
wordpress_id: 3220
slug: cisco-exam
tags: ['cisco']
---


> This started off as a company email but I wanted to share it, since I've been asked before. Below is opinion and opinion only. I'm more interested in how this compares with your study methods and Cisco exam experiences, so please let me know your thoughts in the comments.

Cisco exams....let's face it, they suck. (In a good way though) I've taken exams from all kinds of vendors, and Cisco is ***really*** good at creating exams that vet you technically, but also require that you understand the practical reasons for the technologies we work with, not just memorizing maximum values, or configuration steps.

As a result, there should probably be some kind of book that just prepares you for Cisco exams in general, not specific to any technology, because they're very unique! If I had to condense such a book down to a bullet list, it would include:
	
  * **READ THE QUESTION**. Every word, every syllable. Then, read it again. Nearly every question can be DRASTICALLY changed with even the smallest of wording changes. Cisco knows this, and it's one of their favorite ways to weed out the chaff, especially in the lower-level exams like CCNA.

  * **READ THE BLUEPRINT**. Cisco will do their best to cover everything on a given exam's blueprint. Use this to understand what to study, and what not to study. This blueprint is available on the home page of each exam. Google the exam, and there should be a link to the exam topics.
	
  * **BE PRACTICAL** - Cisco exams are FULL of questions, both lab, simlet, or multiple choice that requires that you have command line experience. This means that you need to know the commands to run, what they do, and what output you expect to see in nearly every case. This means that you should get as much of this experience prior to the exam. Most of the time, if you spend the time learning how things are done practically, and understanding the output that you expect in both a "bad" configuration and a "good" configuration, then this becomes muscle memory, and the answers to questions you would otherwise not know can be discovered using common sense based on this experience - all at the exam station.
	
### GNS3

  Want to get practical experience in Cisco without the need for physical equipment? This is a must. Put the time in to get this working, and it will be your best friend. This program emulates Cisco IOS - you can use actual IOS images to power virtual routers on a visual topology. You can download GNS3 from [here](http://www.gns3.net/), and also you can download a TON of great GNS3 labs from [here](http://gns3vault.com/).

### Packet Tracer
	
  You would have to trip and fall not to find this online at this point. Google "download packet tracer" and you'll find a download. Keep in mind that this is a simulator, not an emulator, so it's not ***exactly*** like real-world, but it's close. Should be more than adequate for CCNA.

### Real Equipment

  Nothing beats real equipment, in terms of learning. Not exactly easy to carry around, so GNS3 may be a better choice for on-the-go engineers, but home labs that are internet connected are GREAT, even for traveling guys like us. If you want to see a recommended equipment list for CCNA, please ping me, or google it.

## Tips
	
  * **WATCH THE CLOCK**. Do some quick math at the beginning to see how much time you should allocate to each question based off of the time allowed and the number of questions. Try to stay around this average on each question. Ending too early can be almost as bad as not finishing on time, because it usually indicates that you rushed something. Time management is extremely important on these exams.
	
  * **AVOID SHADY PRACTICE TESTS** - I think it's clear that it's a bad idea to use brain dumps, but why? One reason I've talked about with some team mates recently is the fact that the BEST part of studying for the exams is the studying itself! The exams are just a speedbump on your journey to greatness - and this applies to all exams. Don't make the exam the reason for being. Just make it a way to sum up the awesome journey you just went through.

## My Methods

I've been asked to publish my study methods. I don't follow this verbatim for all certs (i.e. CCIE) and it may not work for everyone - but I have found a decent amount of success with it and if it works for you, great. My method comes in three phases:
	
  * **PHASE 1 - VIDEOS** - Name a video-based training company of choice. My favorites are CBTNuggets (CCNA R/S, CCNP R/S) and INE (CCIE R/S and Entire DC track). I highly recommend starting your learning with these resources, since most of the time, in this phase, the concepts are brand spanking new. Use this to gradually "dip your toes in the water" as it were, so as to not cause a routing loop in your brain. I recommend watching these videos to initially learn the material, as well as lay a baseline structure for your notes. I have a plethora of OneNote notes on each Cisco cert I study for, and these videos lay the foundation. I can also use this structure to revisit and add/remove notes as I learn through other means, in other phases. This phase introduces me to new concepts, and gets the terms in my mind, so the heavier phases to come later will have more impact.
	
  * **PHASE 2 - BOOK / LAB** - This is where I spend most of my time. I use the Cisco Press certification guide for each exam, and since the topics mostly line up with the topics on the videos watched in the previous phases (maybe a different order), then I can dedicate a chunk of time to each subject. Maybe spend a week on OSPF. During this phase, I would read the chapter(s) on OSPF, practice all kinds of OSPF labs in GNS3 and/or on real gear, all while adding notes from the books and labs to my OneNote collection. Spend the most time in this phase - it is where you will re-learn all the subjects you learned in phase 1, but with MUCH more depth, and practical experience.
	
  * **PHASE 3 - PRACTICE EXAMS** - Again, please do your best to avoid brain-dumps. I recommend using three main sources for practice exams - they're legit, they're very good, and there's more than enough to vet your knowledge without having to go to other sources:
	
    * Boson Ex-Sim MAX - These exams WILL certify your ability to take a Cisco exam. They are VERY tough, and very real-world. They do sims, simlets, testlets, MC, etc. Can't recommend these enough. And $99 per Cisco exam, comes with 3-5 practice exams, 50 questions each? Come on - no brainer. I recommend using these HEAVILY in the week or two before your exam date. This gets you hours upon hours of "getting in the zone" with respect to the exam. Exam day will merely be an extension of this activity.
	
    * Cisco Press practice exams - these are the CDs or codes that come in the back of every new Cisco Press book. These are very good as well, though I have found some minor mistakes from time to time. Use these at the end of reading every chapter to help solidify the material.
	
    * Cisco Press Exams at the beginning of each chapter - again, very good to either see if you know the material ahead of time, or to go back and certify that you know it after you've read the chapter. Either way works.

Any other questions, feel free to let me know. I also recommend keeping a "general" tab in OneNote that allows you to write down todos and questions to be answered later, so your thought processes can get recorded, but your line of study isn't interrupted. I'm very ADD, so I have to do this to make sure everything gets captured and nothing gets missed.

[![notes](/assets/2013/03/notes.png)](/assets/2013/03/notes.png)

Again, I'm very interested in hearing other study methods. Please share your own in the comments.