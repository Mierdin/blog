---
layout: post
title: The Foundation of Network Programmability
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2014-03-25"
wordpress_id: 5782
slug: foundation-of-network-programmability
tags: ['automation']
---


Ever since I entered this field, I've been interested in this concept of "network programmability". Forgetting for a second what we've been talking about in the past few years since the advent of the "SDN tsunami", even the ability to automate simple infrastructure tasks at a small scale has grabbed my attention.

It's important to note something here; the CLI is a wonderful tool. So many vendors take the wrong approach and say the CLI is going away in lieu of pretty GUIs and APIs, as if someone can't write a really good CLI to consume a really good API. The "removal" of a CLI is not at all my point, and hopefully my post properly illustrates my belief that it is the **role** of the CLI, **not it's existence**,  that needs to change.

## Network Programmability -Getting to the Roots

Sadly, there are many implementations where programmatic access is clearly an afterthought. This isn't completely unexpected....many network vendors have been around for a while, and we've only been asking for this kind of stuff en masse for a short time. However, I'd like to discuss what I view as a major hurdle to achieving the right kind of programmability on certain platforms.

For years, our network configuration method has been (and still is) the CLI. Whether on a specific box, or on a piece of software that lets you apply CLI tasks to many devices en masse, this is still a very appropriate way for human beings to interact with infrastructure.

However, while CLIs are good for humans, they're bad for computers. Computers don't wish to read configurations like sentences. They wish to see configuration elements as hierarchical, object-oriented data structures, with properties and functions. While this tends to look more complicated to a human being, it ends up massively simplifying the layer where software is written to consume such an API. This bottom-up approach means that developers can bring functionality to market more quickly, and with fewer bugs.

Some APIs have been developed as a bolt-on to the CLI - meaning that while the API is defined by standardized markup like JSON or XML (what isn't these days?) it still works by containing specific CLI commands, within the input and/or output. [I've written before](https://keepingitclassless.net/2013/09/the-benefit-of-infrastructure-apis/) about the problems with using SSH to pass text back and forth between devices....while this *can* work, and in many cases we haven't had any other choice, it still just sucks.

Sometimes vendors like to say they have an XML API when in reality they're just wrapping CLI commands and output within XML tags (pseudo-code example to follow):

{{< highlight xml >}}
<?xml version="1.0"?>
<api>
  <cmd>show ip route</cmd>
  <outputs>
    <output>
      <body>IP Route Table for VRF  default 
 *  denotes best ucast next-hop
 **  denotes best mcast next-hop
 [x/y]  denotes [preference/metric]
 % string   in via output denotes VRF  string 

172.16.40.1/32, ubest/mbest: 1/0, attached
    *via 172.16.40.1, Lo200, [0/0], 4w0d, local
      </body>
    </output>
  </outputs>
</api>
{{< /highlight >}}

Granted, some of the more recent APIs I've played with take this a step further, by properly encapsulating the output into tags (HUGE step in the right direction), but the input required is still same-old CLI commands. One example that fits this description is Cisco's NX-API, currently available on the Nexus 9000 switches:

{{< highlight xml >}}    
<?xml version="1.0"?>
<ins_api>
	<type>cli_show</type>
	<version>0.1</version>
	<sid>eoc</sid>
	<outputs>
		<output>
			<body>
				<TABLE_vrf>
					<ROW_vrf>
						<vrf-name-out>default</vrf-name-out>
						<TABLE_addrf>
							<ROW_addrf>
								<addrf>ipv4</addrf>
								<TABLE_prefix>
									<ROW_prefix>
										<ipprefix>172.16.40.1/32</ipprefix>
										<ucast-nhops>1</ucast-nhops>
										<mcast-nhops>0</mcast-nhops>
										<attached>TRUE</attached>
										<TABLE_path>
											<ROW_path>
												<ipnexthop>172.16.40.1</ipnexthop>
												<ifname>Lo200</ifname>
												<uptime>P28DT1H37M32S</uptime>
												<pref>0</pref>
												<metric>0</metric>
												<clientname>local</clientname>
												<ubest>TRUE</ubest>
											</ROW_path>
										</TABLE_path>
									</ROW_prefix>
								</TABLE_prefix>
							</ROW_addrf>
						</TABLE_addrf>
					</ROW_vrf>
				</TABLE_vrf>
			</body>
			<input>show ip route</input>
			<msg>Success</msg>
			<code>200</code>
		</output>
	</outputs>
</ins_api>
{{< /highlight >}}

As I said, this is way better than the first example; the output is formatted very nicely in a hierarchical, schema-driven way. However, the input is still very CLI-centric. The shortcomings of this approach shine through when trying to get more advanced output out of the Nexus 9000 API:

{{< highlight xml >}}    
<?xml version="1.0"?>
<ins_api>
  <type>cli_show</type>
  <version>0.1</version>
  <sid>eoc</sid>
  <outputs>
    <output>
      <input>show proc cpu hist</input>
      <msg>Structured output unsupported</msg>
      <code>501</code>
    </output>
  </outputs>
</ins_api>
{{< /highlight >}}

In order to get anything out of this command, you'd have to tell the API to send you the ASCII text as it would be shown within an SSH session, which NXAPI allows you to do. A viable solution? Yes, but also a step back into screen-scraping land.

> Cisco UCS Manager (likely because it is an application, not a network OS with inherited code) is an example of a product done in the right way. The configuration on the back end is fully XML based, and you can retrieve it in this format at any time.

This represents either an inability or unwillingness to allow access to both configuration and operational data in the same format as it is stored, and it's far from the only example of this in the industry. In this world, we end up relying upon the CLI for more than just configuring the device - it is the language by which ALL interaction - programmatic or otherwise - must take place.

[![diagram1](assets/2014/03/diagram11-1024x612.png)](assets/2014/03/diagram11.png)

Therefore any policy we wish to put into place on our infrastructure must at some point get translated into good-ol' CLI commands - typically by a human being, because a CLI is a human interface.

In my opinion, if the API is a method by which we access the CLI, the model is still wrong. The reverse should be true - the CLI should be a method by which we access the API, among many others.

[![diagram2](assets/2014/03/diagram2.png)](assets/2014/03/diagram2.png)

This also forces the vendor's developers to keep the API well-documented and free of bugs, because they're eating their own dog food. It also opens up the possibility for the vendor to release a CLI-client that can be run from anywhere, and configure multiple devices at once. There is too much complexity involved in a CLI-centric model to be able to do this effectively today.

All of this said, it is unlikely that this CLI-based model will change any time soon, where it is has taken root, and if I'm being perfectly honest, it's understandable. This model has been used in network operating systems for decades, and has been baked into stable code for so long, it would take a lot of time and money to rewrite the software to fit this model. The argument could be made that the benefits of a different approach don't warrant such a cost. Regardless, this is some pretty delicious food for thought if you ask me.
