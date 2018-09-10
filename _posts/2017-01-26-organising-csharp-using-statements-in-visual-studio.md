---
title: Organising C# using Statements in Visual Studio
date: 2017-01-26T14:30:00+10:00
author: Martin Brennan
layout: post
permalink: /organising-csharp-using-statements-in-visual-studio/
---

If you've been working on a C# file for a little while, refactoring as you go, you may notice that some of the `using` statements are grayed out, which means you are no longer using their assembly code in the current file. Also, they may be out of order alphabetically. Fortunately there is a way to fix both of these issues in Visual Studio. You can do it manually by going to `Edit > Intellisense > Organise Usings > Remove and Sort Usings` or you can bind this action to a keypress, say `Ctrl+U`.

![Remove and sort usings](/images/sortusings.gif)

To do this, go to `Tools > Options > Keyboard`, and inside the `Press shortcut keys` textbox press the key combination that you want to use. Then type `usings` in the `Show commands containing:` textbox. Then choose `EditorContextMenus.CodeWindow.OrganizeUsings.RemoveAndSort`, and press `Assign`. All done! I found out how to do this from this StackOverflow post:

> [Shortcut to organize C# usings in Visual Studio at StackOverflow](http://stackoverflow.com/a/28174025/875941)