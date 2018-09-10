---
id: 403
title: Service Timestamp Issue for DocuSign
date: 2014-01-27T14:34:37+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=403
permalink: /service-timestamp-issue-docusign/
iconcategory:
  - development
dsq_thread_id:
  - 2197178305
wp88_mc_campaign:
  - 1
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464978867
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Amazon EC2
  - amazon web services
  - DocuSign
  - SOAP
  - web service
  - windows server
  - windows service
---
I ran into this service timestamp issue with our server that sends Envelopes to [DocuSign](http://www.docusign.com/) the e-signature service that we use at work. The Envelopes are sent through a SOAP web service endpoint, which we are sending to via a Window service hosted on an [Amazon EC2](http://aws.amazon.com/ec2/) instance. We got this error out of nowhere, which can occur for any web service, not specifically DocuSign&#8217;s.

```csharp
An error was discovered processing the header -- WSE065: Creation time of the timestamp is in the future.
This typically indicates lack of synchronization between sender and receiver clocks.
Make sure the clocks are synchronized or use the timeToleranceInSeconds element in the microsoft.web.services3 configuration section to adjust tolerance for lack of clock synchronization.

Server stack trace: at System.ServiceModel.Channels.ServiceChannel.HandleReply(ProxyOperationRuntime operation, ProxyRpc& rpc)
at System.ServiceModel.Channels.ServiceChannel.Call(String action, Boolean oneway, ProxyOperationRuntime operation, Object[] ins, Object[] outs, TimeSpan timeout)
at System.ServiceModel.Channels.ServiceChannelProxy.InvokeService(IMethodCallMessage methodCall, ProxyOperationRuntime operation)
at System.ServiceModel.Channels.ServiceChannelProxy.Invoke(IMessage message)
Exception rethrown at [0]: at Microsoft.VisualBasic.CompilerServices.Symbols.Container.InvokeMethod(Method TargetProcedure, Object[] Arguments, Boolean[] CopyBack, BindingFlags Flags)
at Microsoft.VisualBasic.CompilerServices.NewLateBinding.ObjectLateGet(Object Instance, Type Type, String MemberName, Object[] Arguments, String[] ArgumentNames, Type[] TypeArguments, Boolean[] CopyBack)
at Microsoft.VisualBasic.CompilerServices.NewLateBinding.LateGet(Object Instance, Type Type, String MemberName, Object[] Arguments, String[] ArgumentNames, Type[] TypeArguments, Boolean[] CopyBack)
at DocuSignLibrary.Document.SendToDocuSign(Envelope Document, List`1 Recipients, Object Envelope
```


I found the solution in the article <a href="http://www.winblogs.net/index.php/2011/09/02/automatic-time-update-in-windows-sync-with-internet-time-a-k-a-ntp-server/" title="Automatic time update in Windows (sync with internet time a.k.a NTP server )" target="_blank">Automatic time update in Windows (sync with internet time a.k.a NTP server )</a>. I checked the server time and it was about 5 minutes ahead of the correct UTC time. I have no idea how it got out of sync, or how it continues to do so, but to fix it all I had to do was right click on the clock, click Adjust Date/Time > Internet Time > Change Settings > Update Now. It fixed the service error and Envelopes continued to send, but we have no idea why the time continues to slip out of sync. If anyone else has experienced this problem let me know in the comments!
