---
layout: post
title: Network Configuration Templates Using Jinja2
author: Matt Oswalt
comments: true
categories: ['SDN']
date: "2014-03-26"
wordpress_id: 5793
slug: network-config-templates-jinja2
tags: ['automation']
---


We've all been there at some point in our careers - especially those that work for VARs. You're presented with a bunch of new gear that needs to be configured and deployed, and you're tasked with making the magic happen.

[![IMG_20111222_125040](/assets/2014/03/IMG_20111222_125040.jpg)](/assets/2014/03/IMG_20111222_125040.jpg)

It was great to wake up yesterday to read Jason Edelman's [post on Ansible for networking](http://www.jedelman.com/1/post/2014/03/ansible-for-networking.html) - taking an approach to network automation that's built upon existing, proven tools just makes sense, especially for the use case of initial configuration, but hopefully beyond.

One very small piece of this and many other tools is the idea of producing configuration templates. Certainly in networking, there are large portions of a configuration that will be the same on each of hundreds of switches. Things like SNMP community strings, NTP settings, etc. will remain the same, but being able to insert variables into a configuration file, which will then be populated by some python function of your choosing (or one that you write yourself) is hugely powerful. This is something that the Jinja2 language is well-suited for.

> One quick note - though this example of initial configuration is the obvious low-hanging fruit for us, it's not the only place where this can be done. Even small changes, as shown in Jason's post, can and should be template-driven. It is all about producing a **consistent** configuration while being able to make changes easily when needed.

These examples will all use Cisco NX-OS for the back-end configuration. I'm testing all these configurations on a Nexus 5K.

## Template Basics

Let's look at something simple like a VLAN database. It's common on a Nexus switch to see a VLAN with a corresponding name like so:

    vlan 123
        name VLAN_123

The syntax here, specifically the "vlan" and "name" keywords will always be used to configure a new VLAN. However, the ID and the name will be different for every entry, and there may be hundreds or thousands of entries that need to follow a consistent format. This is a great opportunity to produce this programmatically.

Jinja2 uses a notation that's based on python, so it reads just like python. If you want to insert a variable in a certain block of text, simply replace it with the name of your variable, surrounded by double curly brackets. Our previous example would be modified as such:

    vlan {{ vlanId }}
        name {{ vlanName }}

In the next section, we'll discuss how to actually populate these variables with data - but first, we must replicate this block of data for each VLAN we want to configure. Jinja notation also includes flow control mechanisms, such as the venerable "for" loop. We can provide a python dictionary, which is a list of key-value pairs, and then repeat this process for each member of the list (in this example, the "key" is the VLAN ID, and each corresponding value is the VLAN name).

{% raw >}}
    {% for key, value in vlanDict.iteritems() ->}}
    vlan {{ key }}
        name {{ value }}
    {% endfor >}}
{% endraw >}}

The sky is the limit here - you can provide not only simple variables, but even more complex data structures. If we wanted to provide our own custom object into the template and refer to it via properties, we could do this fairly easily. Here's an example where I am referring to an interface "object", and related properties, in order to generate the configuration for a specific interface:

{% raw >}}
    {% for int in interfaces >}}
    interface Ethernet{{ int.slotid }}/{{ int.portid }}
       description {{ int.description }}
       {% if not int.channelGroup == 0 ->}}
          channel-group {{ int.channelGroup }} mode active
       {% endif >}}
    {% endfor >}}
{% endraw >}}

I've provided an array of "interface" objects, named "interfaces", and for each instance in this list, there are individual properties like "description", or "channelGroup". I can store these properties in the python script that's rendering this template, and create a configuration for all ports on a switch using only this small block of text. Note also the use of the "if" statement directly in the jinja template. This is a very helpful tool.

This is hardly an exhaustive syntactical resource regarding Jinja2 - head over to the [documentation site](http://jinja.pocoo.org/docs/templates/) for more info on this. Plenty of nerd knobs beyond what I've showed you.

## Using the Jinja2 API in Python

This template is meaningless without some kind of intelligence to drive data into the variables we placed into it. It's ultimately up to you where the data comes from. One of the easiest ways is to  pull from a CSV file. Network engineers have used scripts to pull data from CSV files for some time, so this is a good example.

> However this can go a lot further. One of the most tedious parts of an NXOS configuration is Fibre Channel zoning. Wouldn't it be awesome to derive all of the zones, and the meticulously typed WWPNs by directly pulling the data from the APIs of the storage array, and/or server platform? Again - all about consistency, not just speed. Eliminating typos here is a huge time-saver. We won't explore those methods in this post, but good food for thought nonetheless.

Let's create a dictionary with the key/value pair we discussed earlier. The first value is the ID, and the second is the VLAN name.

{{< highlight javascript >}}
    vlanDict = {123: 'TEST-VLAN-123', 234: 'TEST-VLAN-234', 345: 'TEST-VLAN-345'}
{{< /highlight >}}

Now we need to grab the template file we created in the last section:

{{< highlight python  >}}
    #create Jinja2 environment object and refer to templates directory
    env = Environment(loader=FileSystemLoader('./Templates/n5k/'))

    #create Jinja2 template object based off of template named 'nexus5548UP'
    template = env.get_template('nexus5548UP')
{{< /highlight >}}

Now we need to render the template by providing it with this VLAN dictionary.

{{< highlight python  >}}
    #render the template, and print it to console. Passing our VLAN dictionary as an argument
    print template.render(vlanDict)
{{< /highlight >}}

Remember that our template is configured to take this dictionary and iterate through it, adding VLANs for every key/value pair. Most of that work is in the template itself, so all we have to do in python is generate the dictionary however we want to. In the end, we get this:

    vlan 123
        name TEST-VLAN-123
    vlan 234
        name TEST-VLAN-234
    vlan 345
        name TEST-VLAN-345
 
In this example, we statically defined the dictionary, but it would be trivial to pull this data from a CSV or some kind of CMDB.

## Conclusion

This is just a small example of what can be done with a template language - the real power comes from the intelligence baked into the software that makes use of this template. The use cases for this kind of template language are pretty numerous in the IT industry alone. If you have any good use cases in mind, let me know in the comments!

I am building a full Jinja2 template and python script for NXOS. It's very much a work in progress right now, but [check it out on GitHub](https://github.com/Mierdin/jinja2-nxos-config).
