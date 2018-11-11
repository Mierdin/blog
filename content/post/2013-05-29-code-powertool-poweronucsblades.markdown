---
layout: post
title: '[Code] PowerTool: PowerOnUCSBlades'
author: Matt Oswalt
comments: true
categories: ['Compute']
date: "2013-05-29"
wordpress_id: 3872
slug: code-powertool-poweronucsblades
tags: ['code']
---


    # ----------------------------------------------------------------------
    # Name:         PowerOnUCSBlades.ps1                                   
    # Author:       Matthew Oswalt                                         
    # Created:      3/30/2012                                              
    # Revision:     v0.2 - BETA                                                 
    # Rev. Date:    4/30/2013                                              
    # Description:  A script that powers on blades in a UCS system.        
    #               Can be configured to boot all blades, or               
    #               only those associated to service profiles in a         
    #               given sub-organization.
    # ----------------------------------------------------------------------

    # Import the Cisco UCS PowerTool module
    Import-Module CiscoUcsPs

    #Enable Multiple System Config Mode
    Set-UcsPowerToolConfiguration -SupportMultipleDefaultUcs $true


    #####################################################################################################################
    #       AUTHENTICATION             #
    ####################################

    #Stored method of authentication - change the two values shown below
    $user = "admin"
    $password = "password" | ConvertTo-SecureString -AsPlainText -Force
    $cred = New-Object system.Management.Automation.PSCredential($user, $password)
    Connect-Ucs 192.168.0.10 -Credential $cred

    #Connect using "old school" method. This method doesn't store passwords in plain text but less automatable, since you
    #have to log in every time. You will be prompted for credentials just like you were logging into UCSM.
    #Connect-Ucs 123.1.2.3 -Credential (Get-Credential)

    #There is a method of authentication that utilizes encrypted password XML files to allow automation in a secure
    #fashion, to avoid storing passwords in plain text, but keep the nice automated aspect that comes from not having
    #to enter credentials every time. That method will be included in future versions.

    #####################################################################################################################


    #Initialize Orgs Array
    $UcsOrgs = @()

    #Initialize Service Profiles Array
    $UcsServiceProfiles = @()

    #Initialize Choices Array
    [System.Management.Automation.Host.ChoiceDescription[]] $options = @()

    #Initialize $Line as string
    $Line = ''

    #Add Orgs to Array
    echo 'Getting organizational units from system...'
    echo ' '
    echo 'SUBORGS:'
    echo '================='

    $counter = 1
    foreach ($thisOrg in Get-UcsOrg | Select Name)
    {
        $UcsOrgs += $thisOrg
        $thisOrgString = $thisOrg.Name.ToString()

        echo " $counter. $thisOrgString "
        $counter++
    }

    #Allow user to enter a number to select desired Org.
    function getInputFromUser($prompt='Please type the number next to the desired Sub-Org and press <Enter>.') {
        Write-Host $prompt
        do {
            Start-Sleep -milliseconds 100
        } until ($Host.UI.RawUI.KeyAvailable)
        $thisUserInput = $Host.UI.ReadLine()
        $Host.UI.RawUI.FlushInputBuffer()
        return $thisUserInput
    }

    #Execute above input function and determine name of desired Org.
    $userInput = getInputFromUser
    $userInput = [int]$userInput
    $userInput--
    $selectedOrg = $UcsOrgs[$userInput].Name.ToString()

    #Present user with a confirmation dialog
    $title = "Start Service Profiles"
    $message = "You have selected $selectedOrg - do you want to start all service profiles in this sub-org?"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Reboot all service profiles in this sub-org."

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Do nothing."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

    switch ($result)
    {
        0 { #They selected "yes", so proceed with power state change.
            echo "Powering on all Service Profiles in $selectedOrg ..."
            $targetedOrg = Get-UcsOrg -Name $selectedOrg
            
            #For testing the script, comment this line out to prevent any changes from being made.
            Get-UcsServiceProfile -Org $targetedOrg | Set-UcsServerPower -State admin-up -Force
        }
        1 { #They selected "no" so output a confirmation and continue to quit.
            echo "You selected No. Exiting..."
        }
    }

    #Disconnect Current Session
    echo DONE
    Disconnect-Ucs