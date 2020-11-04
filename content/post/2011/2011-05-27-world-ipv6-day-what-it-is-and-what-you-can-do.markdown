---
layout: post
author: Matt Oswalt
title: 'World IPv6 Day: What It Is and What You Should Do'
excerpt: Arguably the most important day for IPv6 since it was created is World IPv6
  Day, which falls on June 8th, 2010. This has been a highly publicized day when the
  top internet content providers like Google, Facebook, and Yahoo provide native IPv6
  connectivity to their sites. But what does this mean? And how can you be prepared?
  Most of all, what will break, if anything?
comments: true
categories: ['Infrastructure']
date: "2011-05-27"
wordpress_id: 360
slug: world-ipv6-day-what-it-is-and-what-you-can-do
tags: ['dns']
---


Arguably the most important day for IPv6 since it was created is World IPv6 Day, which falls on June 8th, 2010. This has been a highly publicized day when the top internet content providers like Google, Facebook, and Yahoo provide native IPv6 DNS records to their sites. But what does this mean? And how can you be prepared? Most of all, what will break, if anything? <!-- more -->

![](http://www.linux-ipv6.org/v6ready/IPv6_ready_logo_phase1.png)

## What will happen on World IPv6 Day?

Most leading internet content providers have not added DNS IPv6 ("AAAA") records to their root domain names. Most of them have provided a subdomain, such as "ipv6.exampledomain.com" - that can be used to establish IPv6 connectivity, but the vast majority of users don't use this. On World IPv6 Day, participating content providers will add an IPv6 record to their root domain names, meaning that when users send DNS requests to the same domain name they've used for years, they'll receive both an IPv4 and IPv6 address to use to get to the site.

For instance, Google provides 5 IPv4 address in the "google.com" record:

    [root@localhost ~]# dig google.com

    ; <<>> DiG 9.2.4 <<>> google.com
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18677
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 5, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;google.com.                    IN      A

    ;; ANSWER SECTION:
    google.com.             185     IN      A       74.125.225.84
    google.com.             185     IN      A       74.125.225.80
    google.com.             185     IN      A       74.125.225.81
    google.com.             185     IN      A       74.125.225.83
    google.com.             185     IN      A       74.125.225.82

    ;; Query time: 41 msec
    ;; SERVER: 8.8.8.8#53(8.8.8.8)
    ;; WHEN: Fri May 27 08:37:48 2011
    ;; MSG SIZE  rcvd: 108

This shows us every possible IPv4 address that can be used to access "google.com". If one fails, the others can be used.

If this query was modified to look for IPv6 "AAAA" records within the IPv6 subdomain, "ipv6.google.com", you'd see this:

    [root@localhost ~]# dig ipv6.google.com AAAA

    ; <<>> DiG 9.2.4 <<>> ipv6.google.com AAAA
    ;; global options:  printcmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 35959
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;ipv6.google.com.               IN      AAAA

    ;; ANSWER SECTION:
    ipv6.google.com.        0       IN      CNAME   ipv6.l.google.com.
    ipv6.l.google.com.      299     IN      AAAA    2001:4860:b007::63

Google has an IPv6 address dedicated to this sub-domain. However, this is only useful if users type "ipv6.google.com" in their browsers to access the site. Users using "google.com" will have IPv4-only connectivity to the site. World IPv6 day is all about merging these records. Both IPv4 and IPv6 connectivity will be possible using the root domain name, "google.com". Again, many other content providers are going to be doing this - for a list of sites that are participating in World IPv6 Day, check out [http://isoc.org/wp/worldipv6day/participants/](http://isoc.org/wp/worldipv6day/participants/).

## What is going to break?

Probably nothing. The rare instances where problems occur will manifest themselves on "broken" IPv6 configurations, such as an IPv6 tunnel that's been configured to work, but for some reason isn't forwarding traffic. The majority of users will not experience any problems.  In the unlikely event that you have problems, solutions exist to make your operating system prefer IPv4 temporarily, such as [the one Microsoft has provided](http://support.microsoft.com/kb/2533454). This is a "killswitch" of sorts, and would have roughly the same effect as disabling IPv6 altogether.

The best thing to do to take advantage of  World IPv6 Day is to get proper IPv6 connectivity. While it's true that there are many ways to do this, the easiest I've come across is the [gogoCLIENT by Freenet6](http://gogonet.gogo6.com/profile/gogoCLIENT) (You have to make an account to download the client). This makes what could be an otherwise complex configuration easy by bringing an IPv6 tunnel straight to your desktop. Once you create an account, both Windows and Linux versions of the client are free to download. This client should provide you with the IPv6 connectivity you need to browse these sites with ease. To be sure of this before the date, check out [http://test-ipv6.com/](http://test-ipv6.com/). This site is an all-in-one readiness check for World IPv6 Day, or for IPv6 connectivity in general. If there are ANY problems with your setup, that site will let you know.

For more info, let me know in the comments!
