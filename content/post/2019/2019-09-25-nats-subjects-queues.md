---
layout: post
title: 'Controlling Information Flow: NATS Subjects and Queues'
author: Matt Oswalt
comments: true
categories: ['Blog']
featured_image: https://keepingitclassless.net/assets/2019/09/nats-queues-preview.png
date: 2019-09-25T00:00:00-00:00
tags:
  - 'go'
  - 'nats'
  - 'microservices'
---

Publish/subscribe messaging platforms like NATS allow us to build highly *event-driven* software systems, where we can build software to constantly listen for relevant messages and take action accordingly. This is what makes EDI projects like [StackStorm](https://github.com/stackstorm/st2) (a project I've worked on and [written about before](https://keepingitclassless.net/2016/12/introduction-to-stackstorm/)) - and others like it- so powerful.

Another advantage of pub/sub systems is that publishers don't have to know or care if anyone is listening. Whenever information needs to be sent, it's sent. It's up to the pub/sub system (in this case NATS) to decide what to do with it. Now - there are quite a variety of ways to control how these messages make it to one or more subscribers, and they all depend greatly on the implementation - NATS does things very differently from RabbitMQ, which does things differently from Kafka, etc.

In the [previous post](https://keepingitclassless.net/2019/09/kicking-the-tires-with-the-nats-go-client/)
I covered the basics of connecting to NATS in Go. In this post, I'd like to cover how information flow is controlled from publisher to subscriber in NATS using "Subjects" and "Queues".

# NATS Subjects

You've already seen [NATS Subjects](https://nats-io.github.io/docs/developer/concepts/subjects.html) in use in the
[previous post](https://keepingitclassless.net/2019/09/kicking-the-tires-with-the-nats-go-client/). To review,
when we called the `BindSendChan()` function to bind our channel to the NATS encoded client, we declared the subject name we wished to subscribe to: `request_subject`:

```go
requestChanSend := make(chan *Request)
ec.BindSendChan("request_subject", requestChanSend)
```

If we started multiple copies of our subscriber, each would receive an identical copy of any message sent to this subject:

<div style="text-align:center;"><script id="asciicast-SpKYqLkzTj4sIbwoBGOPfE3ug" src="https://asciinema.org/a/SpKYqLkzTj4sIbwoBGOPfE3ug.js" async></script></div>

However, there's a **lot** you can do with subject hierarchies and wildcards that further control who receives messages within a given subject. You can even create "wiretaps", which are useful if you want to monitor a given subject or subset for messages. The [documentation](https://nats-io.github.io/docs/developer/concepts/subjects.html) is your best bet for the details on all of the ways you can carve up subjects.

# Load-Balancing Messages using NATS Queues

One use case that is particularly interesting to me is the idea of having many stateless copies of a given program running in parallel for horizontal scaling. In this case, I only want one of these programs to receive a copy of a message. Otherwise I'd have multiple programs competing for the same work, and this is not good.

In NATS, ["Queues"](https://nats-io.github.io/docs/developer/concepts/queue.html) allow us to create a subset of subscribers within a Subject that participate in a load-balancing
group. This means that if a single message is sent into a subject and there are three subscribers on that subject that are members of a Queue, that message will only be received by a single subscriber. The next message will get randomly assigned again, and so on. This means we can create pools of "workers" that are all listening for messages that give them work to do.

> As mentioned in [the docs](https://nats-io.github.io/docs/developer/concepts/queue.html), a great feature of NATS is that all of this is determined by the application that is subscribing to the subject or queue - and requires no server configuration at all. Subscribers simply tell NATS how they would like to receive information when they connect.

In [this example](https://github.com/Mierdin/nats-go-examples/blob/master/example2/subscriber-queue.go), subscribing to a NATS Queue is mostly the same as before, but with a different function for binding to our channel:

```go
type Request struct {
  ID int
}
requestChanRecv := make(chan *Request)

// This allows us to subscribe to a queue within a subject
// for load balancing messages among subscribers.
// https://godoc.org/github.com/nats-io/go-nats#EncodedConn.BindRecvQueueChan
ec.BindRecvQueueChan("request_subject", "hello_queue", requestChanRecv)
```

> Note also that we can still subscribe to the subject without using a queue if we wish to receive a copy of all messages, and this won't affect subscribers that are still in the queue. This is useful for monitoring systems, or programs that can safely act on every message without having to coordinate, or have other methods of coordinating.

Spinning up multiple copies of a subscriber that uses this queue declaration means that NATS will only deliver a message to one of these:

<div style="text-align:center;"><script id="asciicast-dlS6WoZUTGtPeHrrkpSrJWEBq" src="https://asciinema.org/a/dlS6WoZUTGtPeHrrkpSrJWEBq.js" async></script></div>

Letting NATS do the heavy lifting here means I can now write programs to react to a given event based on their needs, and not worry about who else has the information it's acting on.

# Conclusion

If this was your first exposure to pub/sub systems, it's likely you might want something a little more high-level. While most resources are platform-specific, this video by Derek Collison is pretty good, and though it dives into NATS particulars later on in the video, the first half does a good job of overviewing various messaging patterns and fundamentals of pub/sub.

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/t_USxxOGzcw?start=589" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

I'm really starting to enjoy the way NATS does things - everything is kept as simple as possible but no more.
In the next post, I'll dive into how to structure your NATS code to be as reusable as possible (and also talk about a stupid mistake I made in blind pursuit of this goal). Until next time!
