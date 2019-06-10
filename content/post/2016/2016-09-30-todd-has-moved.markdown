---
layout: post
title: ToDD Has Moved!
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2016-09-30"
slug: todd-has-moved
tags: ['go']
---


ToDD has been out in the wild for 6 months, and in that time I've been really pleased with it's growth and adoption. Considering this was just a personal side-project, I've been blown away by what it's doing for my own learning experiences as well as for the network automation pipelines of the various folks that pop onto the slack channel asking questions.

For the last 6 months I've hosted ToDD on [my personal Github profile](https://github.com/Mierdin). It was a good initial location, becuase there really was no need at the time to do anything further.

However, as of tonight, ToDD's new permanent location is [https://github.com/toddproject/todd](https://github.com/toddproject/todd). Read on for some reasons for this.

<div style="text-align:center;"><a href="/assets/2016/09/github.png"><img src="/assets/2016/09/github.png" width="400" ></a></div>

# Native Testlets

One of the biggest reasons for creating the ["toddproject" organization](https://github.com/toddproject) came about when I started rewriting some of the testlets in Go. These are called [native testlets](https://todd.readthedocs.io/en/latest/testlets/nativetestlets/nativetestlets.html) and the intention is that they are packaged alongside ToDD because they're useful to a very wide percentage of ToDD's userbase (in the same way the legacy bash testlets were).

For this reason, I created the "toddproject" organization, and once that was done, it made a lot of sense to move ToDD there as well.

Rewriting the legacy bash testlets in Go offers several advantages, but the top two are:

- Ability to take advantage of some common code in ToDD so that the testlets aren't reinventing the wheel
- Better cross-platform testing (existing testlets pretty much required linux)

Currently only the "ping" testlet has been implemented in Go - but I hope to replace "http" and "iperf" soon with Go alternatives.

# Updated Docs

In addition to moving to a new location, the documentation for ToDD has been massively improved and simplified:

<div style="text-align:center;"><a href="/assets/2016/09/newandold.png"><img src="/assets/2016/09/newandold.png" width="900" ></a></div>

As you can see, the order now actually makes sense. Please check out [todd.readthedocs.io](https://todd.readthedocs.io/en/latest/) and let me know what you think!

