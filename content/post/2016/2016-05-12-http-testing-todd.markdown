---
layout: post
title: Introducing HTTP Testing in ToDD
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2016-05-12"
slug: introducing-http-testing-todd
tags: ['go']
---


Now that [ToDD has been in the public arena for two months](https://keepingitclassless.net/2016/03/test-driven-network-automation/), one of the things I'm happiest about is the fact that testing in ToDD is totally flexible. Thanks to the concept of [testlets](https://todd.readthedocs.io/en/latest/testlets.html), ToDD doesn't have an opinion on the specifics of your tests - all of that logic is contained within the testlet.

I believe there's real value in going further than simple "ping" tests when validating that your network is working as you expect. Customers aren't pinging you - they're using your applications. To that end, I have introduced [a new testlet](https://github.com/toddproject/todd/blob/master/agent/testing/testlets/http) to the ToDD project that makes HTTP calls and reports on application-level metrics.

There are some very real advantages to testing HTTP reachability instead of settling for simple "ping" tests. In addition to verifying network connectivity, HTTP testing also ensures that the web application is also up and able to produce the desired status code. We're also able to get some insight into performance at the application level.

In my initial presentations on ToDD, I talked about a use case for being able to "keep your SaaS providers honest" by making HTTP requests against the services you use in a distributed manner:
<div style="text-align:center;"><a href="assets/2016/03/usecase1.png"><img src="assets/2016/03/usecase1.png" width="700" ></a></div>

The new HTTP testlet fundamentally wraps [curl](https://curl.haxx.se/) and uses the template-able output from that utility to extract metrics like status codes, and end-to-end latency. See the example below for the full list of metrics exposed by this testlet:
<div style="text-align:center;"><a href="assets/2016/05/http_todd_output.png"><img src="assets/2016/05/http_todd_output.png" width="700" ></a></div>

There's much more you could (and probably should) do with this HTTP testing within your own organization. For instance, while this testlet does ensure that an HTTP connection can be made, and provides insight into basic performance numbers, it is not able to do things like conduct transactions.

This is one of the greatest examples of why I chose to make testlets as flexible as possible. It's important to go further than I did, and write your own testlet that is able to perform transactions on your organization's web applications, to more closely mimic real-world usage. However, generic HTTP connectivity is simpler, and that's why I've included that testlet within ToDD.

Naturally, all of these metrics are exported into a TSDB like InfluxDB:

<div style="text-align:center;padding-bottom: 20px;"><a href="assets/2016/05/http_todd_influx.png"><img src="assets/2016/05/http_todd_influx.png" width="900" ></a></div>

Which also means we can immediately make use of this data in a visualization tool like Grafana:

<div style="text-align:center;padding-bottom: 20px;"><a href="assets/2016/05/http_todd_grafana.png"><img src="assets/2016/05/http_todd_grafana.png" width="900" ></a></div>

This is just one step on the journey of being able to easily run application-level testing on our network infrastructure to help us gain the confidence we need to move forward with network automation! Please check out the [ToDD documentation](https://todd.readthedocs.io/) or check out the [mailing list](https://groups.google.com/forum/#!forum/todd-dev) if you have any questions or run into any problems!
