---
layout: post
title: Continuous Integration Pipeline for Networking
series:
- DevOps for Networking
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2015-01-05"
wordpress_id: 5983
slug: continuous-integration-pipeline-network
tags: ['ansible']
---


Popular development methodologies like Continuous Integration are usually accompanied by some kind of automated workflow, where a developer checks in some source code, which kicks off automated review, testing, and deployment jobs. I believe the same workflows can be adopted by network engineers.

Let's say you are the Senior Network Engineer for your entire company, which boasts a huge network. You don't have time to touch every device, so you have a team of junior-level network engineers that help you out. Let's say you want to offload the creation/deletion of DHCP reservations to these junior engineers, but you still want to be able to approve all changes, just as a last line of defense, and a sanity check.

For this, I'm gong to show you how I'm managing my own home DHCP server (ISC) with Gerrit, Jenkins, and Ansible.

## Config Review and Versioning with Git and Gerrit

I mentioned in [a previous post](https://oswalt.dev/2014/10/five-dev-tools-network-engineers/) that version control is an important component of efficiently managing network infrastructure. I'm going to take it a step further than what most are doing with RANCID, which is traditionally used at the end of a workflow (by gathering running configs) and show you what it's like to [**start** your workflow](https://oswalt.dev/2014/11/source-driven-configuration-netops/) with version controlled configuration artifacts.

I'll be demonstrating this idea with Gerrit, which is used for managing contributions on software projects. It's very popular in open source; used in the OpenDaylight and Openstack projects, as an example. At it's core, Gerrit is a version control system (it's fundamentally based on Git for version control) but it adds a bunch of nifty tools and workflows on top.

> If you want to follow along at home, I provided a copy of this Git repo on my [GitHub profile](https://github.com/Mierdin/ansible-role-iscdhcp).

If you dig into the repo, you'll see that all of my DHCP reservations are contained within a YAML file.
    
    reservations:
      SRV01:
        macaddr: 00:00:00:11:22:01
        ipaddr: 192.168.1.31  
      SRV02:
        macaddr: 00:00:00:11:22:02
        ipaddr: 192.168.1.32

As you can see, this is a very straightforward and easy way to manage information on DHCP reservations. Because it's in an Ansible role, this same logic can be used no matter how many DHCP servers I have.

However, we want our junior engineers to manage this list. So we place the entire Ansible role within a Gerrit project.

[![Screenshot 2014-11-05 14.34.42](/assets/2014/11/Screenshot-2014-11-05-14.34.42.png)](/assets/2014/11/Screenshot-2014-11-05-14.34.42.png)

When the junior engineers want to make changes to the DHCP configuration, they just clone this Gerrit repo to their local machine and make the changes they need.

[![Screenshot 2014-11-05 14.59.23](/assets/2014/12/Screenshot-2014-11-05-14.59.23-1024x310.png)](/assets/2014/12/Screenshot-2014-11-05-14.59.23.png)

After making these changes, they commit them into Git, and push them back to the Gerrit server.

[![Screenshot 2014-11-05 15.03.25](/assets/2014/12/Screenshot-2014-11-05-15.03.25-1024x465.png)](/assets/2014/12/Screenshot-2014-11-05-15.03.25.png)

Normally when pushing to a Git remote like GitHub, your changes are taken into the remote repository immediately. However, with this Gerrit configuration, this is not the case. For example, if someone else were to clone this repository, they would not receive the changes I just made. This is because Gerrit allows a project coordinator/administrator to review contributions before they make it into the repository. As you can probably imagine, this is very useful for doing reviews on software source code, and we can use this same principle to give a quick spot-check to our YAML file when a junior admin makes changes.

[![gerrit2](/assets/2014/12/gerrit2.png)](/assets/2014/12/gerrit2.png)

In either case, we get a nice differential view of what's been changed on our YAML file.

[![gerrit1](/assets/2014/12/gerrit1.png)](/assets/2014/12/gerrit1.png)

As you can see, Gerrit shows a nice output of the difference in the two versions of the files reported by Git. We can plainly see what's been added, and that everything else is unchanged.

You may be thinking: "That's nothing new, I can get the same kind of differential view with a tool like RANCID". You're correct! But keep in mind, this is not the actual implementation syntax - this is just an abstract definition for what will eventually become implementation details. This is actually the **source** of our configuration, and not the resulting configuration, which is what tools like RANCID stores. Tools like RANCID are at the very tail end of a workflow, which serves as little more than a backup.

## Auto-Deploy Configurations with Ansible and Jenkins

Tracking configurations in a version control system is great, but ultimately, we want changes to trigger actual configuration changes in production, just like developers do with source code in continuous deployment methodologies. We're going to use a CI tool called Jenkins to watch the Gerrit repository for changes, and when this happens, kick off an Ansible run to update our DHCP server.

> These images are slightly edited to show only the relevant configurations.

First, we need to tell Jenkins where to find our Git repository. We can use the SSH URL of our Gerrit project found on the project's main page. This obviously assumes you've set up all of the SSH key authentication between your Jenkins and Gerrit servers correctly

[![jenkins1](/assets/2014/12/jenkins1.png)](/assets/2014/12/jenkins1.png)

We want Jenkins to run this job every time a change is merged into the repository. This means that the job is not kicked off until someone approves a new patch - useful for situations where you want to set up an approval system before configuration artifacts make it to production:

[![jenkins2](/assets/2014/12/jenkins2.png)](/assets/2014/12/jenkins2.png)

Next, we apply our build actions. The options here are numerous, but for our purposes, we only want to call our Ansible playbook, with a few options shown below:

[![jenkins3](/assets/2014/12/jenkins31.png)](/assets/2014/12/jenkins4.png)

With all of this set up, we can submit a change like we did in the previous section, and see the entire run by viewing the console output for this job. Not only does it show us Jenkins retrieving the repo from Gerrit, but also the output from Ansible.

[![jenkins4](/assets/2014/12/jenkins4.png)](/assets/2014/12/jenkins4.png)From here, you could add additional actions, such as emailing an admin when things go wrong.

At the end of the day, we have an updated DHCP configuration engine that is built to scale from one to many potential endpoints, and the only thing the junior engineers need to know is basic version control, which is valuable knowledge to have anyways. If you'd like to see this in action, I recorded a video of the entire process end-to-end:

<div style="text-align: center"><iframe width="560" height="315" src="https://www.youtube.com/embed/o1azz174wgw" frameborder="0" allowfullscreen></iframe></div>
