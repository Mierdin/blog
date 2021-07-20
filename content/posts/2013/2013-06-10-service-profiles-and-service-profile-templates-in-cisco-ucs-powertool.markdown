---
layout: post
title: Service Profiles and Service Profile Templates in Cisco UCS PowerTool
author: Matt Oswalt
comments: true
categories: ['Infrastructure']
date: "2013-06-10"
wordpress_id: 3972
slug: service-profiles-and-service-profile-templates-in-cisco-ucs-powertool
tags: ['cisco']
---


I had a few scripts that were written WAY before PowerTool was out of beta, and the only way I knew how to generate a Service Profile Template was to use manual XML calls. For instance:

{{< highlight powershell >}}     
$cmd = "<configConfMos inHierarchical='true'> 
      <inConfigs>
          <pair key='org-root/org-" + $orgName + "/ls-" + $serviceProfileName + "' >    
              <lsServer
                  agentPolicyName=''
                  biosProfileName=''
                  bootPolicyName='" + $bootPolicyName + "'
                  descr='' 
                  dn='org-root/org-" + $orgName + "/ls-" + $serviceProfileName + "' 
                  dynamicConPolicyName=''
                  extIPState='none'
                  hostFwPolicyName=''
                  identPoolName='" + $UUID_POOL_NAME + "'
                	localDiskPolicyName='default'
                	maintPolicyName='default'
                	mgmtAccessPolicyName=''
                	mgmtFwPolicyName=''
                	name='" + $serviceProfileName + "'
                	powerPolicyName='default'
                	scrubPolicyName=''
                	srcTemplName=''
                	statsPolicyName='default'
                	status='created'
                	type='initial-template'
                	usrLbl=''
                	uuid='0'
                	vconProfileName=''>
                	<vnicEther
                		adaptorProfileName='VMWare'
                		addr='derived'
                		adminVcon='any'
                		identPoolName=''
                		mtu='1500'
                		name='" + $VNIC_A_NAME + "'
                		nwCtrlPolicyName=''
                		nwTemplName='" + $VNIC_TEMPLATE_A_NAME + "'
                		order='3'
                		pinToGroupName=''
                		qosPolicyName=''
                		rn='ether-" + $VNIC_A_NAME + "'
                		statsPolicyName='default'
                		status='created'
                		switchId='" + $switchId + "'>
                		</vnicEther>
                		<vnicEther
                			adaptorProfileName='VMWare'
                			addr='derived'
                			adminVcon='any'
                			identPoolName=''
                			mtu='1500'
                			name='" + $VNIC_B_NAME + "'
                			nwCtrlPolicyName=''
                			nwTemplName='" + $VNIC_TEMPLATE_B_NAME + "'
                			order='4'
                			pinToGroupName=''
                			qosPolicyName=''
                			rn='ether-" + $VNIC_B_NAME + "'
                			statsPolicyName='default'
                			status='created'
                			switchId='" + $switchId + "'>
                		</vnicEther>
                		<vnicFcNode
                			addr='pool-derived'
                			identPoolName='" + $WWNN_POOL_NAME + "'
                			rn='fc-node' >
                		</vnicFcNode>
                		<vnicFc
                			adaptorProfileName='VMWare'
                			addr='derived'
                			adminVcon='any'
                			identPoolName=''
                			maxDataFieldSize='2048'
                			name='" + $VHBA_A_NAME + "'
                			nwTemplName='" + $VHBA_TEMPLATE_A_NAME + "'
                			order='1'
                			persBind='disabled'
                			persBindClear='no'
                			pinToGroupName=''
                			qosPolicyName=''
                			rn='fc-" + $VHBA_A_NAME + "'
                			statsPolicyName='default'
                			status='created'
                			switchId='" + $switchId + "'>
                		</vnicFc>
                		<vnicFc
                			adaptorProfileName='VMWare'
                			addr='derived'
                			adminVcon='any'
                			identPoolName=''
                			maxDataFieldSize='2048'
                			name='" + $VHBA_B_NAME + "'
                			nwTemplName='" + $VHBA_TEMPLATE_B_NAME + "'
                			order='2'
                			persBind='disabled'
                			persBindClear='no'
                			pinToGroupName=''
                			qosPolicyName=''
                			rn='fc-" + $VHBA_B_NAME+ "'
                			statsPolicyName='default'
                			status='created'
                			switchId='" + $switchId + "'>
                		</vnicFc>
                		<lsRequirement
                			name='" + $SERVER_POOL_NAME + "'
                			qualifier=''
                			restrictMigration='no'
                			rn='pn-req' >
                		</lsRequirement>
                		<lsPower
                			rn='power'
                			state='down' >
                		</lsPower>
                	</lsServer>
              </pair>
          </inConfigs>
      </configConfMos>"

Invoke-UcsXml -XmlQuery $cmd
{{< /highlight >}}

If most of your script is composed of normal cmdlets, this looks pretty absurd - so if you can avoid calling direct XML, you should. Same thing if you're trying to create your own PowerTool-esque library (say, with Python instead of bleh PowerShell), you would take these XML calls and hide them away in modular functions so that you can call them with a single command and a few arguments.

Most other templates (like vNIC and vHBA) have a dedicated cmdlet for creating those constructs. For instance:

{{< highlight powershell >}}
    Add-UcsVhbaTemplate -Org $organization -Name "BARE-NONP-B" -Descr "Non-Prod Baremetal Fabric B" -IdentPoolName "WWPN-BARE-NONP-B" -SwitchId A -TemplType "updating-template"
{{< /highlight >}}

As I tab through the cmdlets that start with "Add-UcsServiceProfile" I noticed there was no "Add-UcsServiceProfileTemplate" as one would expect.

Poking around in the release notes for v1.0 of the PowerTool library, I noticed that one of the new features was the ability to filter Service Profiles based on type (aimed at being able to get all the Service Profiles in the system:

{{< highlight powershell >}}
    # Get all Service Profile Templates.
    
    Get-UcsServiceProfile -Filter 'Type -clike *-template' | select Ucs,Dn,Name
{{< /highlight >}}

So I ran a Get-Help for this cmdlet:

{{< highlight powershell >}}
    -Type <string>
        Specifies if service profile or service profile template needs to be created. Valid values are: initial-template, instance, updating-template
    
        Required?                    true
        Position?                    named
        Default value
        Accept pipeline input?
        Accept wildcard characters?
{{< /highlight >}}

So....at least in this version of PowerTool, the same cmdlet is used to create SPs and SPTs, just need to set this "flag" to one of those three options.
