---
layout: post
title: '[Code] PowerTool: PowerOnUCSBlades'
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-06-14"
wordpress_id: 3990
slug: code-install-boot-from-san-policy-ucs-powertool
tags: ['code']
---


    # InstallBFS.ps1
    #
    # Very brief and informal PowerShell script to configure a Boot-From-SAN policy and attach it to the relevant service profile templates.
     
    Import-Module CiscoUcsPs
     
    Disconnect-Ucs
     
    Connect-Ucs 10.0.0.1
     
    $organization = "SUBORG_01"
     
    #Add Boot Policies
    $bp = Add-UcsBootPolicy -Org $organization -Name "BFS-ESX-PROD" -EnforceVnicName yes
    $bp | Add-UcsLsBootVirtualMedia -Access "read-only" -Order "1"
    $bootstorage = $bp | Add-UcsLsbootStorage -ModifyPresent -Order "2"
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "primary" -VnicName "ESX-PROD-A"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "secondary" -VnicName "ESX-PROD-B"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bp = Add-UcsBootPolicy -Org $organization -Name "BFS-ESX-NONP" -EnforceVnicName yes
    $bp | Add-UcsLsBootVirtualMedia -Access "read-only" -Order "1"
    $bootstorage = $bp | Add-UcsLsbootStorage -ModifyPresent -Order "2"
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "primary" -VnicName "ESX-NONP-A"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "secondary" -VnicName "ESX-NONP-B"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bp = Add-UcsBootPolicy -Org $organization -Name "BFS-WIN-PROD" -EnforceVnicName yes
    $bp | Add-UcsLsBootVirtualMedia -Access "read-only" -Order "1"
    $bootstorage = $bp | Add-UcsLsbootStorage -ModifyPresent -Order "2"
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "primary" -VnicName "BARE-PROD-A"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "secondary" -VnicName "BARE-PROD-B"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bp = Add-UcsBootPolicy -Org $organization -Name "BFS-WIN-NONP" -EnforceVnicName yes
    $bp | Add-UcsLsBootVirtualMedia -Access "read-only" -Order "1"
    $bootstorage = $bp | Add-UcsLsbootStorage -ModifyPresent -Order "2"
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "primary" -VnicName "BARE-NONP-A"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    $bootsanimage = $bootstorage | Add-UcsLsbootSanImage -Type "secondary" -VnicName "BARE-NONP-B"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "primary" -Wwn "50:00:00:00:00:00:00:00"
    $bootsanimage | Add-UcsLsbootSanImagePath -Lun 0 -Type "secondary" -Wwn "50:00:00:00:00:00:00:00"
     
    Get-UcsServiceProfile -Name "SPT-ESX-PROD" | Set-UcsServiceProfile -BootPolicyName "BFS-ESX-PROD" -force
    Get-UcsServiceProfile -Name "SPT-ESX-NONP" | Set-UcsServiceProfile -BootPolicyName "BFS-ESX-NONP" -force
    Get-UcsServiceProfile -Name "SPT-WIN-PROD" | Set-UcsServiceProfile -BootPolicyName "BFS-WIN-PROD" -force
    Get-UcsServiceProfile -Name "SPT-WIN-NONP" | Set-UcsServiceProfile -BootPolicyName "BFS-WIN-NONP" -force