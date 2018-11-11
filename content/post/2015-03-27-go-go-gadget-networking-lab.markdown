---
layout: post
title: Go Go Gadget Networking Lab!
author: Matt Oswalt
comments: true
categories: ['DevOps']
date: "2015-03-27"
wordpress_id: 6054
slug: go-go-gadget-networking-lab
tags: ['automation']
---


For the last few years, if you wanted to set up a virtual network environment (for testing purposes, or setting up a lab, etc), it was more or less a manual process of installing software like the [CSR 1000v](http://www.cisco.com/c/en/us/products/routers/cloud-services-router-1000v-series/index.html) from an ISO or OVA. Rinse and repeat. If you were fortunate enough to work at a company with decent virtual machine automation and infrastructure (and had access to it) then you could in theory make this a little easier, but it's hardly portable. However, this is still much better than it was only a few short years ago, when many vendors simply did not offer a virtual machine version of their routers and firewalls.

The other day I was catching up on some Twitter feed, and I noticed a tweet from John Deatherage that caught my eye:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Updated <a href="https://twitter.com/hashtag/vsrx?src=hash">#vsrx</a> <a href="https://twitter.com/vagrantup">@vagrantup</a> plugin to support DHCP, as well as Vagrant&#39;s new(er) insecure pubkey replacement <a href="https://t.co/WaMSAoDVIY">https://t.co/WaMSAoDVIY</a> <a href="https://twitter.com/hashtag/netdevops?src=hash">#netdevops</a></p>&mdash; John Deatherage (@RouteLastResort) <a href="https://twitter.com/RouteLastResort/status/580588615580954625">March 25, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I've been using Vagrant for about a year, so I've got a bit of experience with it, but mostly with server operating systems. Seeing this tweet reference it's use in the context of spinning up instances of a Network Operating System caught me off guard a bit. Before I get too deep, it's worth briefly explaining what Vagrant is.

## What is Vagrant?

It's not much of a secret that I am doing a lot more software development these days. When I'm writing code to be deployed somewhere in production (and that's usually the goal anyways), it serves no one to write and debug said code in an environment that is totally different from production. For instance, I may be writing Python on my Mac, but it's unlikely that the production environments is made up entirely of literal clones of my Mac; it is likely some kind of Linux-based OS like Ubuntu or RHEL.

The simple answer is to just set up a virtual machine that has the operating system you want, as well as any dependent software on top. If you've ever done any professional software development, you know this is no simple task. More times than not, the list of software dependencies required is usually quite long, and it can change depending on what you're trying to do, and with what software version. Not only this, but if you wanted to collaborate over code, you'd have to somehow get your virtual machine copied over to someone else's environment (VMs can get pretty large) and then somehow deal with situations when the software needs to change. A better mechanism is needed.

[![Vagrant](assets/2015/03/Vagrant-246x300.png)](assets/2015/03/Vagrant-246x300.png)

Enter Vagrant. Vagrant is essentially a tool that allows you to define your development environments in extremely portable text files. You'd write a Vagrantfile that describes the virtual machines you want, what network interfaces they should have, what image they should run, etc. On top of that, Vagrant allows you to use Ansible, Chef, Puppet, Bash scripts, etc. to provision things within the virtual machine itself - also driven by simple, portable text files. You may have a full multi-machine development environment with tons of complex dependencies, yet the whole thing can be sent in an email.

> Vagrant also allows freely accessible images of popular operating systems like Ubuntu that download seamlessly when referenced in a Vagrantfile, and they're generally really tiny (200MB for Ubuntu 14.4 last time I checked).

In essence, as a developer, Vagrant brings me portability, and consistency in my development environments, in a format that is trivial to share. Text-based formats are always great because that means they can be version controlled.

## Vagrant with JunOS

So that's all great, but this is still a networking blog, so.....what could all that POSSIBLY have to do with networking?

Imagine if your favorite network vendor offered their operating system as just another Vagrant image. No need to load up an ISO and go through the initial configuration, just download a text file, run a few commands, and in minutes you've got a router or firewall that's accessible, and has a basic configuration. This is essentially what John and the other folks at Juniper have done. This is not only really useful, but it's also a respectable feat in itself. NOSs are not like server operating systems - they're usually pretty closed off to this kind of stuff. This took some good thought and engineering to make possible.

Head over to [Vagrant's](http://www.vagrantup.com/downloads.html) site and install it. You may also want to install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (I am using 4.3.14), as I don't believe John has tested this Vagrant plugin for any other Vagrant-supported hypervisors.

First, I clone the Github repository for this plugin, as the Vagrantfile included there is a good place to start. You could follow the instructions listed on the README in that repo instead, but I found the Vagrantfile generated by the "vagrant init" command to be pretty bare-bones. For those new to Vagrant, the Vagrantfile that's actually in this repo has a few things written out for you.
  
    ~$ git clone https://github.com/JNPRAutomate/vagrant-junos.git
    Cloning into 'vagrant-junos'...
    remote: Counting objects: 190, done.
    remote: Compressing objects: 100% (101/101), done.
    remote: Total 190 (delta 71), reused 190 (delta 71), pack-reused 0
    Receiving objects: 100% (190/190), 27.17 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (71/71), done.
    Checking connectivity... done.
    
    ~$ cd vagrant-junos
  
Now would be a good time to actually install the Vagrant plugin that allows JunOS images to work:
    
    ~/vagrant-junos $ vagrant plugin install vagrant-junos
    Installing the 'vagrant-junos' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-junos (0.2.0)'!

Then you have to go through this huge, complicated set of steps......just kidding - two words, and you get a router.
    
    ~/vagrant-junos $ vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Box 'juniper/ffp-12.1X47-D15.4-packetmode' could not be found. Attempting to find and install...
        default: Box Provider: virtualbox
        default: Box Version: >= 0
    ==> default: Loading metadata for box 'juniper/ffp-12.1X47-D15.4-packetmode'
        default: URL: https://atlas.hashicorp.com/juniper/ffp-12.1X47-D15.4-packetmode
    ==> default: Adding box 'juniper/ffp-12.1X47-D15.4-packetmode' (v0.2.0) for provider: virtualbox
        default: Downloading: https://vagrantcloud.com/juniper/boxes/ffp-12.1X47-D15.4-packetmode/versions/0.2.0/providers/virtualbox.box
    ==> default: Successfully added box 'juniper/ffp-12.1X47-D15.4-packetmode' (v0.2.0) for 'virtualbox'!
    ==> default: Importing base box 'juniper/ffp-12.1X47-D15.4-packetmode'...
    ==> default: Matching MAC address for NAT networking...
    ==> default: Checking if box 'juniper/ffp-12.1X47-D15.4-packetmode' is up to date...
    ==> default: Setting the name of the VM: vagrant-junos_default_1427426156816_1341
    ==> default: Clearing any previously set network interfaces...
    ==> default: Preparing network interfaces based on configuration...
        default: Adapter 1: nat
        default: Adapter 2: intnet
        default: Adapter 3: intnet
        default: Adapter 4: intnet
        default: Adapter 5: intnet
        default: Adapter 6: intnet
        default: Adapter 7: intnet
        default: Adapter 8: intnet
    ==> default: Forwarding ports...
        default: 22 => 2222 (adapter 1)
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
        default: SSH address: 127.0.0.1:2222
        default: SSH username: root
        default: SSH auth method: private key
        default: Warning: Connection timeout. Retrying...
        default:
        default: Vagrant insecure key detected. Vagrant will automatically replace
        default: this with a newly generated keypair for better security.
        default:
        default: Inserting generated public key within guest...
        default: Removing insecure key from the guest if its present...
        default: Key inserted! Disconnecting and reconnecting using new SSH key...
    ==> default: Machine booted and ready!
    ==> default: Checking for guest additions in VM...
        default: No guest additions were detected on the base box for this VM! Guest
        default: additions are required for forwarded ports, shared folders, host only
        default: networking, and more. If SSH fails on this machine, please install
        default: the guest additions and repackage the box to continue.
        default:
        default: This is not an error message; everything may continue to work properly,
        default: in which case you may ignore this message.
    ==> default: Setting hostname...
    ==> default: Configuring and enabling network interfaces...

> In case you missed it, the first interface is dedicated to allowing you to access the router via "vagrant ssh", which ends up being ge-0/0/0.0 within JunOS. So, when you configure network interfaces within the Vagrantfile, you're able to configure several JunOS interfaces automatically, starting at ge-0/0/1.0

We can immediately log in to the JunOS CLI with only two more words (authentication is managed by Vagrant for us):

     ~/vagrant-junos $ vagrant ssh
    --- JUNOS 12.1X47-D15.4 built 2014-11-12 02:13:59 UTC
    root@vsrx01% cli
    root@vsrx01> show version
    Hostname: vsrx01
    Model: firefly-perimeter
    JUNOS Software Release [12.1X47-D15.4]

Since all of this took almost no time at all, I decided to move on to working with these virtual devices via PyEZ and ncclient, which I'll save for another blog post. However, if you wish to do the same, keep the "vagrant ssh-config" command handy. You'll notice the default configuration is to bind the management interface to the localhost address, and provide unique ports to each device:

    ~/vagrant-junos $ vagrant ssh-config
    Host default
      HostName 127.0.0.1
      User root
      Port 2222
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile "/Users/mierdin/junos-vagrant/default/virtualbox/private_key"
      IdentitiesOnly yes
      LogLevel FATAL

> Also, the default root password is "Juniper". Again, you'll only need this if you're logging in through something other than Vagrant. If you log in via "vagrant ssh" then authentication is handled for you with SSH keys.

I have since modified this Vagrantfile to configure the vsrx instances in a topology that I wish, which is trivial, since it is just a text file modification. Here is the original Vagrantfile from that GitHub repository, but with my modifications, resulting in a 3-router triangle topology.

{{< highlight ruby  >}}
# -*- mode: ruby -*-
# vi: set ft=ruby :

# ge-0/0/0.0 defaults to NAT for SSH + management connectivity
# over Vagrant's forwarded ports.  This should configure ge-0/0/1.0
# through ge-0/0/7.0 on VirtualBox.

######### WARNING: testing only! #########
######### WARNING: testing only! #########
######### WARNING: testing only! #########
#
# this Vagrantfile can and will wreak havoc on your VBox setup, so please
# use the Vagrant boxes at https://atlas.hashicorp.com/juniper unless you're
# attempting to extend this plugin (and can lose your VBox network config)
# TODO: launch VMs from something other than travis to CI all features
#
# Note: VMware can't name interfaces, but also supports 10 interfaces
# (through ge-0/0/9.0), so you should adjust accordingly to test
#
# Note: interface descriptions in Junos don't work yet, but you woud set them
# here with 'description:'.


Vagrant.configure(2) do |config|
  config.vm.box = "juniper/ffp-12.1X47-D15.4-packetmode"

  config.vm.define "vsrx01" do |vsrx01|
    vsrx01.vm.host_name = "vsrx01"
    vsrx01.vm.network "private_network",
                      ip: "192.168.12.11",
                      virtualbox__intnet: "01-to-02"
    vsrx01.vm.network "private_network",
                      ip: "192.168.31.11",
                      virtualbox__intnet: "03-to-01"
  end

  config.vm.define "vsrx02" do |vsrx02|
    vsrx02.vm.host_name = "vsrx02"
    vsrx02.vm.network "private_network",
                      ip: "192.168.23.12",
                      virtualbox__intnet: "02-to-03"
    vsrx02.vm.network "private_network",
                      ip: "192.168.12.12",
                      virtualbox__intnet: "01-to-02"
  end

  config.vm.define "vsrx03" do |vsrx03|
    vsrx03.vm.host_name = "vsrx03"
    vsrx03.vm.network "private_network",
                      ip: "192.168.31.13",
                      virtualbox__intnet: "03-to-01"
    vsrx03.vm.network "private_network",
                      ip: "192.168.23.13",
                      virtualbox__intnet: "02-to-03"
  end
end
{{< /highlight >}}

> It should go without saying, that none of this is officially supported by Juniper. Don't expect to be able to set all this up and complain to support when it goes wrong. For now, this is simply a very useful tool for consuming JunOS software.

## Kicking Down Hurdles

I was sitting here thinking about this post and a thought hit me: I have never been actively sold to by anyone from Juniper. The few folks from Juniper I know have been pretty focused on problems not specific to JunOS, and are about the furthest thing from sales you might imagine. I have actually only sat in one meeting with Juniper, and frankly it didn't go well. I have no perceptible incentive to make Juniper a part of my life outside of my day job.

Yet I am now widely using JunOS software in my workshops, presentations, blog articles, etc. Why?

Juniper has made it incredibly simple for me to get at this software and start to build value around it. They're not subjecting me to some entitlement scheme, or requiring me to get an account and sign a EULA saying I'm not going to blow up the world with this software. They're simply empowering the folks that want to learn.

When I'm writing software, the value-adding activity isn't the act of getting my dev or test environment spun up. No one is going to give me a pat on the back for setting up an Ubuntu virtual machine and installing some software. The value is in what I do once that environment is set up. Therefore, the sooner and the more predictably I can get this environment set up, the sooner I can bring value.
