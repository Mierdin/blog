---
layout: post
title: Securely Wipe Your Hard Drive the Quick and Dirty Way
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2011-06-20"
wordpress_id: 481
slug: securely-wipe-your-hard-drive-the-quick-and-dirty-way
tags: ['data']
---


We've all heard about tools like [Darik's Boot and Nuke](http://sourceforge.net/projects/dban/) for performing secure hard drive wipes suitable for even the most paranoid.

However, in a pinch, there's an alternative that often goes overlooked, but is able to erase data at a level comparable to all the usual standards like DoD (or even the incredibly obnoxious 35-pass Guttmann method)

The 'shred' utility exists on nearly every popular Linux live CD/DVD and can be executed in a live environment to do the job when it's all you have.

A popular implementation of this command could be:

    shred -fvz -n 3 /dev/sda

What this does:

  * The "f" forces to allow writing if necessary
  * The "v" verbosely outputs progress to the prompt (This will take a while, you need this!)
  * The "z" adds an additional pass of all zeros to help hide shredding, if hiding is what you're after ;-)
  * The "-n 3" specifies the number of passes, similar to the DoD 5220.22-M method

And that's it! Well not really, there's mostly a LOT of waiting involved, but if time is what you've got, then a relatively securely wiped hard drive is what you get.

Obviously don't do this if doing so is illegal (like tampering with evidence - jail is a real lose-lose situation for everyone) or if you REALLY REALLY REALLY REALLY don't want anyone to know what was on that thing, I would recommend the "breakfast cereal" method, shown [here](http://www.semshred.com/stuff/contentmgr/files/0/1fa40d4e151e0485a1d8f9147a81ff38/full/harddrive_destruction_big.jpg) and [here](http://farm3.static.flickr.com/2558/3717487523_f197ac2fbf.jpg). (Feel free to recast into some sort of sculpture, those are always a hit)
