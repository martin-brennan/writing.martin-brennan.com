---
id: 745
title: 'Changes to NPM&#8217;s Unpublish Policy'
date: 2016-03-30T08:02:10+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=745
permalink: /changes-to-npm-unpublish-policy/
mashsb_timestamp:
  - 1465019360
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 4703852249
categories:
  - Development
  - News
  - Observation
tags:
  - Javascript
  - node
  - nodejs
  - npm
  - open source
---
Today NPM has made some important changes to their unpublish policy to avoid [embarrassing fiascos like the one last week](http://www.martin-brennan.com/npm-drama/). You can read about the new policy here:

> <http://blog.npmjs.org/post/141905368000/changes-to-npms-unpublish-policy>

These changes are clearly a step in the right direction and should prevent an individual from breaking the entire NPM ecosystem by removing a package that is depended on by many others. <!--more-->Especially the rules that you cannot unpublish a module greater than 24 hours old without contacting NPM support, and the affirmation that NPM will not unpublish packages that are depended upon by other projects.

I&#8217;ve already started to see some people complaining that NPM === dictators now because they have more control over your packages. To me, this complaint is a crock of shit. If you publish a package to NPM with a reasonable assumption that other people will depend on the package then it would be selfish for you to assume that you can just pull the rug out from under the community any time you want. That&#8217;s how we end up with dramas like the one last week. It&#8217;s not in the spirit of open source and it&#8217;s not in the interests of the community for individuals to be able to do that.

For an extreme example, let&#8217;s say the author of a popular project like lodash or Babel decides one day to set up a patreon account, delete their package from NPM and then demand a payment of $5000 to republish the package. Effectively, they would be holding the community hostage. Sure NPM could just transfer ownership of their account or republish the module, but it would cause another day of catastrophe and fragmentation for developers everywhere that depend on the module that may end up causing a lot more than $5000 damage in lost productivity.

There are many mitigating strategies you can use to prevent things like this from happening, like privately hosting a copy of the package in your company, but the best course of action is to take more control like NPM has done. I commend their actions and changes to their unpublish policy. They are moving the node and JavaScript communities forward, and I look forward to seeing what other improvements they bring to the table.
