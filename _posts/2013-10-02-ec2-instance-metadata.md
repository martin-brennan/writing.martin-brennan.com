---
id: 371
title: EC2 Instance Metadata
date: 2013-10-02T19:14:23+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=371
permalink: /ec2-instance-metadata/
iconcategory:
  - development
dsq_thread_id:
  - 1817009485
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920042
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Amazon
  - api
  - AWS
  - cli
  - EC2
  - metadata
---
As a user of [Amazon Web Services](http://aws.amazon.com), I am still constantly finding new tools, APIs and features to use within their mammoth system. Because of the huge amount of documentation available, it is difficult to find useful information until I need it for a specific reason. I was looking for a way to make sure that an .exe that I was building could only be run on an EC2 instance, and that’s when I came across [EC2 Instance Metadata](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AESDG-chapter-instancedata.html).

<!--more-->

EC2 Instance Metadata is instance-specific metadata that can be accessed only from within the instance via a local server and an API. This is great for two reasons:

1. Because you can ensure that any .exe or script you are running can only be run on an Amazon EC2 instance by pinging or otherwise interacting with the API .

2. You have access to a whole lot of really useful information about the instance and how it was made.

The instance metadata can be easily retrieved with a HTTP `GET` request, and all responses have the `text/plain` content type.

All instance metadata is accessed at the following URI: `http://169.254.169.254/latest/meta-data/`. This data is only accessible from within the instance. The `latest` section of the URI is the version of the metadata API, which starts at version 1.0. There is a lot of different metadata you can access via the API, [see here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AESDG-chapter-instancedata.html) for a full list of the different options. Some of the more useful ones are:

**ami-id**

Gets the ID of the AMI(Amazon Machine Image) that the EC2 instance was created from.

**hostname**

The private hostname of the EC2 instance.

**instance-id**

The ID of the EC2 instance, which can also be found in the AWS console.

**security-groups**

All of the security groups (if any) that the EC2 instance belongs to.

**public-ipv4**

The public IP address. If an elastic IP address is associated with the instance, the value returned is the elastic IP address.

You can use something like [curl](http://curl.haxx.se/) to interact with the API or your favourite framework’s method of consuming APIs. For example, I used a [WebClient](http://msdn.microsoft.com/en-us/library/system.net.webclient.aspx) in my .NET class library to get the response from the API, and then parsed the response using VB.NET.

EC2 instance metadata is a really useful way to get information about an instance from within the instance and it can also be used to create AMI configurations. This, paired with the CLI or the AWSSDK of your choosing can be used to create powerful tools for automating tasks and interacting with your AWS resources.
