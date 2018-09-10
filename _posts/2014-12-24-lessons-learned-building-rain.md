---
id: 548
title: Lessons Learned From Building Rain
date: 2014-12-24T17:49:38+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=548
permalink: /lessons-learned-building-rain/
wp88_mc_campaign:
  - 1
dsq_thread_id:
  - 3355080545
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464998627
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - api
  - bin
  - documentation
  - executable
  - gem
  - Ruby
  - thor
  - tool
---
Tackling a new project is the best way to learn about a bunch of new things and solve a lot of new problems. I&#8217;ve recently built Rain, a gem to generate beautiful API documentation from a Ruby comment syntax with markdown mixed in (check it out at [https://github.com/martin-brennan/rain](https://github.com/martin-brennan/rain)!). On the Rain project, I&#8217;ve learned a couple of things about gem development that I wanted to share because I think it might be helpful to others.<!--more-->

## Gem Executables

If your gem is intended to be run from the command line, then you will need to include an executable for the gem. These files are usually located in the `bin/` directory of your gem. They are simply shell scripts that are run in the context of the version of Ruby currently being run on the system.

  1. Create a file under bin/ with no extension (Rain&#8217;s is raindoc). This will be how your gem is invoked from the command line.
  2. Put `#!/usr/bin/env ruby` at the top of the file to run the code in the context of the system&#8217;s Ruby.
  3. Add the lines below to the gemfile. Basically, all this is doing is ensuring that you can `require` files from your gem&#8217;s lib/ directory easily, no matter what context the executable is being run in (such as the development directory or installed in the user&#8217;s bin directory.)
  4. Include the required files to run your gem using require. The files from your lib directory don&#8217;t need any path before them.
  5. Put in the code to run your gem. For raindoc, this just involves starting the CLI using Thor.
  6. Finally, in your `.gemspec` file, add the executable to the array of executables, in Rain&#8217;s case `spec.executables << 'raindoc'`. The file added is always in the context of the bin/ folder.

[See Rain's executable file here.](https://github.com/martin-brennan/rain/blob/master/bin/raindoc)

## Thor

Thor "is a toolkit for building powerful command-line interfaces", and is a fantastic tool for creating gems that can be run from the command line and accept command line arguments.

Usage of Thor is quite straightforward, first of all you need a class that inherits from Thor (`Rain::CLI < Thor`). Then, any method specified in this class will be available as methods for your gem's executable, unless defined in the no_commands block. For example, Rain has a generate method that accepts an array of source files that is run from the command line using `raindoc generate source/files/*`.

Thor also allows you to specify method options with aliases. Rain (at the time of writing) has two, --lp and --s. The syntax for the method options is:

```ruby
method_option :log_parse, aliases: "--lp", desc: "Show the output of each line parse."
method_option :parse_signatures, aliases: "--s", desc: "Parse method and class documentation too. Defaults to false."
```

You will then need to start the Thor command line parser with the ARGV arguments sent via the command line to your executable. You just need to start Thor, which will usually be done in your executable with the syntax `Rain::CLI.start(ARGV)`.

Thor has a lot of other powerful options as well, Rain is only currently using a small set of its functionality, though I feel that its most powerful feature is the method option definition.

## Gem Assets

You can bundle assets with your gem if required just as you would bundle your lib files. For example, Rain uses a few default ERB and CSS files for the template system that are installed when the gem is installed. You just need to add the extra files to the `files` option of your gemspec.

To access the path of these files if you need to copy them or otherwise use them from within your gem, you can easily get the directory that the gem is installed in by getting its specification. Here is a simple example that finds Rain's location then copies the CSS files bundled with it to the output destination.



## Conclusion

I will do a follow up article on this one once I get to some more advanced stuff as Rain progresses, but I think with these three basic chunks of knowledge it's quite easy to start making powerful and useful gems!
