---
id: 435
title: Add Open With Sublime Text 2 to Windows Context Menu
date: 2014-03-04T07:47:30+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=435
permalink: /add-open-with-sublime-text-2-windows-context-menu/
iconcategory:
  - tutorial
  - tutorial
dsq_thread_id:
  - 2355069826
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919988
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Tutorial
---
Just a quick tip, you can use this .bat file to add Open with Sublime Text 2 to the Windows right click context menu. I assume that you would need administrator privileges to run this command.

```shell
@echo off
SET st2Path=C:\Program Files\Sublime Text 2\sublime_text.exe

rem add it for all file types
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 2"         /t REG_SZ /v "" /d "Open with Sublime Text 2"   /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 2"         /t REG_EXPAND_SZ /v "Icon" /d "%st2Path%,0" /f
@reg add "HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text 2\command" /t REG_SZ /v "" /d "%st2Path% \"%%1\"" /f

rem add it for folders
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime Text 2"         /t REG_SZ /v "" /d "Open with Sublime Text 2"   /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime Text 2"         /t REG_EXPAND_SZ /v "Icon" /d "%st2Path%,0" /f
@reg add "HKEY_CLASSES_ROOT\Folder\shell\Open with Sublime Text 2\command" /t REG_SZ /v "" /d "%st2Path% \"%%1\"" /f
pause
```
