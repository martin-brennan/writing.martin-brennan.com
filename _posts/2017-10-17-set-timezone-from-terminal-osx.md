---
title: Set Timezone from Terminal OSX
date: 2017-10-17T20:35:00+10:00
author: Martin Brennan
layout: post
permalink: /set-timezone-from-terminal-osx/
---

I often have to switch between timezones to test our timezone-sensitive application code. I was getting annoyed at having to open the settings screen in preferences (which is slow) and found out how to do it from the command line.

To set your timezone run:

```
sudo systemsetup -settimezone timezone
```

Where `timezone` is a valid zone from this list:

```
sudo systemsetup -listtimezones
```

Finally, you can get your current system timezone using:

```
sudo systemsetup -gettimezone
```

This command can easily be made into an alias like so:

```
settz="sudo systemsetup -settimezone $@"
```

So all you need to do to change your timezone is `settz GMT`!