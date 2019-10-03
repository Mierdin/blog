---
layout: post
title: Unit Testing Junos with JSNAPy
author: Matt Oswalt
comments: true
categories: ['Blog']
date: "2018-02-27"
slug: unit-testing-junos-jsnapy
tags: ['junos']
---


[I've been passionate](https://keepingitclassless.net/2016/03/test-driven-network-automation/) about the idea of proactively testing network infrastructure for some time. I revived and added to these ideas in my [last post](https://keepingitclassless.net/2018/02/intentional-infrastructure/). In that post's video, I lay out three types of network testing in my presentation:

1. **Config-Centric** - Verify my network is configured correctly
2. **State-Centric** - Verify the network has the operational state I expect
3. **Application-Centric** - Verify my applications can use the network in the way I expect

In the same way a software developer might write tests in Python or Go that describe and effect desired behavior, the network engineer now has a growing set of tools they can use to make assertions about what "should be" and constantly be made aware of deviations. One of those tools popped up on my radar this week - [`jsnapy`](https://github.com/Juniper/jsnapy).

<div style="text-align:center;"><a href="/assets/2018/02/JSNAPy.png"><img src="/assets/2018/02/JSNAPy.png" width="150" ></a></div>

# JSNAPy

JSNAPy describes itself as the python version of the Junos snapshot administrator. While this isn't untrue, I think it's a **huge** undersell. In my view, the assertions you can make on the data retrieved via these snapshots is where JSNAPy really shines. So in order to conceptually understand JSNAPy, I'd recommend you think of it as as a generic assertion engine for Junos, and the snapshots are an implementation detail that makes this possible.

JSNAPy offers a syntax with a set of primitives for making assertions on things like whether or not a certain configuration stanza is present, making sure a certain number of routing protocol adjacencies are actually being seen, and more. The language used to describe these things is low level enough for you to get pretty granular with it.

You can use JSNAPy in one of three ways:

- The actual `jsnapy` [command-line tool](https://github.com/Juniper/jsnapy/wiki/3.-Command-Line-Tool)
- JSNAPy's underlying [Python API](https://github.com/Juniper/jsnapy/wiki/4.-Module)
- The `juniper_junos_jsnapy` Ansible module in [Juniper's Ansible module collection](https://github.com/Juniper/ansible-junos-stdlib)

For this post, we'll stick with option #1 and run everything from the shell.

JSNAPy implements its logic in two phases:

- Retrieve a snapshot of whatever data is required by each test. Could be configuration, could be operational state.
- Run a series of checks/tests that make assertions about what that we expect the data in those snapshots to look like.

## Config and Testing Files

> JSNAPy is under active development, and I'm not entirely sure if the Python API, or the format of the YAML files I'll be discussing should be considered "stable". Review the [JSNAPy docs](https://github.com/Juniper/jsnapy/wiki) for the most updated source for this information.

JSNAPy uses a basic config file to tie everything together. It is here where you can list the hostnames and credentials for devices you wish to run `jsnapy` against, as well as references to separate files that contain your tests. All of the above are written in YAML.

The following is a simple config file for connecting to a local vSRX instance. You can see reference to our separate tests file under the `tests` key:

```yaml
---
hosts:
  - device: 127.0.0.1
    username : root
    passwd: Juniper
    port: 2202
tests:
    - /Users/mierdin/Code/Juniper/nfd17-netverify-demo/jsnapytest.yaml
```

Our testing file `jsnapytest.yaml` contains our test(s). In this case, I've constructed a single test named `test_applications`. We'll explore the details of this later on in this post.

```yaml
---
test_applications:
  - rpc: get-config
  - item:
      id: ./name
      xpath: 'applications/application[name="k8sfrontend"]'
      tests:
        - is-equal: destination-port, 30589
          info: "Test Succeeded!!, destination-port is <{{post['destination-port']}}>"
          err: "Test Failed!!!, destination-port is <{{post['destination-port']}}>"
```

In short, our config file contains all of the information we need for connectivity to Junos devices, and references to tests to run on those devices. We'll explore these in detail in the following sections.

## Retrieve Snapshot

As I mentioned before, the real value of JSNAPy is in the testing functionality, but it's important to understand how `jsnapy` retrieves the data to be tested within snapshots, as it is on these snapshots that those assertions are performed.

You may have noticed that our `test_applications` test has two main components. The first statement, `rpc: get-config` is very important, as it specifies how to retrieve the necessary data that our test will be making assertions on. We can use the `--snap` argument at the shell to instruct `jsnapy` to retrieve a snapshot and store it on disk:

```bash
jsnapy --snap pre -f jsnapyconfig.yaml -v
Tests Included : test_applications
Taking snapshot of RPC: get-config
```

I have `jsnapy` set up in a virtual environment at `venv/` so I can easily find the resulting snapshot from the local directory:

```xml
~$ cat venv/etc/jsnapy/snapshots/127.0.0.1_pre_get_config.xml
<configuration changed-seconds="1519176621" changed-localtime="2018-02-21 01:30:21 UTC">
    <version>12.1X47-D15.4</version>
    <system>
        <host-name>vsrx01</host-name>
        ..........
```

As you can imagine, you can use any supported Junos XML RPC to retrieve data. Here's the corresponding snapshot file from the rpc `get-interface-information`:

```xml
~$ cat venv/etc/jsnapy/snapshots/127.0.0.1_pre_get_interface_information.xml
<interface-information style="normal">
    <physical-interface>
        <name>
            ge-0/0/0
        </name>
        <admin-status format="Enabled">
            up
        </admin-status>
        <oper-status>
            up
        </oper-status>
    </physical-interface>
    <physical-interface>
        <name>
            ge-0/0/0
        </name>
        <admin-status format="Enabled">
            up
        </admin-status>
        <oper-status>
            up
        </oper-status>
.......
```

If the data you're looking for isn't available via an RPC, you can still execute `show` commands and the snapshot will contain the resulting XML. For instance, instead of `rpc`, you'd specify `command`, followed by the command to issue:

```yaml
# BGP neighbors actually are available via RPC, but this will suffice as an example
test_bgp_neighbor:
  - command: show bgp neighbor
```

You can also use the `--diff` flag to compare two snapshots. Let's say we run another snapshot, call it `post`, and then run a diff against the two (click to zoom):

<div style="text-align:center;"><a href="/assets/2018/02/diffcheck.png"><img src="/assets/2018/02/diffcheck.png" width="800" ></a></div>

The bottom line is, in order to test our network devices, we need a way to describe how to get the information needed to run these tests. These snapshots provide this for us.

## Checks

While the main messaging around JSNAPy tends to focus on snapshots, I feel that the ability to make assertions on the data in these snapshots is where the true value really lies. I've been a strong advocate of "[test-driven network automation](https://keepingitclassless.net/2016/03/test-driven-network-automation/)" for a while, and this concept can take place in many forms. One of these forms is the ability to run detailed and specific tests on your network devices.

It's also worth noting that while JSNAPy is a great tool to enable this, Junos definitely meets us halfway here, since everything in Junos can be represented in XML. As a result of this, anything retrieved in the aforementioned snapshots is available to have assertions made on them, using the variety of generic primitives offered in JSNAPy. These range from checking to ensure a certain number of elements are seen, to ensuring a certain value within one of those elements is equal to a certain value.

For instance, the previous example inspects my vSRX configuration for a custom application definition called `k8sfrontend`, and ensures that this application has the correct `destination-port` field value set:

```yaml
---
test_applications:
  - rpc: get-config
  - item:
      id: ./name
      xpath: 'applications/application[name="k8sfrontend"]'
      tests:
        - is-equal: destination-port, 30589
          info: "Test Succeeded!!, destination-port is <{{post['destination-port']}}>"
          err: "Test Failed!!!, destination-port is <{{post['destination-port']}}>"
```

In my recent [Network Field Day](https://www.youtube.com/watch?v=pHwkwjd2WtQ) demo, I did a lot of this check logic myself in Python. With this format, I can succinctly declare the checks that are important to me, and the YAML format is more accessible to non-programmers.

> It's also worth noting that because this is all defined in YAML text files, we can iterate on these tests in the same way that software developers improve their own testing without using a "full-blown language" like Python. So we get the (relative) ease of use of YAML with the same benefits of source code (plain text in git repos). This is a huge part of "infrastructure as code".

There are a variety of ways to run these tests - such as on existing snapshots - but I find that the most useful way to run these checks is to use the `--snapcheck` flag. This simply takes a quick snapshot of whatever's needed by the test definitions, and immediately runs those tests. You don't need to mess with the snapshot name in this case, just pass in the config file that contains references to your tests, and they'll be run on this "just in time" snapshot:

```bash
jsnapy --snapcheck -f jsnapyconfig.yaml -v

Tests Included : test_applications
Taking snapshot of RPC: get-config
***************************** Device: 127.0.0.1 *****************************
Tests Included: test_applications
*************************RPC is get-config*************************
----------------------Performing is-equal Test Operation----------------------
Test Succeeded!!, destination-port is <30589>
PASS | All "destination-port" is equal to "30589" [ 1 matched ]
------------------------------- Final Result!! -------------------------------
test_applications : Passed
Total No of tests passed: 1
Total No of tests failed: 0
Overall Tests passed!!!
```

If you look at the YAML testing file, you can infer what's going on here. First, the `id` and `xpath` attributes allow us to specify a location of interest to us in the snapshot retrieved by the `get-config` RPC we specified. Then, under `tests`, we specify assertions we wish to make on that particular portion of the data. In this case, I'm using `is-equal` as a way of saying "I expect that the `destination-port` attribute is equal to `30589`. You may also notice this is a YAML list, meaning we can add as many tests as we want for this particular snapshot. We can also define a totally separate test with it's own command or RPC if we want to define tests on some other dataset.

Just like there are multiple options for retrieving snapshots (i.e. `rpc` or `command`), there are multiple test operators you can use, not just `is-equal`. See the [JSNAPy](https://github.com/Juniper/jsnapy/wiki#supported-test-operators-and-their-description) documentation for a complete list.

> The documentation does a pretty good job of listing the possible verbs you can use, but you may also consider looking at the [samples directory](https://github.com/Juniper/jsnapy/blob/master/samples/) for some examples for test cases and config files.

Using these, you can write really granular tests to focus on specific portions of the configuration or operational state, and make assertions relevant to that portion. This is way more detailed than simple [WISB vs WIRI comparisons](https://github.com/StackStorm-Exchange/stackstorm-napalm/blob/master/actions/check_consistency.meta.yaml) (though those are important too), where you might have a "golden config" that you use to run a "diff" against what's actually on the device. This way, you can know which of your tests fail or succeed, and take appropriate action accordingly. A deviation in your BGP state will probably result in a wildly different remediation action than a deviation in your security policies.

# Conclusion

Any mature network automation deployment is going to require dedicated focus on testing and validation at every layer of the stack. JSNAPy is proving to be a very useful tool for writing detailed test cases for Junos devices, whether you're looking to validate configuration or operational state. It should be noted that - like everything else - JSNAPy is not a silver bullet. It is a piece of a much larger picture. There's still room for multivendor validation with [tools like NAPALM](http://napalm.readthedocs.io/en/latest/validate/), or application-level testing with [ToDD](http://todd.readthedocs.io/en/latest/concepts.html). However, if you have Juniper gear in your infrastructure and you're looking for a network validation tool that jives well with infrastructure-as-code practices, JSNAPy is worth a look.
