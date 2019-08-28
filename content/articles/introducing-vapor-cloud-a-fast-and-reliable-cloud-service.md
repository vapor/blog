---
title: "Introducing Vapor Cloud — A Fast and Reliable Cloud Service"
date: "2017-07-05"
tags: [
    "Announcement",
    "Vapor Cloud"
]
author: "Tanner Nelson"
---

Since the launch of the Vapor framework, we have been eagerly following all the amazing apps built with Vapor, and all contributions from our community — and we love it!

Our goal with creating Vapor was to make web development faster, safer, and more importantly easier. Although we believe Vapor as a web framework achieves this goal, we often see that hosting can be a tricky part of building the next big thing. This is why, today, we are happy to announce a new companion to Vapor: Vapor Cloud.

Vapor Cloud is a fast, reliable, and feature rich cloud service, built by Vapor for Vapor. Our goal with Vapor Cloud is to make hosting your application as easy as using Vapor. We have created a seamless experience that integrates directly into the Vapor Toolbox CLI you already use. With just one command ($ vapor cloud deploy) you can deploy your application to the cloud.

A beta version of Vapor Cloud is open to the public starting today. You can signup at https://dashboard.vapor.cloud/signup.

## Toolbox and Dashboard

Through the new beta of the toolbox, you can create projects, applications, environments, run commands live, tail live logs, and much more.

You can install the beta version of the toolbox using Homebrew and APT. Visit our docs for more information on getting started https://docs.vapor.cloud/toolbox/install/.

Alongside the toolbox, you can use our dashboard, where you also can see statistics, cronjob logs, and much more.

![image](/img/articles/introducing-vapor-cloud.png)

## Simple pricing

Vapor Cloud is built on-top of Amazon Web Services and is billed similarly. You pay hourly for the resources (hosting, database, cache, etc) that you use. This means if you only need to scale your web application up to meet higher demand for a few hours, you will only pay extra for those hours.

Of course, we also offer a free plan to try out Vapor Cloud. It includes up to 20,000 requests a month after which you can choose to upgrade to one of the paid plans if you like.

All Vapor Cloud plans (even free) includes all dashboard and project management features. This means you can invite your whole team, monitor your app’s resources, use your own domain, and even attach a free Let’s Encrypt SSL/TLS certificate.

## Packed With Features

The goal of Vapor Cloud is to provide all Cloud hosting features that your Vapor app will need. Since Vapor Cloud is built specifically for Vapor, configuring these additional features is incredibly easy. There’s really nothing to configure actually. Things just work.

### Zero Downtime Deployment

Your app will stay online, even during deployments. Vapor Cloud was built from the ground up for high availability.

### Database

Vapor Cloud offers MySQL, PostgreSQL, and MongoDB databases. The credentials for these databases are automatically exposed to your Vapor application upon deployment.

### Monitoring

You can easily track the traffic, average response times, and memory usage of your application through the Vapor Cloud dashboard.

### Persistent Filestorage and CDN

All Vapor Cloud applications are given free access to an S3 bucket for uploading and storing files.

Furthermore, uploaded images can be resized or cropped on the fly using our CDN API.

### Cron Jobs

Vapor Cloud integrates with Vapor’s command system to allow easy scheduling of recurring jobs, often called cron jobs.

### HTTP/2 and IPv6

All projects on Vapor Cloud automatically works with HTTP/2 and IPv6. This will prepare you for the future, and make your websites faster.

### Much More…

There are more features that we haven’t mentioned, and many more coming in the near future.

## A New Type of Cloud

With Vapor Cloud, you get a complete serverless cloud architecture that feels like part of the framework. We think this is a big step in making web development faster, safer, and easier.

![image](/img/articles/introducing-vapor-cloud2.png)

Visit https://vapor.cloud for more information and sign up for the public beta at https://dashboard.vapor.cloud/signup.
