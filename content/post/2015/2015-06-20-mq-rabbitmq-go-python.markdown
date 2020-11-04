---
layout: post
title: 'Message Queues: RabbitMQ in Go and Python'
author: Matt Oswalt
comments: true
categories: ['Programming']
date: "2015-06-20"
slug: mq-rabbitmq-go-python
tags: ['message', 'queues']
---


I've been playing around with various message queue implementations for a few projects, and wanted to write a quick post on some basics.

# Message Queues

Before we get into the detail of RabbitMQ, it's worth briefly defining exactly what a message queue is, of which RabbitMQ is just one implementation. 

You may have heard message queues described as a "Publish/Subscribe" system, or "Pub/Sub" for short. This is a style of communication between software elements, where some components publish messages onto a queue, and others subscribe to that queue and listen for messages published on to it. 

We'll use Twitter as an illustrative analogy. I sent a link to this blog article within a tweet this morning. I did not address this tweet to anyone in particular, I just put it out there, assuming it was useful to at least somebody. Those that follow me saw this tweet, and made a decision to do something with this information or not. In this scenario, I was the publisher, and my followers were subscribers. Message Queues work very much the same way, but they also provide a much greater level of granularity for how to publish messages and subscribe to them.

Application developers are using message queues for all kinds of things, but in short, it provides a much simpler communication mechanism as opposed to dealing with RPCs or TCP sockets. Message queues are a very popular choice for communicating between nodes of a distributed application. However, it could also be used to communicate between processes, or even threads, on a single machine.

# RabbitMQ

There are several message queue implementations, each with their benefit and drawbacks. I'll have to save that comparison for another post. For now, we're going to look specifically at RabbitMQ - it is a very popular choice for those looking to get started with MQs, and it's known to have been used in a lot of large-scale implementations. It is just one implementation of a message queue transport standard known as [Advanced Message Queueing Protocol, or AMQP](https://www.amqp.org/).

The various components of an application will point to the RabbitMQ server, and provide details on what queues they are subscribing to, what exchanges they want to publish messages to, etc. The RabbitMQ server will then take care of sending those messages to where they need to go based on those parameters.

The RabbitMQ site has some [really great tutorials](https://www.rabbitmq.com/getstarted.html) so I won't re-invent the wheel here. However, I would like to quickly recap some terminology:
- Producer - an application that publishes or sends messages
- Consumer - an application that receives messages
- Queue - Think of these as a buffer for messages (like your postal mailbox).
- Exchange - A producer sends messages directly to an exchange, and the exchange decides what to do with the message (send to queue(s), discard, broadcast, etc)

> The specifics of how an exchange delivers messages to queues totally depends on the exchange type and the routing configuration. For the purpose of demonstration, the examples in the next section will use a "fanout" exchange, which is more or less a broadcast (deliver to all queues).

AMQP runs over TCP which provides some level of reliability, but this connection is between the RabbitMQ server and the endpoints, not between the endpoints themselves. Plus, there are application-level considerations; for instance, how do we guarantee message delivery if the producer is not directly connected to the consumer? Should we be concerned about consumers crashing and not receiving the producer's messages? All these questions can be answered with [RabbitMQ's reliability guide](https://www.rabbitmq.com/reliability.html). Most of the answers to these questions are part of the AMQP standard, but some are RabbitMQ-specific extensions.

# Practical Examples

I would like to demonstrate a quick consumer and producer using Python and Go, respectively. There are plenty of examples in the [RabbitMQ tutorial section](https://www.rabbitmq.com/getstarted.html) and those examples leverage an AMQP library called [Pika](https://pika.readthedocs.org/en/0.9.14/). I am instead using a library called [rabbitpy](http://rabbitpy.readthedocs.org/en/latest/), which I think is a bit easier to use than Pika (though it is specific to RabbitMQ).

{{< highlight python >}}
import rabbitpy

with rabbitpy.Connection('amqp://guest:guest@10.12.0.15:5672/%2f') as conn:
    with conn.channel() as channel:
        queue = rabbitpy.Queue(channel, 'example')
        queue.declare()  # Idempotent queue declaration
        queue.bind('test_exchange')

        # Exit on CTRL-C
        try:
            # Consume the message
            for message in queue:
                message.pprint(True)
                message.ack()

        except KeyboardInterrupt:
            print 'Exited consumer'
{{< /highlight >}}

> In this example (this feature is present in other AMQP libraries as well) the declaration - or creation - of the queue is idempotent. Meaning that we can safely run the function "queue.declare()" and not have to worry about checking if it exists first. If it doesn't, it will be created. If it does, this line basically does nothing.

In the above script, the iterator made available by "queue" is actually a generator - and as long as you're iterating over it, it will continue to listen for new messages. This means we can simply run this script and it will participate in this queue, listening for messages until we cancel it. So, let's write a quick producer in Go.
	
There are some examples for RabbitMQ in Go on their [Github profile](https://github.com/rabbitmq/rabbitmq-tutorials/tree/master/go), but I'll provide a simple one here. We will be using a [standard AMQP library](https://github.com/streadway/amqp) to write our producer.

	package main

	import (
	    "fmt"
	    "log"

	    "github.com/streadway/amqp"
	)

	func failOnError(err error, msg string) {
	    if err != nil {
	        log.Fatalf("%s: %s", msg, err)
	        panic(fmt.Sprintf("%s: %s", msg, err))
	    }
	}

	func main() {
	    conn, err := amqp.Dial("amqp://guest:guest@10.12.0.15:5672/")
	    failOnError(err, "Failed to connect to RabbitMQ")
	    defer conn.Close()

	    ch, err := conn.Channel()
	    failOnError(err, "Failed to open a channel")
	    defer ch.Close()

	    q, err := ch.QueueDeclare(
	        "routingkey", // name
	        false,   // durable
	        false,   // delete when usused
	        false,   // exclusive
	        false,   // no-wait
	        nil,     // arguments
	    )
	    failOnError(err, "Failed to declare a queue")

	    body := "LA DEE DA, THIS IS OUR SUPER COOL MESSAGE"
	    err = ch.Publish(
	        "test_exchange", // exchange
	        q.Name,          // routing key
	        false,           // mandatory
	        false,           // immediate
	        amqp.Publishing{
	            ContentType: "text/plain",
	            Body:        []byte(body),
	        })
	    failOnError(err, "Failed to publish a message")
	}

We can run our Go program using "go run", and our already-running Python program will provide us the following info:

	Exchange: test_exchange

	Routing Key: routingkey

	Properties:

	{'app_id': '',
	 'cluster_id': '',
	 'content_encoding': '',
	 'content_type': 'text/plain',
	 'correlation_id': '',
	 'delivery_mode': None,
	 'expiration': '',
	 'headers': None,
	 'message_id': '',
	 'message_type': '',
	 'priority': None,
	 'reply_to': '',
	 'timestamp': None,
	 'user_id': ''}

	Body:

	'LA DEE DA, THIS IS OUR SUPER COOL MESSAGE'

As you can see, we not only get the super awesome message body at the bottom, we're provided with all kind of interesting metadata that I'm not even using at the moment.  

> It's worth noting that producers can only publish a message if there is a route for it. For instance, even on fanout exchanges, if there are no queues (meaning no active consumers) to send to, then your library will likely return some kind of exception.

# Conclusion

I hope you enjoyed this introduction to RabbitMQ and message queues - thanks for learning with me!

