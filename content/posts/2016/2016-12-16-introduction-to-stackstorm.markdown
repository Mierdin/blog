---
layout: post
title: Introduction to StackStorm
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2016-12-16"
slug: introduction-to-stackstorm
tags: ['automation']
---


[Earlier](https://oswalt.dev/2016/10/principles-of-automation/) I wrote about some fundamental principles that I believe apply to any form of automation, whether it's network automation, or even building a virtual factory.

One of the most important concepts in mature automation is **autonomy**; that is, a system that is more or less self-sufficent. Instead of relying on human beings for input, always try to provide that input with yet another automated piece of the system. There are several benefits to this approach:

- **Humans Make Mistakes** - This is also a benefit of automation in general, but autonomy also means mistakes are lessened on the input as well as the output of an automation component. 
- **Humans Are Slow** - we have lives outside of work, and it's important to be able to have a system that reacts quickly, instead of waiting for us to get to work. We need a system that is "programmed" by us, and is able to do work on our behalf.
- **Signal To Noise** - Sometimes humans just don't need to be involved. We've all been there - an inbox full of noisy alerts that don't really mean much. Instead, configure specific triggers that act on your behalf when certain conditions are met

The reality is that we as operations teams are already event-driven by nature, we're just doing it in our brains. Every operations shop works this way; there is a monitoring tool in place, and the ops folks watch for alerts and respond in some sort of planned way. This sort of event-driven activity is happening all the time without us thinking about it. As you explore the concepts below, note that the main focus here is to simply reproduce those reactions in an automated way with StackStorm.

These are all concepts I've been seriously pondering for the past 2 years, and have spoken about at several conferences like [Interop](https://oswalt.dev/2016/04/interop-vegas-2016/). Recently, when [I saw what the team at StackStorm was building](https://www.youtube.com/watch?v=M_hacp2qd70), and how well it aligned with my beliefs about mature automation practices, [I had to get involved](https://oswalt.dev/2016/10/new-automation-chapter-begins/).

StackStorm is event-driven automation. As opposed to alternative approaches (which have their own unique benefits) that rely on human input, StackStorm works on the premise that a human being will instead configure the system to watch for certain events and react autonomously on their behalf.

I recently attended [NFD12](http://techfieldday.com/event/nfd12) as a delegate, and was witness to a presentation by the excellent and articulate Dmitri Zimine (shameless brown nosing, he's my boss now):

<div style="text-align:center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/M_hacp2qd70" frameborder="0" allowfullscreen></iframe></div>

# Infrastructure as Code

Before I get into the details of StackStorm concepts, it's also important to remember one of the key fundamentals of next-generation operations, which is the fantastic buzzword "Infrastructure as Code". Yes it's a buzzword but there's some good stuff there. There is real value in being able to describe your infrastructure using straightforward, version-controlled text files, and being able to use these files to provision new infrastructure with ease.

Every concept in StackStorm can be described using simple YAML, or languages like Python. This is done for a reason: to enable infrastructure-as-code and event-driven automation to work in harmony. Just like any programming language, or automation tool, this domain-specific language (DSL) that StackStorm uses will take some time to learn, but it's all aimed at promoting infrastructure-as-code concepts. The DSL is the single source of truth, treat it as such. For instance, use mature Continuous Integration practices (including automated testing and code peer review) when making changes to it. Perform automated tests and checks when changes are made. This will make your operations much more stable.

> Note that while you should always treat these YAML files as the single source of truth, there are also some tools in StackStorm that allow you to generate this syntax using a friendly GUI.

# StackStorm Concepts

Now, let's explore some Stackstorm concepts.

## Packs

One of the biggest strengths of StackStorm is its ecosystem. StackStorm's recent 2.1 release included a new [Exchange](https://exchange.stackstorm.org/) which provides a new home for the **over 450 integrations** that already exist as part of the StackStorm ecosystem. These integrations allow StackStorm to interact with 3rd party systems.

<div style="text-align:center;"><a href="/assets/2016/10/exchange.png"><img src="/assets/2016/10/exchange.png" width="900" ></a></div>

In StackStorm, we call these integrations with ["Packs"](https://docs.stackstorm.com/packs.html). Packs are the atomic unit of deployment for integrations and extensions to StackStorm. This means that regardless of what you're trying to implement, whether it's a new Action, Sensor, Rule, or Sensor, it's done with Packs.

As of StackStorm 2.1, pack management has also been re-vamped and improved (we'll explore packs and pack management in detail in a future post). Installing a new integration is a one-line command. Want to allow StackStorm to run Ansible playbooks? Just run:

    st2 pack install ansible

Now that we've covered packs, let's talk about some of the components you will likely find in a pack.

## Actions

Though it's important to understand that StackStorm is all about event-driven automation, it's also useful to spend some time talking about what StackStorm can **do**. Being able to watch for all the events in the world isn't very useful if you can't do anything about what you see. In StackStorm, we can accomplish such things through "[Actions](https://docs.stackstorm.com/actions.html)". Some examples include:

- Push a new router configuration
- Restart a service on a server
- Create a virtual machine
- Acknowledge a Nagios / PagerDuty alert
- Bounce a switchport
- Send a message to Slack
- Start a Docker container

There are many others - and the list is growing all the time in the StackStorm [Exchange](https://exchange.stackstorm.org/).

One of things that attracted me to the StackStorm project is the fact that Actions are designed very generically, meaning they can be written in any language. This is similar to what I've done with testlets in [ToDD](https://github.com/toddproject), and what Ansible has done with their modules. This generic interface allows you to take scripts you already have and are using in your environment, and begin using them as event-driven actions, [with only a bit of additional logic](https://docs.stackstorm.com/actions.html#converting-existing-scripts-into-actions). As long as that script conforms to this standard, they can be used as an Action.

There are several actions bundled with StackStorm (truncated for easy display):

    vagrant@st2learn:~$ st2 action list                                                           
    +---------------------------------+---------+-------------------------------------------------
    | ref                             | pack    | description                                     
    +---------------------------------+---------+-------------------------------------------------
    | chatops.format_execution_result | chatops | Format an execution result for chatops          
    | chatops.post_message            | chatops | Post a message to stream for chatops            
    | chatops.post_result             | chatops | Post an execution result to stream for chatops  
    | core.announcement               | core    | Action that broadcasts the announcement to all s
    |                                 |         | consumers.                                      
    | core.http                       | core    | Action that performs an http request.           
    | core.local                      | core    | Action that executes an arbitrary Linux command 
    |                                 |         | localhost.                                      

It's important to consider these since they may provide you with the functionality you need out of the gate. For instance, lots of systems these days come with REST APIs, and "core.http", which allows you to send an HTTP request, may be all the Action functionality you need. Even if the predefined Actions don't suit you, check the [Exchange](https://exchange.stackstorm.org/) for a pack that may include an Action that gives you the functionality you're looking for.

Nevertheless, it may sometimes be necessary to create your own Actions.. We'll go through this in a future blog post, but for now, understand that actions are defined by two files:

- A metadata file, usually in YAML, that describes the action to StackStorm
- A script file (i.e. Python) that implements the Action logic

Actions may depend on certain environmental factors to run. StackStorm makes this possible through "Action Runners". For instance, you may have a Python script you wish to use as an Action; in this case, you'd leverage the "python-script" runner. Alternatively, you may just want to run an existing Linux command as your Action. In this case you would want to use the "local-shell-cmd" runner. There are [many other published runners](local-shell-cmd), with more on the way.

## Sensors and Triggers

For event-driven automation to work, information about the world needs to be brought in to the system so that we can act upon it. In StackStorm, this is done through [Sensors](https://docs.stackstorm.com/sensors.html). Sensors, like your own sense of sight or smell, allow StackStorm to observe the world around it, so that actions can eventually be taken on that information.

> StackStorm was not designed to be a monitoring tool, so you'll still want to use whatever monitoring you already have in place. Sensors can/should be used to get data out of a monitoring system and take action accordingly.

Sensors can be active or passive. An example of an "active" sensor would be something that actively polls an external entity, like Twitter's API, for instance. Alternatively, sensors can also be passive; an example of this would be a sensor that subscribes to a message queue, or a streaming API, and simply sits quietly until a message is received.

Both sensor types bring data into StackStorm, but the data is somewhat raw. In order to make sense of the data brought in by sensors, and to allow StackStorm to take action on that data, Sensors can also define "Triggers". These help StackStorm identify incoming "events" from the raw telemetry brought in by Sensors. Triggers are useful primarily when creating a Rule, which is explained in the next section.

Similarly to Actions, Sensors are defined using two files:

- A YAML metadata file describing the sensor to StackStorm
- A Python script that implements the sensor logic

An example YAML metadata file might look like this:

    ---
    class_name: "SampleSensor"
    entry_point: "sample_sensor.py"
    description: "Sample sensor that emits triggers."
    trigger_types:
    - name: "event"
      description: "An example trigger."
      payload_schema:
        type: "object"
        properties:
          executed_at:
            type: "string"
            format: "date-time"
            default: "2014-07-30 05:04:24.578325"

> The particular implementation of the Sensor will determine if it is a "passive" or "active sensor"; there are two Python classes that you can inherit from to determine which Sensor type you're creating.

## Rules

"[Rules](https://docs.stackstorm.com/rules.html)" bring the two concepts of Sensors and Actions together. A Rule is a definition that, in English, says "when this happens, do this other thing". You may remember that Sensors bring data into StackStorm, and Triggers allow StackStorm to get a handle on when certain things happen with that data. Rules make event-driven automation possible by watching these Triggers, and kicking off an Action (or a Workflow, as we'll see in the next section).

Rules are primarily composed of three components:

- **Trigger**: "What trigger should I watch?""
- **Criteria**: "How do I know when that trigger indicates I should do something?""
- **Action**: "What should I do?""

This is a straightforward concept if you look at a sample YAML definition for a Rule:

    ---
    name: "rule_name"                      # required
    pack: "examples"                       # optional
    description: "Rule description."       # optional
    enabled: true                          # required

    trigger:                               # required
        type: "trigger_type_ref"

    criteria:                              # optional
        trigger.payload_parameter_name1:
            type: "regex"
            pattern : "^value$"
        trigger.payload_parameter_name2:
            type: "iequals"
            pattern : "watchevent"

    action:                                # required
        ref: "action_ref"
        parameters:                        # optional
            foo: "bar"
            baz: "{{trigger.payload_parameter_1}}"

Think of "Rules" as the foundation of event-driven automation. They really are the core of what makes "If ___ then ___" possible.

Stackstorm's architecture keeps everything very logically separate. Sensors sense. Actions act. Then, rules tie them together and allow you to have a truly autonomous system as a result.

## Workflows

Even simple actions rarely take place in isolation. For instance, when you detect that an application node has shut down, there could be ten or more discrete things you need to do in order to properly decommission that node in related systems. So, event-driven automation isn't always just about kicking off a single action, but rather a "[Workflow](https://docs.stackstorm.com/workflows.html)" of actions.

In StackStorm, we use [OpenStack Mistral](https://wiki.openstack.org/wiki/Mistral) to define workflows. Mistral is a service that's part of the OpenStack project, and we [bundle it with StackStorm](https://docs.stackstorm.com/mistral.html). Mistral also [defines a YAML-based Domain-Specific Language (DSL)](http://docs.openstack.org/developer/mistral/dsl/dsl_v2.html) that's used to define the logic and flow of the workflow.

In the following simple example, we define a Mistral workflow that accepts an arbitrary linux command as input, runs it, and prints the result to stdout:

    ---
    version: '2.0'

    examples.mistral-basic:
        description: A basic workflow that runs an arbitrary linux command.
        type: direct
        input:
            - cmd
        output:
            stdout: <% $.stdout %>
        tasks:
            task1:
                action: core.local cmd=<% $.cmd %>
                publish:
                    stdout: <% task(task1).result.stdout %>
                    stderr: <% task(task1).result.stderr %>

Workflows are also powerful in that you can make decisions within them and take different actions depending on the output of previous tasks. This is done by inserting little "[YAQL](https://docs.stackstorm.com/mistral_yaql.html)" statements in the workflow (note the statements underneath "on-success" below):

    ---
    version: '2.0'

    examples.mistral-branching:
        description: >
            A sample workflow that demonstrates how to use conditions
            to determine which path in the workflow to take.
        type: direct
        input:
            - which
        tasks:
            t1:
                action: core.local
                input:
                    cmd: "printf <% $.which %>"
                publish:
                    path: <% task(t1).result.stdout %>
                on-success:
                    - a: <% $.path = 'a' %>
                    - b: <% $.path = 'b' %>
                    - c: <% not $.path in list(a, b) %>
            a:
                action: core.local
                input:
                    cmd: "echo 'Took path A.'"
            b:
                action: core.local
                input:
                    cmd: "echo 'Took path B.'"
            c:
                action: core.local
                input:
                    cmd: "echo 'Took path C.'"

Based on the output from task "t1", we can choose which of the next tasks will take place.

As you can see, Mistral workflows can be simple when you want it to be, but can also scale up to really powerful complex workflows as well. See the [StackStorm/Mistral](https://docs.stackstorm.com/mistral.html) documentation for more examples.


# Conclusion

StackStorm has a huge community and it's growing. Check out our [Community](https://stackstorm.com/#community) page, where you'll find information about how to contact us. Also make sure you follow the links there to join the Slack community (free and open), we'd love to have you even if you just want to ask some questions.

Our [2.1 release also happened recently](https://stackstorm.com/2016/12/06/2-1-new-pack-management/), and it introduces a lot of new features. We're working hard to keep putting more awesome into StackStorm, and actively want your feedback on it. There's a lot of opportunity for the network industry in particular to take advantage of event-driven automation, and I personally will be working very hard to bridge the gap between the two.

Thanks for reading, and stay tuned for the next post, covering the internal architecture of StackStorm.
