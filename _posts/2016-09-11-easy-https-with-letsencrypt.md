---
title: Easy HTTPS With Let's Encrypt
date: 2016-09-11T20:30:00+10:00
author: Martin Brennan
layout: post
permalink: /easy-https-with-letsencrypt/
---

Well, since [my last post on HTTPS](/google-chrome-start-marking-http-connections-insecure/) I've gone and put an SSL certificate on my webserver and forced HTTPS for all connections to this site. I decided to do this tonight while I was doing some other poking around over SSH, and found that it was even easier to set up than I thought it would be. To accomplish this, I used [Let's Encrypt](https://letsencrypt.org/), which issues free SSL certificates so more websites can be served over HTTPS. For those not in the know:

> Let’s Encrypt is a free, automated, and open certificate authority (CA), run for the public’s benefit.

First of all, I headed over to the [Getting Started page of Let's Encrypt](https://letsencrypt.org/getting-started/), which sends you to the [certbot](https://certbot.eff.org/) tool. From here, you choose a web server and an operating system and you are given detailed instructions on how to install the certificate. Basically, certbot fetches and deploys SSL/TLS certificates for your webserver, which you then set up your webserver to use. For example, this site is running on an Ubuntu [DigitalOcean](https://www.digitalocean.com/) droplet with the ngnix webserver. I found the guide [How To Secure Nginx with Let's Encrypt on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04) extremely helpful to read through as well in this process, and it also gives you a link to the [SSL Server Test](https://www.ssllabs.com/ssltest/analyze.html) which will let you know if you've done everything okay.

Overall, I found the process easy, and the guides and tools provided are top-notch. The people behind Let's Encrypt have done a great job, and I'll be recommending it to colleagues who are looking to do the same thing. You can now rest easy reading this blog and knowing it was written by me, Martin Brennan, and not the Illuminati injecting subliminal messaging driving you to BUY CONSUME REPRODUCE &#x25b2;.
