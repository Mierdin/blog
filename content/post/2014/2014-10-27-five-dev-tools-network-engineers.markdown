---
layout: post
title: 5 Dev Tools for Network Engineers
series:
- DevOps for Networking
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-10-27"
wordpress_id: 5964
slug: five-dev-tools-network-engineers
tags: ['ansible']
---


I'd like to write about five things that you as a hardcore, operations-focused network engineer can do to evolve your skillsets, and take advantage of some of the methodologies that have for so long given huge benefits to the software development community. I won't be showing you how to write code - this is less about programming, and more about the tools that software developers use every day to work more efficiently. I believe in this, there is a lot of potential benefit to network engineering and operations.

I'm of the opinion that "once you know what you don't know, you're halfway there". After all, if you don't know what you don't know, then you can't very well learn what you don't know, can you? In that spirit, this article will introduce a few concepts briefly, and every single one will require a lot of hands-on practice and research to really understand thoroughly. However, it's a good starting point, and I think if you can add even a few of these skills, your marketability as a network engineer will increase dramatically.

## Proper Version Control

As a developer, version control is an absolute must-have. Being able to track changes to source code is essential - even the smallest change can cause all kinds of things to break. Developers traditionally have used several types of version control, such as Subversion, or CVS. "Git" is another very popular version control tool, which I feel is vastly superior to the alternatives.

A developer would use a tool like Git to record changes to source code, configuration files, directory structures, etc. For instance, here's a record of change that a developer made to some Python to implement a new amazing function:

[![version1](assets/2014/10/version1.png)](assets/2014/10/version1.png)

Some network engineers have already used tools like [RANCID](http://www.shrubbery.net/rancid/) to show what's changed in different versions of switch configurations (RANCID actually uses CVS or Subversion in the back-end for producing the actual text differences). This tool has been around for a while, and the use cases are somewhat limited, but from a version control perspective, the idea is the same.

Here's an example of how Git can produce similar output to show the addition of VLAN 11 to a Cisco Nexus switch:

[![version2](assets/2014/10/version2.png)](assets/2014/10/version2.png)

There are plenty of resources for learning Git, whether you have a little development experience, or none at all. I'd recommend [this intro](http://git-scm.com/book/en/Getting-Started-Git-Basics), or if you prefer a more interactive tutorial, [this one](https://try.github.io/levels/1/challenges/1) is pretty good. Git is built to be distributed, meaning that there is no implied dependency on a "version control server" like Subversion. You could have a git repository completely self-contained on your laptop, without the need to run any kind of server software if you wanted to.

However, in many cases, it's important to collaborate over the files that you are tracking in your Git repository. For developers, this is often source code (think multiple devs working on the same project) but it could very easily be two senior network engineers working on 50 switch configurations. So though it's not required, you can absolutely push your local changes to a remote server where multiple people can see it. All work could be done in a distributed fashion, and when engineers finish their work, they simply push it to this remote server.

A popular example of this is GitHub (check out their [online help](https://help.github.com/) for more info)- which in addition to being a remote git server, also has a myriad of tools for collaboration. However, GitHub is just one site - and there are plenty of other hosted solutions (i.e. [BitBucket](https://bitbucket.org/)), or are downloadable as a server on your own internal network (i.e. [Gerrit](https://code.google.com/p/gerrit/)).

I first recommend learning Git itself - that's where you as a network engineer can derive immediate value. Once you're comfortable with Git on your own command line, you'll have the right perspective to pick up collaborative tools like GitHub.

No matter the tool, the important thing is that you as a network engineer strive to get all of your switch configurations into some kind of version control system - preferably in an automated fashion. Clearly my preference is Git, but in truth, anything will do. What's important is being able to track changes to a configuration in an easy way, that doesn't depend on bulky management servers from a networking vendor. Enforce some level of accountability for what happens on your networking devices.

## Dynamic Templates

The idea of using templates to drive configuration of network devices is something that has HUGE and immediate benefit to network engineers, but sadly not many are using them. Of the small number of folks I've seen doing anything like this, it's usually some ugly Microsoft Excel macro that they've used for years and never shared with anyone. In addition, it's mostly since I started working for resellers that I really started to see this behavior, which tells me that it was only done out of a desire to reduce repetition when building switch configurations (reseller engineers touch a LOT of gear). Admirable of course, but not the total picture of why templates are useful.

That said, before I get into the details of what I've used in this space, I'd like to make two points about templates:
    
  1. They're not just for you. Just like developers usually write code to be consumed and re-used by others, we as network engineers need to write really slick configuration templates because we're the experts, and because someone else is going to have to make sense of this switch configuration later.
    
  2. Using templates helps to enforce consistency and a decided-upon schema. You want to add a remark to each access-list entry so you know what it's for? Then implement a template that requires a remark as an argument. Force all configuration changes to go through a system that leverages these templates.

Now that's out of the way, I highly recommend you check out [Jinja2](http://jinja.pocoo.org/docs/dev/) - a templating language used in a variety of applications. For instance, the Django web framework uses a near-identical syntax as a method of rendering web pages. Ansible's [template](http://docs.ansible.com/template_module.html) module is also a popular way to create server configurations from Jinja templates.

> I've [written about Jinja2 before](https://keepingitclassless.net/2014/03/network-config-templates-jinja2/), and I consider it a good introduction to the idea of using templates for network configuration files. In that post, I rendered templates using a little bit of Python, but Jinja2 is also implemented in a number of existing configuration management tools [like Ansible](http://docs.ansible.com/template_module.html), which don't require you to know any programming language.

However, there's a powerful application for networking as well - after all, these templates just render like text files. Switch and router configurations really are nothing more than that. What if we could create a template that loops through a list of VLANs, and automatically renders them into a switch configuration, rather than having you write them yourself.

{% raw >}}
    {% for id, name in vlanlist ->}}
    vlan {{ id }}
        name {{ name }}
    {% endfor >}}
{% endraw >}}

You could also  use the same method to get rid of those peskey crypto key statements, and ensure it's typed the right way every time:

{% raw >}}
    crypto isakmp key {{ cryptokey }} address {{ peeraddr }}
{% endraw >}}

These are very simple applications and the Jinja language is quite powerful; review the [documentation](http://jinja.pocoo.org/docs/dev/) and think about how you could use this syntax to drive switch configurations.

Templates are a great way for seasoned network engineers to impart their experience and delegate tasks to junior network engineers or automation toolkits. Someone who knows how the network works will still have to sit down and write these templates out. Templates don't automatically configure a BGP peer, for instance. However, it does take a whole lot of repetitive work out of the task, and removes a lot of potential human error.

Keep those two points in mind about templates. Whether you use them to generate a switch config manually (i.e. copy + paste) or use them as part of an automation framework, either way it's a step in the right direction.

## Text Editors or IDEs?

There are a myriad of tools available for working with all kinds of text files and for different purposes. TL;DR, the choice is pretty much totally dependent on your own preference, and what specific tasks you're looking to accomplish.

Generally speaking, as a network engineer looking to get syntax highlighting, or maybe some basic style checking, most "advanced" text editors like Sublime Text or Notepad++ will do the job. In both of these cases, the vanilla software itself is pretty good, but there's also a very long list of plugins available that you can use to extend the existing functionality.

I know a lot of network engineers out there are trying to learn Python, and Sublime Text is a popular choice. Here's an example with the Anaconda plugin, which is letting me know that my Python - while functional, doesn't conform to PEP8 standards. This is a useful tool to have, since it allows me to correct errors as I go, rather than accumulating [technical debt](http://en.wikipedia.org/wiki/Technical_debt).

[![Screenshot 2014-10-24 23.57.45](assets/2014/10/Screenshot-2014-10-24-23.57.45.png)](assets/2014/10/Screenshot-2014-10-24-23.57.45.png)

However, many network engineers have no interest in writing Python, so maybe you're writing a configuration template in Jinja2. There's a [plugin](https://sublime.wbond.net/packages/Jinja2) for that. My suggestion is to find an editor that works for you first, and fill in the blanks with plugins if you need to. At the end of day, these are not specific to software developers - they are text editors with a bunch of tools for getting stuff done. As a network engineer, you can still make these tools work for you.

IDEs, or Integrated Development Environments have historically gone well beyond traditional text editors. If you're a Java developer, most of the time you use Eclipse. If you work with .NET, you're looking at Visual Studio. This is because these are powerful software suites that focus on a specific family of programming languages, and have tons of built-in functionality like built in compiling, debugging, autocompletion, version control connectivity, etc.

However, these are a bit overkill for the average network engineer looking to extend their capabilities. These days, the plugin ecosystem for traditional text editors is so good, (we even have [autocomplete functionality](https://github.com/Valloric/YouCompleteMe) for Vim) it's hard for me to recommend a full blown IDE. Like I said, pick a text editor that you think will work for you - at this point, most of them are so good it's almost completely up to personal preference.

## Configuration Management

If you're researching topics like DevOps, configuration management tools like Puppet, Chef and Ansible probably show up often. While I believe that the point of "DevOps" is more about people and process, it's understandable that these tools come up in Google searches or conversations. They've certainly made life a lot easier for managing server configurations. But what about networking? What could these tools (or perhaps others) offer to a network engineer?

I alluded to an example earlier while discussing templates. Templating languages like Jinja2 show a lot of promise, but requiring Python skills in order to populate these templates with data is a non-starter for many network engineers. Ansible, as an example, contains a "template" module, which allows you to write the template, and populate it very easily with data stored in your playbook or role.

It doesn't stop there. Several companies have been hard at work putting these tools to use in networking. Here's a great demo by Cumulus' [Leslie Carr](https://twitter.com/lesliegeek) where she shows Puppet in action on a switch running Cumulus Linux. This is a great video, and really shows a lot of cool use cases.

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/cHQdRpHCq0o" frameborder="0" allowfullscreen></iframe></div>

In essence, configuration management tools offer a level of abstraction from the details of what it is you're configuring. As an example, you can configure an Apache server on Linux fairly easily using a tool like Puppet and Chef, because they have been written to automate the repetitive details, and require only the information from you that it needs to work.

> I have set up Ansible at home to manage my Bind DNS server (as well as many other things), and I don't have to write configuration files at all anymore - I just add A records to a small text file, and Ansible is able to not only make the configuration changes, but on as many different servers and operating systems that I specify - all with a single action.

The implementation details differ for networking of course, but the idea is the same - reduce the complexity involved with dealing with network devices one-by-one, and remove any repetitive work, offloading it to the tool to take care of (there is no reason we as human beings should be typing in the same BGP peer statements on every new router we stand up).

I think the bigger point here is that configuration management tools enable us to treat our infrastructure (first servers, now switches/routers/firewalls/etc.) like cattle, instead of pets. This is because they didn't require anyone to know how to write Python, or Ruby, or even the occasional bash script. Though I'd argue those are insanely useful skill sets, we're talking about operations enablement here - which applies to both networking and server administration. I think we've only begun to see the tools ecosystem take shape in networking; the next 5 years will be very interesting.

## Workflow Management

Last, but certainly not least, I'd like to talk about workflows. We all have them, even if they're not written down. Whether it's making a normal change to infrastructure, or reacting to an issue, there's some process we go through to get our work as network engineers done.

Modern software development has it's own cadence as well. Practices like [Continuous Integration](http://en.wikipedia.org/wiki/Continuous_integration) have really changed the landscape with regard to how code makes it to the light of production. Keeping in mind that it's more about the methodology than the tools, these new techniques are strongly centered around the automation of repetitive tasks (i.e. running tests on a source code release), and the establishment of feedback loops, so that future iterations can happen more quickly, and with fewer errors. Certainly these are some of the largest pillars of the DevOps movement.

I mentioned Gerrit earlier as a server that you can use internally for collaborating over version control using Git, but it's more than that. Tools like Gerrit also offer code review features. Similar to how developers check in source code that then goes through a series of automated tests and human code reviews, junior network engineers could conceivably check in small changes to network configurations, or perhaps artifacts from configuration management tools, and the senior network engineers would have the opportunity to review these changes before they're put into production.

[![gerrit](assets/2014/10/gerrit.png)](assets/2014/10/gerrit.png)

This offers that feedback loop I mentioned before - just like a software project, the goal is never to just blindly reject - it's to get each useful "patch" eventually accepted into production, so if the change is not of sufficient quality, such a process allows for the right feedback to get it up to par.

Another useful tool is [Jenkins ](http://jenkins-ci.org/)- which is typically used in software development as a crucial part of a Continuous Integration pipeline. Here, developers can build and test source code, deploy a build to production, notify operations of any issues, and much more. In reviewing the large number of plugins available for Jenkins, it's feasible that it could be used as a general workflow engine, similar to how VMware administrators have been using vCenter Orchestrator.

[![jenkins](assets/2014/10/jenkins.png)](assets/2014/10/jenkins.png)

Hell, I got the damn thing to tweet for me.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">[Jenkins Build Status] SUCCESS:routertemplate-deploy $2 -</p>&mdash; MierdinBot (@mierdinbot) <a href="https://twitter.com/mierdinbot/status/525350333393162240">October 23, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Obviously the use of Jenkins as a platform for launching network automation tasks is not yet a fully realized idea, but it is a viable one, in my opinion. We've already started to see a lot of attention applied towards using configuration management tools (traditionally only for servers, as well as some [new ideas](http://www.schprokits.com/) built for networking) for automating network tasks. I think it's one thing to use tools like this on your laptop's command line - but there's real power in using these tools within the context of a CI pipeline. That, however, is for another post.

## Conclusion

Obviously each of these topics is a rabbit hole - I encourage you to do more research into each, and use this post as a way to get the gears moving. Start thinking about how the tools and methodologies that developers have enjoyed for years can benefit networking. I think there's a ton of overlap there, and in my opinion, very little of it involves learning an actual programming language.

Stay tuned for more posts on specific areas of what I discussed here!
