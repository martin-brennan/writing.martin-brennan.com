---
id: 159
title: Install Ruby and Rubygems on Windows
date: 2012-10-15T15:38:59+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=159
permalink: /install-ruby-and-rubygems-on-windows/
dsq_thread_id:
  - 983114859
iconcategory:
  - tutorial
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464946177
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Share
  - Tutorial
tags:
  - Install
  - Ruby
  - Rubygems
  - Windows
---
I recently started a developing a new ASP.NET MVC project, which I’m developing on Windows using Parallels Desktop. I decided to once again use Compass and SASS for the CSS, which required me to install Ruby on Windows, something I’ve never done before. While fairly straightforward in the end, I thought I’d document the process here because it took some time to figure out how to install Ruby and Rubygems on Windows.

<!--more-->

## Installing Ruby

First of all, you need to head on over to <http://rubyinstaller.org/> and download the `.exe` file that installs

> the Ruby language, an execution environment, important documentation, and more.

Once you have installed it, you will need to close and reopen any `cmd.exe` windows that you had open. To verify that Ruby has been successfully installed, simply run

```shell
ruby -v
```  

In your command prompt window. If successful, the window will print out the version number of Ruby. In my case, the output I got looked like this:

```shell
ruby 1.9.3p194 (2012-04-20) [i386-mingw32]
```


## Installing Rubygems

Now that you’ve got Ruby installed, you will need to install Rubygems to be able to use Compass on Windows. I couln’t find the answer to this at first, but then I stumbled across [this post](http://blog.mattwynne.net/2010/10/12/installing-ruby-gems-with-native-extensions-on-windows/) on Matt Wynne’s blog, that talks about using another executable provided by the people over at ‘rubyinstaller.org’, called DevKit. The steps provided by Matt on his blog are as follows:

>   1. Download the DevKit self-extracting archive [here](http://github.com/downloads/oneclick/rubyinstaller/DevKit-4.5.0-20100819-1536-sfx.exe)
>   2. Run the archive, and when prompted, choose to extract it to C:DevKit
>   3. When the archive has finished unpacking, open a command prompt in C:DevKit and run `ruby dk.rb init ruby dk.rb install`
>   4. That’s it. You can test it using: gem install ruby-debug

You can also test your installation by using the command `gem -v`, which will print the version of Rubygems you have installed, which was `1.8.24` for me.

## Finishing up

That’s all there is to it really. One issue that you may have when trying to run Ruby commands is to do with a lack of a set PATH variable, which will give the following error in the command prompt window:

```shell
ruby.exe is not recognised as an internal or external command
```


Though you should not get this error if you restart your command prompt window after the first step, this is how you can fix it:

  1. Go into the Start menu and right click on Computer
  2. Click on Properties and then Advanced System Settings in the pane on the left hand side.
  3. In the window that opens click on Environment Variables
  4. Click on the PATH variable then click Edit
  5. If it is not there already, add a semicolon (;) to the end of the line and then the path to your ruby installation which in my case was `C:/Ruby193/bin`.

**NOTE:** If there is already an entry for the PATH variable, ensure the one for Ruby is inserted after a semicolon with no space between the semicolon and the path to your Ruby installation. This caused me about half an hour of trouble when I did it. For example, my PATH variable should look like this:

```shell
C:/Users/workspace/AppData/Roaming/npm;C:/Ruby193/bin;
```

And not this:

```shell
C:/Users/workspace/App/Data/Roaming/npm; C:/Ruby193/bin;
```


There we have it! I’ll link to this post in my SASS vs. LESS article to give Windows users a way to try out Compass. Happy Compassing!
