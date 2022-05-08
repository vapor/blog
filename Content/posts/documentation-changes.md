---
date: 2022-03-08 01:16
description: We're updating the documentation site and moving the old docs to a new site
tags: docs
author: Tim
---
# Vapor Documentation Changes

As part of the [recently announced](/posts/vapor-next-steps/) updates to Vapor and it's developer experience, we're changing the way Vapor documentation works. 

First, we've migrated the docs to a more modern stack. Rather than everything running on a single Digital Ocean box, the docs now live in S3 running behind a CDN. This should mean faster loading times for users and more stability. And of course deployments and updates are [all automated](https://github.com/vapor/docs/blob/main/.github/workflows/deploy.yml).

Next, the documentation for Vapor 1 to Vapor 3 - all versions that are end of life - is moving to https://legacy.docs.vapor.codes. The docs here are old and no longer really updated but we're keeping them up for posterity. In the coming days, these docs will be removed from the [main documentation site](https://docs.vapor.codes/).

The [main documentation site](https://docs.vapor.codes/) is also undergoing some changes. With the removal of the old docs, we will no longer put the latest documentation behind the `/4.0` path. This will make linking to the docs much simpler and should fix the issue of old and broken links when people try to search for stuff. We'll set up redirects for the `/4.0` docs to make sure that no links are broken.

With the roll out of the centralized new docs, this enables us to better integrate localized docs. You will already see a new language selection drop-down on all pages of the docs. Any page that has a translation available will show the translated page and we'll work on integrating the Chinese and German docs. This will make it much simpler for us to support new languages and should help and encourage users wanting to add new translations. If you would like to contribute a new language that would be amazing! You can see details on how to add a new translation in the [docs README](https://github.com/vapor/docs#translating).

Finally, in the coming months, we'll be rolling out a new look and feel for the docs. The docs will be part of an updated look for all Vapor sites, providing a more modern look, consistency across sites and a better user experience. Watch this space!