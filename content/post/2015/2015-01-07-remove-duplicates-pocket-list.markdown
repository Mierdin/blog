---
layout: post
title: Remove Duplicates from Pocket List
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2015-01-07"
wordpress_id: 6022
slug: remove-duplicates-pocket-list
tags: ['articles']
---


One problem I've noticed with my Pocket list is that my reading list contains quite a few duplicate entires. Sometimes I forget I saved an article and I save it multiple times, or maybe I save it across-sources (like Twitter or Facebook, or just browsing.

It looks like Pocket has **some** protective capabilities around this. If I endlessly spam the button provided to me by my Pocket chromecast extension, Pocket only saves the one copy and all is good.

However, take the following example. Many of the articles we read and put into our Pocket list use some kind of URL options for tracking purposes:

    ?utm_source=social&utm_medium=twitter&utm_campaign=1215

If you arrive to an article from different sources, but save both to Pocket, Pocket will treat these as different URLs. This means that if you're bad about staying caught up with your Pocket list (like I am), it can be very easy to save duplicate articles, making the situation even worse.

Fortunately I have a solution. I wrote [this python script](https://gist.github.com/Mierdin/0996952ba02d87175f3b) to automate the removal of duplicates of entries in your pocket list.

> Currently this script works by removing ALL text after a question mark (?) or a hash mark (#) in each URL of a Pocket list, and then assessing the resulting list to find the duplicates. If your article URLs actually use this data in a crucial way (most are just for tracking purposes and not strictly necessary) then it's possible that this script may delete articles you wanted to keep. Modify as needed.

First, install the wrapper provided here: [https://github.com/tapanpandita/pocket](https://github.com/tapanpandita/pocket)

Then you need to sign up for a consumer key here: [http://getpocket.com/developer/apps/new](http://getpocket.com/developer/apps/new)

Finally, you can use this key as a command-line argument to my script. For example:

[![pocketdedupe](/assets/2015/01/pocketdedupe.png)](/assets/2015/01/pocketdedupe.png)

As shown, the script will open a browser tab for you to authenticate with Pocket and approve connection to your new "app". When you are successfully redirected to Google, you can close the tab, and return to the script. Hit ENTER, and you will see the output listed above.

> This worked well for me, but because this does delete entries from Pocket without prompting for confirmation, I must say to use this at your own risk.

Hope that is helpful!
