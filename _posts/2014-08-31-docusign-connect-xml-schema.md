---
id: 499
title: DocuSign Connect XML Schema
date: 2014-08-31T19:15:06+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=499
permalink: /docusign-connect-xml-schema/
dsq_thread_id:
  - 2974578894
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465012159
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Connect
  - DocuSign
  - XML
  - XSD
---
For those of you that have developed for the <a href="https://www.docusign.com" target="_blank" title="DocuSign">DocuSign E-Signature</a> platform, you&#8217;ll have probably used their DocuSign Connect service to listen for document and recipient events so you don&#8217;t have to long-poll their servers, which they strongly discourage. The example XML in their <a href="https://www.docusign.com/sites/default/files/DocuSign_Connect_Service_Guide.pdf" target="_blank" title="DocuSign Connect Service Guide">Connect documentation</a> frustratingly does not have all of the possible values and fields that could come through with each request.

I decided to investigate this and came upon [this StackOverflow Q&A](http://stackoverflow.com/questions/24653205/connect-docusign-xsd "StackOverflow") that had a handy answer, which linked to the complete DocuSign Connect XML Schema as an XSD. You can find the XSD below:

<a href="https://www.docusign.net/api/3.0/schema/dsx.xsd" target="_blank" title="DocuSign Connect XML Schema (XSD)">DocuSign Connect XML Schema (XSD)</a>