---
layout: post
title: Source-Driven Configuration for NetOps
series:
- DevOps for Networking
author: Matt Oswalt
comments: true
categories: ['The', 'Evolution']
date: "2014-11-10"
wordpress_id: 5973
slug: source-driven-configuration-netops
tags: ['ansible']
---


I mentioned in a [previous post](https://oswalt.dev/2014/10/five-dev-tools-network-engineers/) that version control is an important component of efficiently managing network infrastructure. I'm going to take is a step further than what most are doing with RANCID, which is traditionally used at the end of a workflow (gathering running config diffs) and show you what it's like to **start** with version controlled configuration artifacts, specifically using Ansible's "template" module.

I'm not going to discuss how you get the resulting configurations actually running on your network devices - that is best saved for another post. This is more focused on using version control and review workflows to initiate what will eventually turn into a networking-centric CI pipeline.

## Config Review and Versioning with Gerrit

Let's say you are the Senior Network Engineer for your entire company, which boasts a huge network. You don't have time to touch every device, so you have a team of junior-level network engineers that help you out with move/add/change kinds of tasks. You've already moved your configurations into [Jinja2 templates](https://oswalt.dev/2014/03/network-config-templates-jinja2/), and have created an Ansible role that takes care of moving configuration variables into a rendered instance of this template. You would like your junior engineers to make changes to the files needed to render these templates, but you want to be able to look them over before they hit production.

> If you want to follow along at home, the Ansible role I use below is on [GitHub](https://github.com/Mierdin/ansible-switchconfig).

Bob is one of your junior network engineers. He is not a software developer - never written a line of code in his life. He is first and foremost a network operations-focused engineer, with basic knowledge of Git and Linux in general.

He is taking care of making a few port changes on all of the Top-of-Rack switches in your datacenter. Because all of the needed files are in the local Git repository (your company uses Gerrit internally), the first thing Bob needs to do is clone the repository to his laptop:
    
    bob@abathur:~$ git clone ssh://Bob@10.12.0.6:29418/SwitchConfigs
    Cloning into 'SwitchConfigs'...
    remote: Counting objects: 17, done
    remote: Finding sources: 100% (17/17)
    remote: Total 17 (delta 2), reused 17 (delta 2)
    Receiving objects: 100% (17/17), done.
    Resolving deltas: 100% (2/2), done.
    Checking connectivity... done.
    bob@abathur:~$ cd SwitchConfigs/
    bob@abathur:~/SwitchConfigs$ vi roles/leaf/vars/leafconfig.yml
    
At the end of the sample above, Bob opens his trusty Vim editor, and makes the necessary changes to the YAML file that houses all of the configuration variables for this effort (we'll see exactly what he did in a second).

Next, Bob needs to commit his changes to Git, and push them to Gerrit for review.
    
    bob@abathur:~/SwitchConfigs$ git add roles/leaf/vars/leafconfig.yml
    bob@abathur:~/SwitchConfigs$ git commit -s -m "Added more application server ports"
    [master 44f15ef] Added more application server ports
     1 file changed, 1 insertion(+), 1 deletion(-)
    bob@abathur:~/SwitchConfigs$ git push ssh://Bob@10.12.0.6:29418/SwitchConfigs.git HEAD:refs/for/master
    Counting objects: 14, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (6/6), 529 bytes | 0 bytes/s, done.
    Total 6 (delta 2), reused 0 (delta 0)
    remote: Resolving deltas: 100% (2/2)
    remote: Processing changes: new: 1, refs: 1, done
    remote:
    remote: New Changes:
    remote:   http://10.12.0.6:8090/35
    remote:
    To ssh://Bob@10.12.0.6:29418/SwitchConfigs.git
     * [new branch]      HEAD ->; refs/for/master

This kicks off an email to you, the senior network engineer. It's time to review the changes that Bob made. This is the same process that developers go through in order to spot-check code for simple errors before it's pushed further into automated deployment systems.

[![gerrit1](/assets/2014/11/gerrit1-1024x802.png)](/assets/2014/11/gerrit1.png)

It's good that this change is light, and easy to review. Let's take a look:

[![gerrit2](/assets/2014/11/gerrit2-1024x828.png)](/assets/2014/11/gerrit2.png)

It is indeed a small change, but it looks like Bob still forgot to move the Storage ports up as well; if this was deployed now, the change would be ineffective, because the Storage port group still includes ports 33 and 34, which Bob was supposed to re-allocate to "Application Servers". So as the senior engineer, your job is not only to reject this change, but provide feedback on what's wrong, and what's required to make it right.

[![gerrit3](/assets/2014/11/gerrit3-1024x1021.png)](/assets/2014/11/gerrit3.png)

To draw another parallel with software development, this is basically a patch. Our engineers mean well, and they're just doing their jobs. So as senior engineer, and "code reviewer", your job is to close that feedback loop - provide a way for them to learn and grow from the process itself.

So Bob gets out his trusty Linux CLI and makes the needed changes, updating the original commit so that it's all tracked properly in Gerrit.
    
    bob@abathur:~/SwitchConfigs$ vi roles/leaf/vars/leafconfig.yml
    bob@abathur:~/SwitchConfigs$ git add roles/leaf/vars/leafconfig.yml
    bob@abathur:~/SwitchConfigs$ git commit --amend -s
    [master f06bee8] Added more application server ports
     1 file changed, 2 insertions(+), 2 deletions(-)
    bob@abathur:~/SwitchConfigs$ git push ssh://Bob@10.12.0.6:29418/SwitchConfigs.git HEAD:refs/for/master

This creates a second "patch set" within Gerrit, which contains the updated fix for this YAML file.

> Of course, version control systems all handle this kind of thing differently from each other - the "amend" concept is specific to Git itself, while "patch set" is Gerrit verbiage.

[![gerrit5](/assets/2014/11/gerrit5-981x1024.png)](/assets/2014/11/gerrit5.png)

Upon reviewing the YAML file once again, we can provide feedback, and approve the change. This particular action (+2) actually merges the change into the Git repo (up until now it's been in "limbo").

[![gerrit6](/assets/2014/11/gerrit6-959x1024.png)](/assets/2014/11/gerrit6.png)

## Conclusion

This is a very simple workflow involving version control, and what a team of network engineers can do to use the same tools and workflow that developers do in order to work more effectively. The tools themselves are not important, you could easily substitute Gerrit for another version control system that provides a review system.

There is a lot more you can do with this. We haven't even used these templates to actually apply configurations live into network devices - but that is best saved for another post.
