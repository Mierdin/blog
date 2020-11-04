---
layout: post
title: 'Kicking the Tires With the NATS Go Client'
author: Matt Oswalt
comments: true
categories: ['Programming']
featured_image: https://nats-io.github.io/docs/nats-horizontal-color.png
date: 2019-09-22T00:00:00-00:00
tags:
  - 'go'
  - 'nats'
  - 'pubsub'
  - 'microservices'
---

I am doing some prototyping for a project and part of this includes becoming more familiar with the
[NATS](https://nats.io/) project, including its Go client (since all of the components in my
project that will be talking to NATS are written in Go). In short, I have a bunch of little services that
need to talk to each other, and a message broker like NATS fits the bill.

<div style="text-align:center;"><a href="https://nats-io.github.io/docs/nats-horizontal-color.png"><img src="https://nats-io.github.io/docs/nats-horizontal-color.png" width="500" ></a></div>

One thing that drew me to NATS specifically is that it is unapologetically - nay, **proudly** - simple.
In every [online talk](https://www.youtube.com/watch?v=t_USxxOGzcw) I've seen, this was made very clear
as an intentional contrast to some of the very robust and capable (but at times heavy-handed) messaging systems like Kafka or RabbitMQ.

So, part of my prototyping is aimed at deciding if the tradeoffs that the NATS project is making to achieve this
simplicity align with my goals. Regardless though - in the meantime, I figure I can get some good blog posts out of
it. In general, if you're new to the world of publish/subscribe messaging, I think NATS is a good place to start
because of its simplicity.

# Starting the NATS Server in Docker

It took me very little time to get up and running with NATS. The
[examples on their README](https://github.com/nats-io/nats.go#basic-usage) for the Go library are
really great, and running a nats server for my prototyping was a very simple docker one-liner:

```
~$ docker run --rm -d -p 4222:4222 -p 6222:6222 -p 8222:8222 --name nats-main nats
~$ docker logs nats-main -f

[1] 2019/09/20 20:32:29.227885 [INF] Starting nats-server version 2.0.4
[1] 2019/09/20 20:32:29.227911 [INF] Git commit [c8ca58e]
[1] 2019/09/20 20:32:29.228011 [INF] Starting http monitor on 0.0.0.0:8222
[1] 2019/09/20 20:32:29.228045 [INF] Listening for client connections on 0.0.0.0:4222
[1] 2019/09/20 20:32:29.228051 [INF] Server id is NAY4QGG2D52YN7C3PNREFB2S2KKQ6YYZLYYEEYHJ5W4VEXY5UMMJJIIQ
[1] 2019/09/20 20:32:29.228052 [INF] Server is ready
[1] 2019/09/20 20:32:29.228229 [INF] Listening for route connections on 0.0.0.0:6222
```

# Simple Pub/Sub Example

The objective is to send a native Go type from our publisher, to the subscriber. The subscriber will connect to NATS,
and wait for messages. The publisher will then connect to NATS and send messages, which will then be received by
the subscriber.

> Note that with the main NATS server, there's no message persistence - so any messages we send to NATS before any subscribers are connected are lost forever. There are some optional systems we can plug into NATS to provide this functionality, and I'll cover this in a future post, but for now, messages are either immediately received by a subscriber, or they're dropped.

I created two simple examples for this post:

- [natstest-publisher.go](https://github.com/Mierdin/nats-go-examples/blob/master/example1/natstest-publisher.go) - repeatedly sends messages into NATS with an incrementing counter, on a loop. 
- [natstest-subscriber.go](https://github.com/Mierdin/nats-go-examples/blob/master/example1/natstest-subscriber.go) - constantly listens for messages and prints them to the screen

> These are the links to the full source files - throughout this post we'll be highlighting specific sections, but please refer to these for the full context.

In the `main()` function for both of these programs, connecting to NATS is identical:

```go

// nats.Connect just gives us a bare connection to NATS
nc, err := nats.Connect(nats.DefaultURL)
if err != nil {
	panic(err)
}

// This wraps our bare connection and provides an encoding helper
// for making it easier to send/receive native Go types as messages
ec, err := nats.NewEncodedConn(nc, nats.JSON_ENCODER)
if err != nil {
	panic(err)
}
defer ec.Close()
```

At this point, we can use `ec` to send or receive messages, which we'll get to shortly.

## Publisher

We'll put together a very basic type for sending through NATS:

```go
type Request struct {
	Id int
}
```

> **IMPORTANT NOTE** - since we're using a JSON encoder with our connection, our custom type and its fields [**must** be exported]() (meaning start with a capital letter), otherwise you'll get strange issues like default/zero values. This is an [expected behavior of the standard JSON library in Go](https://blog.golang.org/json-and-go) and it has bit me more times than I care to admit.

Now - as outlined in the [Godoc for NATS](https://godoc.org/github.com/nats-io/go-nats), there are a number of
ways to publish messages to NATS. I am hugely in favor of creating a channel for sending these native types
and then using the `BindSendChan()` function of our encoded connection to bind this channel and use it for
sending to NATS.

```go
requestChanSend := make(chan *Request)
ec.BindSendChan("request_subject", requestChanSend)
```

> `request_subject` is the name for the subject we intend to send messages to. In NATS, a ["subject"](https://nats-io.github.io/docs/developer/concepts/subjects.html) is roughly equivalent to a Kafka "topic", or a RabbitMQ "queue". Our subscriber must subscribe to the same subject name to receive these messages.

Now, all we have to do to send messages into NATS is use this channel. For the sake of demonstration, I've
done this in a loop with a one-second pause per iteration:

```go
i := 0
for {

	// Create instance of type Request with Id set to
	// the current value of i
	req := Request{Id: i}

	// Just send to the channel! :)
	log.Infof("Sending request %d", req.Id)
	requestChanSend <- &req

	// Pause and increment counter
	time.Sleep(time.Second * 1)
	i = i + 1
}
```

Running the publisher is simple, and we see the expected log messages.

```
go run example1/natstest-publisher.go
INFO[0000] Connected to NATS and ready to send messages 
INFO[0000] Sending request 0                            
INFO[0001] Sending request 1                            
INFO[0002] Sending request 2                            
INFO[0003] Sending request 3                            
INFO[0004] Sending request 4                            
INFO[0005] Sending request 5   
```

Note again that in this basic NATS setup, all messages sent while there are no subscribers to receive them
are lost - so let's get a subscriber up and running.

## Subscriber

With respect to setting up an encoded connection to NATS, the code for the subscriber is exactly the same.

Even the code that establishes a channel and binds it to the NATS encoded connection is similar, albeit
with a different function name that indicates we intend to receive messages, instead of send them:

```go
type Request struct {
	Id int
}
requestChanRecv := make(chan *Request)
ec.BindRecvChan("request_subject", requestChanRecv)
```

Again, we now have native Go constructs to work with, and listening for channels is a blocking operation,
meaning we can do this in a loop with no pause, and messages will be processed (in this case, logged to screen)
as soon as they're received:

```go
for {
	// Wait for incoming messages
	req := <-requestChanRecv

	log.Infof("Received request: %d", req.Id)
}
```

# Demo

Here's a quick demo of this process in action:

<div style="text-align: center;"><script id="asciicast-x8zcG005zW2CaVhAoDwXHNyQc" src="https://asciinema.org/a/x8zcG005zW2CaVhAoDwXHNyQc.js" async></script></div>

# More Soon!

It's still early, but I love what I've seen thus far. I especially like the ability to tie the client to
native Go constructs, so that it doesn't even feel like I'm sending data to NATS - just sending native
Go types into a channel.

I have a lot more prototyping to do, and I expect this will result in more blog posts on NATS.
Let me know in the comments below if you have ideas for specific things you want me to cover, either within
NATS, Go, or pub/sub messaging in general.

In the meantime, the below resources are useful to have bookmarked as you get started with the subjects
in this post.

- [NATS Documentation](https://nats-io.github.io)
- [NATS Go Client Code](https://github.com/nats-io/nats.go)
- [NATS Go Client Documentation](https://godoc.org/github.com/nats-io/go-nats)
