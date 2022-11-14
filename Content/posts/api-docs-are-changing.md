---
date: 2022-11-14 18:00
description: The API docs are changing as we finish migrating to AWS
tags: docs, framework
author: Tim
---
# Vapor's API Docs Are Changing

One of Vapor's less known sites is the API documentation. This hosts all of the API reference docs for the different packages in the framework. The API docs are the last remaining thing running on our old Digital Ocean box. They also have a very odd design and are built using the now-defunct Swift-Doc project. So we're changing them.

## Migrating to AWS

We're migrating the current site at [https://api.vapor.codes](https://api.vapor.codes) to AWS. This allows for us to save on hosting costs as it's just a static site and improve the performance of the site for everyone using it as we can leverage the CloudFront network and put the site in a CDN close to you.

Whilst we undertake the migration - which will take a while due to the changes below - there may be downtime and not all the docs will work straight away. So the original API docs are available at [https://legacy.api.vapor.codes](https://legacy.api.vapor.codes) and will stay there until the migration has completed.

## Migrating to DocC

DocC was introduced a while ago and now supports everything we need to host our API docs (with some workarounds). Additionally the original package we used for generating the docs (Swift-Doc) is now archived so we kinda have to migrate! Currently not all the packages work with DocC so we'll add them one by one as we add support. If you want to help and get the API docs working with DocC across Vapor's many repos then [contributions are always welcome](/posts/contributing-guide/)!

## Vapor's New Design

Vapor's new design for the sites is almost ready to roll out across the blog and then subsequent sites. The API docs will be integrated into the new design (which will necessitate some workarounds to make it work with DocC!) as well. This will make them much easier to find and provide a consistent experience across the sites.