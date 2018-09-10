---
id: 302
title: Custom VisualSVN Post-Commit Hook Using Visual Studio
date: 2013-03-04T20:03:54+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=302
permalink: /custom-visualsvn-post-commit-hook/
iconcategory:
  - Tutorial
dsq_thread_id:
  - 1116980425
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920070
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Tutorial
tags:
  - 'C#'
  - Console Application
  - Post-Commit Hook
  - Source Control
  - SVN
  - VB.NET
  - Visual Studio
  - VisualSVN
---
At work we use [VisualSVN](http://www.visualsvn.com/) for our source control needs, which is great. Their SVN server software is really simple and reliable, and the Visual Studio integration is awesome and works like a charm. VisualSVN comes with [several predefined scripts](http://www.visualsvn.com/support/topic/00018/) that you can attach to your pre- and post-commit and other SVN hooks, but they are quite narrow in scope and not easily customisable. I decided to start searching for a way to make a customisable VisualSVN post-commit hook that I could code myself, and I found that it was much easier than I first anticipated.

<!--more-->

[View the GitHub Repo for this article](https://github.com/Martin-Brennan/martin-brennan-code/tree/master/post-commit-hook)

## The base

I had no idea how to get started writing my own post-commit hook script, with many answers I found saying “just use <insert language here>” without any explanation on how to go about doing it. Finally, I stumbled upon a Google Code project for a [VisualSVN to Pivotal post-commit hook](https://code.google.com/p/visualsvn-to-pivotal-hook/0) by [Jim Palmer](http://www.overset.com/) which included the C# source. Once I had the source, it was fairly easy to get rid of the parts I didn’t need and build in my own customisation.

I’m going to walk you through how to customise the source to send an email about a commit to VisualSVN server, with information gathered using [svnlook.exe](http://svnbook.red-bean.com/en/1.7/svn.ref.svnlook.html). You could then expand the code to do whatever else you need to do post-commit, such as sending a request to a web service or calling an API. The code will have a very basic implementation of an email notification, but you could easily improve it and have it do whatever you need it to do.

## Creating a console application

VisualSVN requires an `.exe` file for any customised post-commit hooks, and the easiest way to create one is by making a new Console Application using Visual Studio. For this tutorial I’m going to use C#, but I will include link to a git repo of the full source for both the VB.NET and C# versions at the end.

In Visual Studio, go to File > New Project and select the Windows sub-menu of your desired language. Then, select Console Application and call it whatever you want. And that’s it! A `Program.cs` class file will be created with a `Main` method inside, which is what will be executed when your `.exe` file is run.

{% include in-post-ad.html %}

## Initialisation and error checking

First of all, we’re going to need the VisualSVN server path from the environment, which we can get from the following:

```csharp
private static int SVNPath = Environment.GetEnvironmentVariable("VISUALSVN_SERVER");
```

The Main method will need to return an integer in order to return an indication of success or failure. It will also accept a string array of arguments, which is how we will pass in the name of the repository and the revision number.

```csharp
private static int Main(string[] args) {
}
```  

Next, we need to check if the required arguments have been passed in and whether VisualSVN server is actually installed. Otherwise, the .exe **will not work** properly.

```csharp
if (args.Length < 2)
{
    Console.Error.WriteLine("Invalid arguments sent - <REPOSITORY> <REV> required");
    return 1;
}

if (string.IsNullOrEmpty(svnpath))
{
    Console.Error.WriteLine("VISUALSVN_SERVER environment variable does not exist. VisualSVN installed?");
    return 1;
}
```    

Now that we are sure that the correct arguments have been passed in and VisualSVN is actually installed, we can proceed with gathering information about the commit using `svnlook.exe`.

## Getting the commit information

There are [several subcommands](http://svnbook.red-bean.com/en/1.7/svn.ref.svnlook.c.author.html) that can be executed using `svnlook.exe` to gather commit information. We are going to be using `author` to get information about who made the commit, `changed` to get a list of all the files added, updated or deleted and `log` to get the commit message. First of all though, we need a helper function that we can use to execute `svnlook.exe`, pass it command line arguments and return its output to be used in the email.

Here is what our helper function, `SVNLook`, looks like:

```csharp
/// <summary>
/// Runs a command on svnlook.exe to get information
/// about a particular repo and revision.
/// </summary>
/// <param name="command">The svnlook command e.g. log, author, message.</param>
/// <param name="args">The arguments passed in to this exe (repo name and rev number).</param>
/// <returns>The output of svnlook.exe</returns>
private static string SVNLook(string command, string[] args) {
    StringBuilder output = new StringBuilder();
    Process procMessage = new Process();

    //Start svnlook.exe in a process and pass it the required command-line args.
    procMessage.StartInfo = new ProcessStartInfo(svnpath + @"binsvnlook.exe",  String.Format(@"{0} ""{1}"" -r ""{2}""", command, args[0], args[1]));
    procMessage.StartInfo.RedirectStandardOutput = true;
    procMessage.StartInfo.UseShellExecute = false;
    procMessage.Start();

    //While reading the output of svnlook, append it to the stringbuilder then
    //return the output.
    while (!procMessage.HasExited)
    {
        output.Append(procMessage.StandardOutput.ReadToEnd());
    }

    return output.ToString();
}
```

Next, we’ll use our helper function to get the author, message and log of the commit.

```csharp
string author = SVNLook("author", args);
string message = SVNLook("log", args);
string changed = SVNLook("changed", args);
```  

Using this information, we can also deduce the name of the repository and the current path or branch of the repository.

```csharp
string[] changeList = changed.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
string changeFirst = changeList[0].Remove(0, 4);
int changeFirstSlash = changeFirst.IndexOf("/");
string repoBranch = changeFirst.Substring(0, changeFirstSlash);
string repoName = args[0].ToString().Substring(args[0].LastIndexOf(@"") + 1 );
```

## Sending an email

Now that we have all the information we need, we just need send it in an email. For this example I’m using a simple `.txt` email template with no formatting, but you could easily use an `HTML` template for some structure and style. Here is the template I used:

```
Commit made by {0}.

{1}

Files changed:

{2}
```

And here is the code used to fill the template:

```csharp
string emailTemplatePath = @"C:hooksPostCommit.txt";
string emailTemplate = string.Format(File.ReadAllText(emailTemplatePath), author, message, changed);
```


All that remains now is to send the email to the desired recipient. This example uses Gmail as the SMTP server, but you could use IIS or Amazon SES or any other email forwarding or SMTP service.

```csharp
string subject = string.Format("commit number {0} for {1}", args[1], repoName);
MailMessage mm = new MailMessage(“<from email>”, “<to email>”);
mm.Body = emailTemplate;
mm.Subject = subject;

SmtpClient mailClient = new SmtpClient("smtp.gmail.com");
mailClient.Port = 587;
mailClient.Credentials = new System.Net.NetworkCredential("<gmail username>", "<gmail password>");
mailClient.EnableSsl = true;

mailClient.Send(mm);
```

Make sure you also `return 0;` on the last line to indicate the code completed successfully.

## Finalisation

Now that the code is complete, you just need to build the project and copy the .exe file from the `bin/debug` folder in your project to the bin folder in your VisualSVN server installation folder, which in my case was `C:/Program Files (x86)/VisualSVN Server/bin`. Then, open up VisualSVN server and right click on the repository that you want to add the post-commit hook to and click properties.

![post commit 1](/images/post-commit-1.png)
![post commit 2](/images/post-commit-2.png)

Open the hooks tab and double click on **Post-commit hook**. It will open a window that you need to paste the following code into. All it does is tell VisualSVN to run the .exe when a commit happens and passes in the required arguments:

```
"%VISUALSVN_SERVER%\bin\<name_of_your_built_exe>.exe" "%1" %2
```

And you’re done! Make some changes and commit them to see the code in action. As you can see, it should be fairly easy to customise the code to your needs, as many services such as Pivotal tracker give you an endpoint URI to POST to to record commits in the external application. You can view the source for VB.NET and C# below!

[View the GitHub Repo for this article](https://github.com/Martin-Brennan/martin-brennan-code/tree/master/post-commit-hook)
