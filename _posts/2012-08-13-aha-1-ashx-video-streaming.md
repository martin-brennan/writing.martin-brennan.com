---
id: 108
title: 'Aha! #1 ASP.NET ASHX Video Streaming for HTML5 Video'
date: 2012-08-13T11:24:53+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=108
permalink: /aha-1-ashx-video-streaming/
dsq_thread_id:
  - 969433537
iconcategory:
  - aha
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465020047
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Aha!
  - Development
tags:
  - Amazon
  - ASHX
  - ASP.NET
  - HTML5
  - JWPlayer
  - S3
  - Streaming
  - VB.NET
  - Video
---
I think that solving a programming problem that has haunted you for days, weeks or months is one of the best feelings you can get as a developer. I had one of these moments over the weekend and I thought I’d put it on here as a reminder to me and to help anyone else out who may be having the same problem.<!--more-->

## The Problem

At home I’ve been working intermittently on an upgrade of my work’s LMS (Learning Management System), because I’d coded it a very unmaintainable way when I was first starting out with ASP.NET. Just thinking about it now is enough to make me queasy.

Anyway, one of the upgrades I’m working on is to use an ASHX video streaming handler in order to provide more security through video restrictions, to gather more accurate video statistics and to obscure the URL of the video file on the server so it cannot be hotlinked or easily downloaded.

After some struggles, I got it working successfully on [JWPlayer](http://www.longtailvideo.com/players/), which is the video player we use in our LMS. However, I was only able to get the video to seek in Flash mode, when it is a requirement for HTML5 mode to also work in order to be compatible with iPads, iPhones et al. This is where I hit the wall. Here is what my code was at this point:

```visualbasic
'Get the file information for the requested content and load the file
'into a byte array.
Dim file_info As New System.IO.FileInfo(_ContentInfo.ContentPath & _ContentInfo.FileName)
Dim bytearr As Byte() = File.ReadAllBytes(file_info.FullName)

'Reset and set response headers. The Accept-Ranges Bytes header is important to allow
'resuming videos.
context.Response.AddHeader("Accept-Ranges", "bytes")
context.Response.ClearContent()
context.Response.ClearHeaders()
context.Response.CacheControl = "Public"

'Check for a specified range header.
Dim startbyte As Integer = 0
If Not context.Request.Headers("Range") Is Nothing Then
    'Get the actual byte range from the range header string, and set the starting byte.
    Dim range As String() = context.Request.Headers("Range").Split(New Char() {"="c, "-"c})
    startbyte = Convert.ToInt64(range(1))

    'If the start byte is not equal to zero, that means the user is requesting partial content.
    If startbyte &lt;> 0 Then
        'Set the status code of the response to 206 (Partial Content) and add a content range header.
        context.Response.StatusCode = 206
        context.Response.AddHeader("Content-Range", String.Format(" bytes {0}-{1}/{2}", startbyte, bytearr.Length - 1, bytearr.Length))
    End If
End If

'Add content headers.
context.Response.AppendHeader("content-length", bytearr.Length - startbyte)
context.Response.AppendHeader("content-type", _ContentInfo.FileType)
context.Response.AddHeader("Access-Control-Allow-Origin", "*")

'Write the video file to the output stream, starting from the specified byte position.
context.Response.OutputStream.Write(bytearr, startbyte, bytearr.Length - startbyte)
```

This is where I stalled for a long time, I tried to find answers without success which was really a downer because I wanted to keep working on the project but I couldn’t until I got this going. The video just flat out refused to seek forward in HTML5 mode, even though it did in Flash mode. Then, finally, this weekend I found the solution.

{% include in-post-ad.html %}

## The Solution

It turns out, the answer had nothing to do with JWPlayer as I had thought. The issue was with Google Chrome and how it handles Range headers in HTTP requests. Although my handler accepted Range headers in the request, there was one tiny piece of code that made it not work. It accepted any range except `0-`, which I didn’t think would be a requirement because that range is the entire video.

I found this out because of [this](http://stackoverflow.com/questions/8088364/html5-video-will-not-loop) StackOverflow post, which states that

> If your server didn’t honour Chrome’s Range request the first time, the video will not be loopable or seekable.

Which meant that I had to serve up a 206 Partial Content response even if the video had started from the beginning. I changed the following segment of code from this

```visualbasic
'If the start byte is not equal to zero, that means the user is requesting partial content.
If startbyte <> 0 Then
    'Set the status code of the response to 206 (Partial Content) and add a content range header.
    context.Response.StatusCode = 206
    context.Response.AddHeader("Content-Range", String.Format(" bytes {0}-{1}/{2}", startbyte, bytearr.Length - 1, bytearr.Length))
End If
```

To this

```visualbasic
'Set the status code of the response to 206 (Partial Content) and add a content range header.
context.Response.StatusCode = 206
context.Response.AddHeader("Content-Range", String.Format(" bytes {0}-{1}/{2}", startbyte, bytearr.Length - 1, bytearr.Length))
```

And voila! It worked! I was so happy with finally getting the solution, and I am now able to move onto the next stage, which is streaming videos from Amazon S3. So in summary:

  * Google Chrome is picky with Range requests.
  * A 206 Partial Content response is required for any kind of seeking in video.
  * StackOverflow is a godsend!

I hope this helps out some people and prevents them from having to tear their hair out.
