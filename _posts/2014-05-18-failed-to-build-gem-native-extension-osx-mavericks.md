---
id: 456
title: Failed to build gem native extension on OSX Mavericks
date: 2014-05-18T08:54:00+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=456
permalink: /failed-to-build-gem-native-extension-osx-mavericks/
dsq_thread_id:
  - 2703691032
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919982
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - apple
  - gem
  - json
  - mavericks
  - mySQL
  - osx
  - Rails
  - Ruby
  - xcode
---

{% include deprecated.html message="This article is likely no longer relevent, follow the instructions at your own risk!" cssclass="deprecated" %}

When installing certain gems on Max OSX Mavericks you may run into some issues where either the `gem install` or `bundle install` command throws the error &#8220;Failed to build gem native extension&#8221;, usually in `extconf.rb`. This has happened specifically to me with the `json` and `mysql2` gems. Some gems may work exactly as expected.

The reason for this odd behaviour is because in the latest release of XCode 5.1, Apple are treating any unknown command line options as errors.<!--more--> The XCode 5.1 release notes read:

> &#8220;The Apple LLVM compiler in Xcode 5.1 treats unrecognized command-line options as errors. This issue has been seen when building both Python native extensions and Ruby Gems, where some invalid compiler options are currently specified. Projects using invalid compiler options will need to be changed to remove those options. To help ease that transition, the compiler will temporarily accept an option to downgrade the error to a warning: -Wno-error=unused-command-line-argument-hard-error-in-future&#8221;

What this means that if any gems use invalid command line arguments in their build or install process, the error &#8220;Failed to build gem native extension&#8221; will be thrown. As a **temporary** fix, you can try running either `bundle install` or `gem install` with the following argument, which downgrades the error to a warning:

```
ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future gem install {gem_name_here}
ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future bundle install
```

This should clear up most errors. The fix is **temporary** because Apple have said they will be removing support for the argument in the future, which means any gems with invalid arguments will need to update their build commands.

## mysql2

This fix did not work when installing the `mysql2` gem, I got the same error but it required an extra step to fix. I had to run the command `brew install mysql`. Afterwards I could just run `bundle install` and the problem was fixed!
