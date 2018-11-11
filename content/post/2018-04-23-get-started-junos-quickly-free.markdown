---
layout: post
title: Get Started with Junos Quickly (and free!)
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2018-04-23"
slug: get-started-junos-quickly-free
tags: ['vagrant']
---


When I got started in networking, my education (like so many network engineers) was all about Cisco. All my networking courses in college, as well as my early networking jobs all used Cisco curricula and equipment, and valued Cisco certifications like the CCNA/CCNP/CCIE above all.

It wasn't until I had already been in the industry for about three years or so before I even got my hands on a Juniper device, and by that time, my IOS habits had taken root in my muscles, which made the new set/delete style of Junos configurations even more strange. While my Junos experience never came close to exceeding my IOS/NXOS experience, I grew to appreciate some of the subtle advantages that Juniper bakes into its software. However, getting this experience meant I had to work that much harder to get my hands on lab gear to make it more a part of my day-to-day experience.

These days, it's way easier to get started with Junos. You don't have to wait for someone to get you some lab gear - you can set up a virtual lab right on your laptop. While there are a few places you can do this, one of the best and most up-to-date is the [vQFX Vagrant](https://github.com/Juniper/vqfx10k-vagrant) repository. This repo contains multiple directories for running a virtualized version of Juniper's QFX switch ranging from the simple single-node deployment, to a full IP fabric. This means we can do a whole lot of Junos learning, right on our laptop, for free.

<div style="text-align:center;"><a href="/assets/2018/04/qfx10008-right-high.jpg"><img src="/assets/2018/04/qfx10008-right-high.jpg" width="300" ></a></div>

# Prerequisites

To get started, you will need some software installed on your machine. To keep things simple, we'll keep it limited to the bare essentials; the very shortest path to being able to play with Junos:

1. [Virtualbox](https://www.virtualbox.org/wiki/Downloads) - this is a hypervisor that allows us to run vQFX in a virtual machine.
2. [Vagrant](https://www.vagrantup.com/downloads.html) - this is a virtual machine orchestrator that configures our VMs for us using the configurations in the Git repo
3. [Git](https://git-scm.com/downloads) - this is a version control tool we'll use to download the vqfx-vagrant repository, which contains all needed configurations for running this image.

Once you've installed these three pieces of software once, you can then take advantage of the myriad of repositories on the web that contain Vagrant configurations for running virtual network devices - this isn't limited just to the vQFX environment we'll use today.

# Boot Up a vQFX Instance

As mentioned before, the [vQFX Vagrant](https://github.com/Juniper/vqfx10k-vagrant) repository contains a number of directories with configurations for running various vQFX topologies.

> You may also notice there are Ansible playbooks in these directories. These are very useful for building complex configurations using virtual images for deeper learning. However, to keep this post as simple as possible, we're skipping that part for now. This guide is intended to get you started with a single, vanilla Junos instance as quickly as possible.

Now that Git is installed, we can use it to "clone" the Github repository (downloading it to our local machine) that contains the configurations for running our lab. Load up your favorite terminal application (I use iTerm2 for macOS but you can use whatever works for you) and run the following commands to clone the repo and navigate to the directory that contains a Vagrant environment for a single vQFX instance:

```
git clone https://github.com/Juniper/vqfx10k-vagrant
cd vqfx10k-vagrant/light-1qfx
```

There's a file in this directory called `Vagrantfile`. This contains instructions to Vagrant for downloading and configuring a virtual machine. What this means for us is we don't need to click through GUIs to make sure our VM is configured correctly. Just run `vagrant up --no-provision` and Vagrant will take care of everything for us.

> The `--no-provision` flag instructs Vagrant to skip the Ansible provisioning process so we can just get straight to playing with Junos. We'll follow up this blog post with another one that focuses on the various configurations made possible via Ansible in this repo. You can safely ignore the "Machine not provisioned" message you'll see after this command; this just means the Ansible process was skipped, and we have a vanilla Junos environment.

No need to go to a website to download an OVA, or register for anything. One command, and Vagrant downloads the image for you, creates a virtual machine, configures it, and boots it up. You'll end up seeing something like the below output:

```
~$ vagrant up --no-provision

Bringing machine 'vqfx' up with 'virtualbox' provider...
==> vqfx: Box 'juniper/vqfx10k-re' could not be found. Attempting to find and install...
    vqfx: Box Provider: virtualbox
    vqfx: Box Version: >= 0
==> vqfx: Loading metadata for box 'juniper/vqfx10k-re'
    vqfx: URL: https://vagrantcloud.com/juniper/vqfx10k-re
==> vqfx: Adding box 'juniper/vqfx10k-re' (v0.3.0) for provider: virtualbox
    vqfx: Downloading: https://vagrantcloud.com/juniper/boxes/vqfx10k-re/versions/0.3.0/providers/virtualbox.box
==> vqfx: Successfully added box 'juniper/vqfx10k-re' (v0.3.0) for 'virtualbox'!
==> vqfx: Importing base box 'juniper/vqfx10k-re'...
==> vqfx: Matching MAC address for NAT networking...
==> vqfx: Checking if box 'juniper/vqfx10k-re' is up to date...
==> vqfx: Setting the name of the VM: light-1qfx_vqfx_1524617298243_85857
==> vqfx: Clearing any previously set network interfaces...
==> vqfx: Preparing network interfaces based on configuration...
    vqfx: Adapter 1: nat
    vqfx: Adapter 2: intnet
    vqfx: Adapter 3: intnet
    vqfx: Adapter 4: intnet
    vqfx: Adapter 5: intnet
==> vqfx: Forwarding ports...
    vqfx: 22 (guest) => 2222 (host) (adapter 1)
==> vqfx: Booting VM...
==> vqfx: Waiting for machine to boot. This may take a few minutes...
    vqfx: SSH address: 127.0.0.1:2222
    vqfx: SSH username: vagrant
    vqfx: SSH auth method: private key
==> vqfx: Machine booted and ready!
==> vqfx: Checking for guest additions in VM...
    vqfx: No guest additions were detected on the base box for this VM! Guest
    vqfx: additions are required for forwarded ports, shared folders, host only
    vqfx: networking, and more. If SSH fails on this machine, please install
    vqfx: the guest additions and repackage the box to continue.
    vqfx:
    vqfx: This is not an error message; everything may continue to work properly,
    vqfx: in which case you may ignore this message.
==> vqfx: Setting hostname...
==> vqfx: Machine not provisioned because `--no-provision` is specified.

```

Now that we have a vQFX instance running, we can run `vagrant ssh` to SSH to the virtual machine and get a handle on the Junos CLI.

```
~$ vagrant ssh

--- JUNOS 17.4R1.16 built 2017-12-19 20:03:37 UTC
{master:0}
vagrant@vqfx-re> show interfaces
Physical interface: gr-0/0/0, Enabled, Physical link is Up
  Interface index: 645, SNMP ifIndex: 504
  Type: GRE, Link-level type: GRE, MTU: Unlimited, Speed: 800mbps
  Device flags   : Present Running
  Interface flags: Point-To-Point SNMP-Traps
  Input rate     : 0 bps (0 pps)
  Output rate    : 0 bps (0 pps)

Physical interface: bme0, Enabled, Physical link is Up
  Interface index: 64, SNMP ifIndex: 37
  Type: Ethernet, Link-level type: Ethernet, MTU: 2000
  Device flags   : Present Running
  Link flags     : None
  Current address: 02:00:00:00:00:0a, Hardware address: 02:00:00:00:00:0a
  Last flapped   : Never
    Input packets : 0
    Output packets: 4
    ...
```

# Getting Started Guides

Now that you have a working Junos environment to play with, you might want some additional resources to help you explore what's possible, and to help translate your existing experiences into Junos-land. Here are a a few super helpful (and free!) mini-books you can use. Only a free J-Net login is required, and you can download the PDF:

- [Exploring the Junos CLI](https://www.juniper.net/us/en/training/jnbooks/day-one/fundamentals-series/cli/)
- [Migrating from Cisco to Juniper Networks](https://www.juniper.net/us/en/training/jnbooks/day-one/fundamentals-series/migrate-cisco-asa-srx-series/)
- [Junos for IOS Engineers](https://www.juniper.net/us/en/training/jnbooks/day-one/fundamentals-series/junos-for-ios-engineers/)

I hope this was a helpful and simple guide to getting a working Junos environment to play with within a few minutes. It doesn't make sense in today's world to wait for lab gear to even get a basic experience with new software, and I hope this helps you kick start your learning. Happy labbing!