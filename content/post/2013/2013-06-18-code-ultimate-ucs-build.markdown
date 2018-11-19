---
layout: post
title: '[Code] UltimateUCSBuild'
author: moswalt_kic
comments: true
categories: ['Compute']
date: "2013-06-18"
wordpress_id: 4065
slug: code-ultimate-ucs-build
tags: ['code']
---


**Name**: UltimateUCSBuild.ps1

**Author**: Matthew Oswalt

**Created**: 6/10/2013

**Current Version**: v0.2 (ALPHA)

**Revision Date**: 6/18/2013

**Description**:

--THIS SCRIPT IS VERY NEW, EXPECT FREQUENT CHANGES AND IMPROVEMENTS--

A script that starts with a completely blank UCS system and configures it to completion.

This version of the script is very non-modular and static, but that will change in future versions.

My long-term vision for this script is to be simple, yet powerful. I want it to have the ability to provision lots of stuff very quickly, with minimal code changes. As it stands, this script can configure a UCS system completely from scratch (after the initial configuration like management IP adddresses, etc), in under a minute and a half.

**Download Link **- [https://github.com/Mierdin/UltimateUCSBuilder](https://github.com/Mierdin/UltimateUCSBuilder)

    
    ------------------------
    RELEASE NOTES
    ------------------------
    
    v0.2 (ALPHA) - Cleaned up a lot of stuff, made the script a little easier to read. 
    Changes:
    --Automated the creation of the Host Firmware Package, but right now it is a blank policy. 
      Still needs to be manually configured if it is to do anything of value.
    --Added comments
    
    v0.1 (ALPHA)
    My goal with this version was to define a workflow first, 
    then in later versions, make it more efficient on a module-by-module basis.
    Features:
    --Populates VLAN/VSAN databases
    --Performs all configuration in a sub-organization, to allow for multi-tenancy right out of the gate
    --Creates all MAC/WWPN/WWNN/UUID/Server Pools
    --Creates most commonly-used policies
    --Creates vNIC and vHBA Templates (updating)
    --Creates Service Profile Templates that use the vNIC and vHBA Templates for simplicity (updating)
    --Spawns a few SPs per SPT as a final configuration step
    
    ------------------------
