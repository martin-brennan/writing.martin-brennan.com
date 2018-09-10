---
title: Invalid Byte Sequence in US-ASCII
date: 2017-08-17T23:45:00+10:00
author: Martin Brennan
layout: post
permalink: /invalid-byte-sequence-us-ascii/
---

After some new code was checked in at work we encountered this issue in our CI as part of the build step to run [RubyCritic](https://github.com/whitesmith/rubycritic) over our code. I'd never seen it before, and the source of the error was in `buffer.rb` of the `parser` gem library:

```
'source=': invalid byte sequence in US-ASCII (EncodingError)
```

I did some digging and I found that this is where RubyCritic parses each file into an abstract syntax tree for analysis. It seemed like there was a character in the file that could not be parsed correctly, and eventually I found a StackOverflow post that pointed to a tool called [iconv](https://linux.die.net/man/1/iconv) that can be used to convert between different character encodings, and that if a conversion is unsuccessful it will throw an error and return code 1. Now this was all well and good but the error I was getting from `buffer.rb` did not tell me the currently erroring file -- the best I could do was modify my local gem source to give me a list of the files that passed through the RubyCritic library for analysis.

Then, now that I had a list of files, I could run each file through `iconv` to check which one had invalid ASCII characters. Of course I am a programmer and thus lazy so I wasn't going to sit there and run it manually on every damn file, so I just made a ruby script to run it on each file in my list (of which there were hundreds):

```ruby
def run 
  SOURCE_FILES.each do |file|
    file_path = SOURCE_DIR # source dir is the full path of the root directory
    puts file_path
    puts `iconv -f us-ascii #{file_path} > /dev/null; echo $`
  end
end
```

I ran the script and it found the file easily by finding the one that returned 1. Then, all I did to fix the issue was delete the code that had been changed in the previous commit, re-typed it manually, then saved the file. I ran my script again and the issue was solved!