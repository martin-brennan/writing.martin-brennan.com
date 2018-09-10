---
id: 26
title: PHP, mySQL and FTP on an Amazon EC2 Instance
date: 2012-07-28T17:44:31+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=26
permalink: /php-mysql-and-ftp-on-an-amazon-ec2-instance/
comments: true
dsq_thread_id:
  - 965518167
iconcategory:
  - tutorial
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465012729
mashsb_jsonshares:
  - '{"total":0}'
outofdate:
  - 'true'
outofdatenote:
  - Since this post it has become insanely easy to spin up EC2 instances with PHP, mySQL and FTP, especially if all you want is a Wordpress install. Do not follow the advice here.
categories:
  - Development
  - Tutorial
tags:
  - Amazon
  - AWS
  - EC2
  - FTP
  - mySQL
  - PHP
  - phpMyAdmin
  - SFTP
  - SSH
---

{% include deprecated.html message="Since this post it has become insanely easy to spin up EC2 instances with PHP, mySQL and FTP, especially if all you want is a Wordpress install. Do not follow the advice here." cssclass="danger" %}

{% include in-post-ad.html %}

In the past couple of months I’ve been diving into developing with PHP, to broaden my skills by learning a new language, initially as part of [Fred Boyle’s code challenge](http://fredboyle.com/codechallenge/). This also gave me an excuse to mess around with Amazon’s myriad cloud services, something that I’ve wanted to try for a while. Specifically Amazon’s Elastic Compute Cloud, or EC2, a component of [Amazon’s Web Services](http://aws.amazon.com/) which you can use to set up and manage a cloud-based web server instance using Amazon’s extensive network and computational power.<!--more-->

To my surprise, it was more difficult than I expected to manually install and configure all of the individual components that comprise a web server. I put it down to a lack of experience on my part, especially with using SSH to issue commands to the server and setting up PHP and mySQL manually instead of using an excellent tool such as [MAMP](http://www.mamp.info/en/index.html), [WAMP](http://www.wampserver.com/en/) or [XAMPP](http://www.apachefriends.org/en/xampp.html) to simplify the process.

After a lot of troubleshooting and Googling and stubbornly refusing to let the setup process beat me, I was able to set up everything successfully and have the simple PHP to-do list application that I had developed up and running.

In this guide I’ll show you how to sign up for Amazon’s web services, launch and configure an Amazon EC2 instance, open the ports required for SSH, web and FTP access to your instance, and go through the ins and outs of setting up PHP, mySQL, SFTP and phpMyAdmin on the instance via SSH.

So, let’s get into it. The first thing we’ll be doing is signing up for Amazon Web Services.

## Signing up for AWS

This is probably the easiest part of the whole process. If you are already have an Amazon account, just go to the [AWS signup page](http://aws.amazon.com) and log in from there using your Amazon credentials. You can also use this page to sign up for an AWS account if you don’t already have one.

If they aren’t already stored, Amazon will need you to enter your credit card details and contact details. You won’t actually be charged for anything until you start using their web services. For the budget conscious, a pricing guide can be found [here](http://aws.amazon.com/ec2/pricing/). Amazon has a free usage tier for EC2, detailed at <http://aws.amazon.com/free/>, which lets you run a free Micro instance for one year after you sign up, so if you stick to the Micro EC2 instance while you are messing around you shouldn’t be charged a cent.

## Setting up an Amazon EC2 Instance

There are a few steps that need to be completed before you can start installing things and using an EC2 instance to host your site or blog. We need to:

  * Sign up for an EC2 account
  * Set up an EC2 instance
  * Create a key pair file for use with SSH
  * Create a security group and open any required ports
  * Set up an Elastic IP address

All of these tasks are also relatively straightforward. Amazon provides a lot of options when setting up an instance, but for this guide we’ll mainly be sticking to the default options so we don’t overcomplicate things.

### 1. Sign up for an EC2 account

Even after singing up for an AWS account, you will need to complete **another** signup process to be able to use the EC2 service, as well as a few of the other services that they provide. After you have logged in, click on the EC2 tab and begin the signup process from there.

During the signup, you will be asked to provide a phone number in order to prove your identity, which will also be stored in case Amazon ever needs to contact you via phone. Amazon will then place an automated call to this number and you will need to enter the provided code to verify your identity, which I thought was pretty cool. What’s even cooler is that Amazon places this call to _international_ numbers as well, so don’t worry if you’re not living in the United States!

Once the signup process is out of the way, we can finally start getting our hands dirty!

### 2. Set up an EC2 instance

If you’re not there already, go back to the EC2 tab and click the Launch Instance button on the dashboard and a new window will pop up. If you are given the option, choose the Classic Wizard to set up your instance. From here, you will be shown a list of Amazon Machine Images, or AMIs, which are basically snapshots of virtual servers which have access to repositories of programs to install.

The easiest way to start an instance is to select one of the AMIs in the Quick Start tab, which is what we’ll be doing. You can also access community AMIs and buy software components to make your own AMIs, both of which are outside the scope of this guide. Your best bet if you are just starting out is to use one of the AMIs provided by Amazon or Ubuntu, which guarantees reliability and authenticity.

Anyway, go ahead and choose the Amazon Linux AMI, which will most likely be at the top of the list. You can either run a 64-bit or 32-bit instance; choose either one, it doesn’t really matter for our purposes right now.

![amis](/images/amis-300x195.png)

On the Instance Details step you can leave the settings as they are, just make that the instance type selected is “Micro”. On the next screen just leave the options at their defaults as well, then click continue.

![instance options](/images/instance_options.png)

In the next step, you can define 10 tags as key-value pairs that help you identify this instance which will help set it apart from any other instances you may be running. Since we only have one instance, just use the default Name key and give it a value of whatever you want. For this guide I will enter Tutorial as the Name of my instance.

#### Create a key pair file for use with SSH

Next, you will be asked to create a Key Pair file. **This step is important**, as you will be using the Key file that Amazon creates to securely connect to your EC2 instance via SSH, which is what you’ll be to install programs and configure your instance. Give your Key Pair a name, I will be calling mine **tutorial**, and download the file. If you’re on a Mac, a good place to store the file is in the ~/.ssh directory, which is a hidden folder you’ll find inside your User folder. If you can’t see your hidden folders, follow [this guide](http://www.mactricksandtips.com/2008/04/show-hidden-files.html), which shows you how to view hidden folders on a Mac.

_Note:_ If you are on Windows you will most likely be using PuTTy for SSH commands. PuTTy uses the extension .ppk for its key files, while Amazon creates a .pem file. You will need to run this .pem file through the PuTTygen tool to use it, which you can download along with PuTTy [here](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).

After you have copied your key file to ~/.ssh or whichever directory that you have chosen to use, you will also need to change the permissions for your key file to make it only readable by you. To do this, open up Terminal and switch to the directory you stored your key file in like so :

```shell
cd ~/.ssh
```

Then, enter the following command :

```shell
chmod 400 name_of_your_key_file.pem
```

If you’re anything like me you’ll want to know what this does. Basically, the chmod command is used to permissions for a file. The three digits are permissions for the Owner, Group and World respectively and range in value from 0 to 7, with 0 being no permissions and 7 being full read, write and execute permissions. The command chmod 400 is giving the file’s Owner, which is you, read permissions, and giving everyone else no permissions at all, which is exactly what we want for our key file. For more information on chmod permission codes, [read this](http://www.december.com/unix/ref/chmod.html).

#### Create a security group and open any required ports

You will then be required to define a security group for your instance to be a part of. Security groups are used to tell the instance which ports to open, which will determine the protocols and traffic that your instance can accept. We’re going to create a new security group for this example. The first step is to give the group a name and a description.

![security group](/images/security_group.png)

You can then add inbound rules to your security group. We are going to add port 80 and 8080 for HTTP, 21 and 12000–12100 for SFTP and 22 for SSH. If you required SMTP, you would also add port 25, and for HTTPS you would add port 443. For each of these ports, all you need to do is create a new rule and select Custom TCP Rule, enter the port number or range, and leave the source as 0.0.0.0/0, which is “All Internet”. Once you have added the required access rules, click Continue.

Finally, review your settings here and if you are happy, click the Launch button to launch your instance, which will take a few minutes to launch. You can head back to the Instances section of the EC2 dashboard and watch the status of your instance change in real time, which is pretty neat.

### Setting up an Elastic IP

The last thing we need to do to complete the instance set up is to allocate a new Elastic IP address to our instance. Allocating an Elastic IP lets you point a DNS to the instance, and makes it easier to connect third party programs or apps to your instance, for example those that handle FTP file transfer. Another benefit is that if you have multiple instances running, and your live instance fails, you can simply reallocate your Elastic IP to a different instance and have your site back up and running right away. For more information about Elastic IP’s, refer to Amazon’s guide [here](http://aws.amazon.com/articles/1346?_encoding=UTF8&jiveRedirect=1).

To allocate an Elastic IP, go to the EC2 tab and click Elastic IPs on the left hand side menu. Then click on “Allocate New Address” and click “Yes, Allocate” on the popup that appears. Finally, right click on the IP address and select Associate, select your instance from the menu, then click Yes, Associate. That’s all you need to do, and with that we are done setting up the EC2 instance.

Now that we’ve finished getting our hands dirty, we can start getting them absolutely filthy, with a crash course in using SSH to install PHP, mySQL, phpMyAdmin and FTP on our instance.

## Installing and setting up PHP, phpMyAdmin, mySQL and FTP

Now that we have everything set up, we can connect to the instance via SSH. SSH is, according to our friend [Wikipedia](http://en.wikipedia.org/wiki/Secure_Shell):

> Secure Shell (SSH) is a network protocol for secure data communication, remote shell services or command execution and other secure network services.

SSH is run via a command line program such as Terminal for the Mac, and allows you to send commands to your instance over a secure, encrypted connection.

### Connecting via SSH

To connect to your instance, go to the Instances section of the EC2 tab, right click on the instance you want to connect to and click connect.

A window will pop up with two options; “Connect with a standalone SSH Client” and “Connect from your browser using the Java SSH Client (Java Required)”. We are going to connect with a standalone SSH client, Terminal, so choose that option. Because we already set the permissions for our key file using chmod, we can just skip to step 4 of the process. Switch to your .ssh directory in Terminal using the command :

```shell
cd ~/.ssh
```

And then enter the command that Amazon gives you to connect to your instance, which will be something like :

```shell
ssh -i tutorial.pem ec2-user@23.23.229.35
```

_Note:_ If you hadn’t set up an Elastic IP earlier this command would be slightly different, because you would be connecting to the instance’s public domain instead of its IP address.

### Running updates and an overview of SSH commands

You should now be connected to your instance! You may be prompted to apply updates; if you are, run the command it tells you to run, which is:

```shell
sudo yum update
```

The instance will ask you whether it is okay to download the files used whenever you install anything or update on your instance.

At this point I’d like to give a brief overview of some of the SSH commands and syntax that we will be using, because they can be confusing if you are unfamiliar with them. You can skip this if you are already familiar with the command line.

**Commands**

**sudo** &#8211; Adding sudo before any commands allows you to run the command as the Unix root or superuser instead of the ec2 user. We will be using this in front of most commands as the ec2 user doesn’t have many install or other security privileges.

**yum** &#8211; Yum is a software installation tool for Red Hat/Fedora Linux, which is what Amazon’s Linux AMI uses. We will be using yum to install any packages, such as PHP and mySQL, on our server.

**vi** &#8211; Vi is the visual editor that comes with Unix systems, and it allows you to edit files on the instance using the Terminal window. Vi operates in both a command mode and an insert/edit mode, and I will go over a few of the commands later when we start editing files with it.

Now that we’re connected, we’ll set up Apache so we have a web server on which we can run our website.

### Installing and Configuring Apache

To install Apache, all you have to do is run the following command, and say yes to any of the prompts:

```shell
sudo yum install httpd
```

After Apache has been installed, we will need to make some changes to the `httpd.conf` file, which contains all of the settings for the server. To do this, we will need to use the vi editor that I mentioned earlier. Here are some of the basic commands that we will be using with the vi editor:

#### VI Editor Commands

**i** &#8211; Enter insert mode. This will allow you to edit the contents of the file.

**Esc** &#8211; Enter command mode. This will allow you to run commands on the vi editor, such as saving and quitting.

**While in command mode**

**:q!** &#8211; Quit the editor without saving changes.

**:wq** &#8211; Save changes and quit the editor.

**G** &#8211; Hold down shift and press g to move the cursor to the last line of the open file.

You can find a larger list of commands to use [here](http://www.cs.colostate.edu/helpdocs/vi.html).

Open the httpd.config file in the editor by entering the following command:

```shell
sudo vi /etc/httpd/conf/httpd.conf
```

All we need to change in here is setting up a Virtual Host for port 80 on the server. Virtual Hosts allow you to run multiple websites on the same server, which can be IP address based or name based. Go all the way to the bottom of the httpd.config file, which you can do by pressing G while in command mode, and uncomment the `<VirtualHost **:80>` section, `DocumentRoot` and `ServerName`. Leave `ServerAdmin`, `ErrorLog` and `CustomLog` commented out though, we don’t need them for now.

Change the DocumentRoot to `/var/www/html/`, which is the default directory for web files on an Apache server, then change the server name to the public domain name of your instance, which will be similar to `ec2-23-23-229-35.compute-1.amazonaws.com`. The last change we need to make is to the DirectoryIndex, which is the file that Apache serves when the root directory of the server is requested. This section is located toward the middle of the file. Change the line to:

```
DirectoryIndex index.html index.php index.sh default.jsp
```

This will allow you to have a PHP file as the DirectoryIndex file. The file name does not need to be index.xxx, this is usually just the default file name that most websites use. After you have changed everything, press Esc to enter command mode and type `:wq` to save and exit. Finally, start the Apache server using the command:

```shell
sudo service httpd start
```

You can now navigate to your server in your browser using either the IP address or the public DNS. If all goes well, you should see the Apache start page.

### Installing PHP, mySQL and phpMyAdmin

#### PHP & mySQL

We are getting to the tail end of this guide now, so hang in there! If you don’t have any need for PHP or mySQL, you can just skip this whole section. To install everything you need for PHP, just run this command:

```shell
sudo yum install php-mysql php php-xml php-mcrypt php-mbstring php-cli mysql
```

Which installs PHP and all of the extensions required for it. Just say yes to all of the prompts that appear. Next, we will install mySQL. Install and run the mySQL server with these commands, and say yes to all of the prompts:

```shell
sudo yum install mysql-server
sudo /etc/init.d/mysqld start
```

Then set the password for the root user to something secure:

```shell
mysqladmin -u root password '[PASSWORD]'
```

#### phpMyAdmin

mySQL is now installed and running, and we can now go a step further and install and configure phpMyAdmin. phpMyAdmin is a web based interface for administering mySQL, including managing users and setting permissions, creating databases and queries, and handling other similar database administration tasks. The process of installing phpMyAdmin takes the most steps in this guide.

First, change directory to the Apache root folder:

```shell
cd /var/www/html
```

Then, download phpMyAdmin to this folder:

```shell
sudo wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/3.3.9.1/phpMyAdmin-3.3.9.1-all-languages.tar.gz
```

Next, extract the files to the root of the folder:

```shell
sudo tar -xzvf phpMyAdmin-3.3.9.1-all-languages.tar.gz -C /var/www/html
```

Rename the folder to phpmyadmin and remove the zip file:

```shell
sudo mv phpMyAdmin-3.3.9.1-all-languages phpmyadmin
sudo rm -rf phpMyAdmin-3.3.9.1-all-languages.tar.gz
```

Create a Unix user for phpmyadmin and give it permission/ownership over the phpmyadmin folder.

```shell
sudo adduser phpmyadmin
sudo passwd phpmyadmin (After this you will be prompted to enter a password)
```

Give the user permission/ownership over the phpmyadmin folder, first by finding which user Apache uses by running:

```shell
egrep 'User|Group' /etc/httpd/conf/httpd.conf
```

And then, after finding this user, by changing to the root Apache directory and running the chown command on the phpmyadmin folder.

```shell
cd /var/www/html
sudo chown phpmyadmin.apache phpmyadmin/
```

Then, run this set of commands:

```shell
cd /var/www/html/phpmyadmin/
sudo mkdir config
sudo chmod o+rw config
sudo cp config.sample.inc.php config/config.inc.php
sudo chmod o+w config/config.inc.php
sudo service httpd restart
```

This changes your directory to the phpmyadmin folder, makes a config directory and sets permissions for it, copies a sample config file for phpmyadmin to the config directory and renames it then adds permissions to the config.inc.php file. Finally, the Apache server is restarted.

Now we need to run the phpMyAdmin setup. Navigate to `http://[your_instance_IP]/phpmyadmin/setup/index.php` and click New Server. All you need to change on the next screen is the PHP extension to use to mysqli if it is not already selected, and then enter the config auth user, which will be root, and config auth password, which is the password we entered earlier for the root mySQL user. Click save and you will be done. Don’t worry about the errors that appear after the setup, we will be fixing them up next.

You can now navigate to http://[your\_instance\_IP]/phpmyadmin/index.php and log in using the root user credentials. We will now handle the errors shown. One should be something along the lines of “The configuration file now needs a secret passphrase (blowfish_secret).”, and the other should be telling you to delete the config folder in the phpmyadmin directory. There will also be another error saying something along the lines of “The additional features for working with linked tables have been deactivated. To find out why click here.”, but don’t worry about that for now. We’ll fix the first error, and set up some other things in the config file, before deleting the config folder.

Open the config file, config.inc.php, by running this command:

```shell
sudo vi /var/www/html/phpmyadmin/config/config.inc.php
```

Near the top of the file you will see this line:

```shell
$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
```

All you need to do here is enter a random string of characters between the quotation marks. Scroll down to the /\* Server Parameters \*/ section, and change

```shell
$cfg['Servers'][$i]['extension'] = 'mysql';
```

to

```shell
$cfg['Servers'][$i]['extension'] = 'mysqli';
```

Scroll down a bit further and you will find the /\* User for advanced features \*/ section. Leave the control user and the control password commented out, as we will not need them, and uncomment all of the other lines starting with $cfg in this section and the two below it. Save your changes by pressing Esc and entering :wq. Change directory back to the phpmyadmin config folder.

```shell
cd /var/www/html/phpmyadmin/config
```

We are now going to copy the config.inc.php file out of the config folder and into the root directory so phpMyAdmin can use it, switch back to the root directory, and delete the config folder so that error is resolved. Run the following commands to achieve this:

```shell
sudo cp config.inc.php .. cd .. sudo rm -rf config/
```

We are almost done with installing phpMyAdmin! We just need to complete a couple more steps to ensure the installation is successful and all of the components are correctly configured, and to get rid of the final setup error.

First, log into phpMyAdmin and go into the Privileges tab, and select ‘Add a new user’. Enter phpmyadmin as the user name, change the Host to Local, then enter a password for the user. Select “Create database with same name and grant all privileges”, then click Check All in the Global Privileges section, then click Go and the database and user will be created.

Finally, and I promise this will be the last step in setting up phpmyadmin, we need to download a script called create_tables.sql and run it. This script will create the linked tables required in the phpmyadmin database we just created. To download it via SSH, first navigate to your ~/.ssh folder, then enter the following command to download the .sql file from the server to your downloads directory:

```shell
scp -i tutorial.pem ec2-user@23.23.229.35:/var/www/html/phpmyadmin/scripts/create_tables.sql ~/Downloads
```

The scp command is used to download a file over SSH. The structure is as follows:

```shell
scp -i your_keyfile.pem ec2-user@your_instance_IP:/file/location/on/instance /file/download/local
```

After you have downloaded the file, log back in to phpMyAdmin if you aren’t already logged in and go to the import tab. Select the create_tables.sql file from your Downloads directory and click Go. The script will be run and the tables will be created. If the error does not disappear, log out of phpMyAdmin and log back in and it should disappear.

And we’re done! Phew! The _very_ last thing that we need to do is set up SFTP on our server so we can transfer files between our server and our local machine easily without having to use SSH. Read on!

### Setting up SFTP

First of all we need to install the SFTP server, `vsftpd`, on our instance. Run the following command to install it:

```shell
sudo yum install vsftpd
```

Now we will need to edit the configuration file for the SFTP server. Open the `vsftpd.conf` file in the text editor:

```shell
sudo vi /etc/vsftpd/vsftpd.conf
```

In here we will be changing a few properties to make the SFTP server more secure. Change the properties listed to the values shown.

```shell
anonymous_login=NO
local_enable=YES
write_enable=YES
connect_from_port_20=NO
chroot_local_users=YES (you may need to uncomment this)
local_umask=022
```

There is also some lines that we will need to add to this configuration file to allow passive connections to the FTP server using the ports that we defined earlier in the security group for the instance (12000–12100). Add these lines to the bottom of your config file, then save and exit using `:wq`.

```shell
pasv_enable=YES
pasv_address=your_instance_IP
pasv_min_port=12000
pasv_max_port=12100
port_enable=YES
```

Now we will be securing the FTP upload directory to the ec2-user, so only they can read/write to the directory. First we will set the ec2-user to the owner of that directory and set the correct read/write permissions for that directory:

```shell
sudo chown -R ec2-user /var/www/html
sudo chmod 775 /var/www/html
```

After that, we will need to create a .userlist file and add the ec2-user to it, which will be used in vsftpd.conf as a list of users to give access to the FTP directory:

```shell
sudo vi /etc/vsftpd/vsftpd.userlist
```

Once in edit mode for the file, add the `ec2-user` user to it, save and quit. Open the vsftpd.conf file again using `sudo vi /etc/vsftpd/vsftpd.conf` and add the following lines:

```shell
userlist_file=/etc/vsftpd.userlist
userlist_enable=YES
userlist_deny=NO
```

Finally, you need to add nologin to the shell set to connect. Open `sudo vi /etc/shells`, which should look something like:

```shell
/bin/ksh
/usr/bin/rc
/usr/bin/tcsh
/bin/tcsh
/usr/bin/esh
/bin/dash
/bin/bash
/bin/rbash
```

Add the line `/usr/sbin/nologin` to the end of the file. To finish off, create a usergroup and add the ec2-user to it, then start up the vsftpd service:

```shell
sudo groupadd ftpusers
sudo usermod -Gftpusers ec2-user
sudo service vsftpd start
```

You will now be able to connect to your instance and upload/download files using SFTP in your preferred file transfer application.

## Conclusion & Further Reading

After all of that, you should now have an Amazon EC2 instance humming along quite nicely with the basic components installed that are required for PHP and mySQL web applications. You should now know how to:

  * Create an Amazon EC2 instance
  * Manage security groups for your instance
  * Create and associate Elastic IP addresses
  * Connect to your server and issue commands via SSH
  * Install and configure PHP, phpMyAdmin, mySQL and SFTP on your server

Now that you have your server up and running, the fun really starts! You can start uploading your websites via your preferred SFTP application or program, create mySQL databases and upload a web app, or you can set up more features on your instance such as support for a WordPress blog.

When installing and running things on your instance, you may want to keep in mind the resources available to the Micro instance if you are hosting large or high traffic websites, because of the relatively small amount of RAM allocated to the instance and the low I/O performance. For more information on instance tier hardware specifications, [read this page](http://aws.amazon.com/ec2/instance-types/).

I recommend that before you use the instance for production purposes that you do some further reading and experimentation first. Amazon’s web services are powerful, but you must use the power wisely, and make an informed decision about whether Amazon’s web services are the best tools for the job that you need to do. Below is some further reading that you might like to peruse.

### Further Reading

[Tips for Securing Your EC2 Instance](http://aws.amazon.com/articles/1233) &#8211; Some tips from Amazon about securing your instance to avoid security vulnerabilities.

[Remotely Connect to Your EC2 Server Using Coda FTP](http://www.evanconkle.com/2011/11/remotely-connect-ec2-server-coda-ftp/) &#8211; I use Coda primarily for development, and this handy guide tells you how to connect to your instance using key files and Coda’s FTP functionality.

[Setting Up WordPress on Amazon EC2 in 5 Minutes](http://coenraets.org/blog/2012/01/setting-up-wordpress-on-amazon-ec2-in-5-minutes/) &#8211; You could probably skip to step 7 on this one, it tells you how to download, install and set up the latest WordPress installation on your instance.

[Amazon EC2 Cloud Installation and Setup](http://onlinewebapplication.com/2011/09/amazon-ec2-cloud-installation-setup.html) &#8211; This article covers many of the same steps as my article, but using Windows instead of Mac. It covers using PuTTY for SSH and Filezilla for SFTP.
