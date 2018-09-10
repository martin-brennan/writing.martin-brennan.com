---
id: 385
title: Run AWS Elastic Beanstalk Config Commands Only Once
date: 2013-11-06T20:35:03+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=385
permalink: /run-aws-elastic-beanstalk-config-commands/
iconcategory:
  - development
dsq_thread_id:
  - 1942457448
wp88_mc_campaign:
  - 1
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464982417
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Amazon
  - amazon web services
  - AWS
  - configuration
  - deploy
  - elastic beanstalk
  - server
---

{% include deprecated.html message="This article is likely no longer relevent, follow the instructions at your own risk!" cssclass="deprecated" %}

The Elastic Beanstalk on Amazon Web Services is a service used to deploy your application to the cloud. Amazon then handles all of the provisioning of instances, loading assets on S3, configuring load balancers and running your server software such as IIS. Configuring what happens when you deploy using Elastic Beanstalk is fairly straightforward, and for more in-depth commands an Elastic Beanstalk Configuration File can be deployed with the application. The configuration file is YAML-based, and can be used to download and install MSIs and other packages and also run commands on the instance. [You can read more about them here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/customize-containers.html).<!--more-->

I found the other day that I needed specific commands to run only once, when the application is first deployed to the server. Luckily I found this StackOverflow question:

[Where to put Elastic Beanstalk config commands that are only run once on spin-up?](http://stackoverflow.com/questions/16827417/where-to-put-elastic-beanstalk-config-commands-that-are-only-run-once-on-spin-up/16846429#16846429)

Which explains that, to run commands only once, a `test:` modifier can be added to the command. This modifier will run a command that returns a True or False value, which then determines whether to proceed with the actual command. Below is the example provided in the StackOverflow question:

```yml
commands:
  01-do-always:
    command: run_my_script
  02-do-on-boot:
    command: script_to_run_once
    test: test ! -f .semaphore
  99-signal-startup-complete:
    command: touch .semaphore
```

This worked great, and I was able to run the commands only once, and the config files in general are extremely useful!
