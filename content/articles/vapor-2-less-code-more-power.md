---
title: "Vapor 2: Less code, more power."
date: "2017-05-17"
tags: [
    "announcement",
    "framework"
]
author: "Tanner Nelson"
cover: "/img/articles/vapor-2-less-code.png"
---

Our small team has worked incredibly hard refactoring, optimizing, and improving every aspect of Vapor to make this a fantastic update. Let’s take a look at everything that’s changed.

## Tons of New Features

Hundreds of GitHub issues solved and PRs merged, thousands of lines of code changed, and over 100 tagged alpha and beta releases. We’ve been working really hard to bring improvements to every corner of the framework.

![image](/img/articles/vapor-2-less-code2.png)

To name a few notable changes:

* Build times have been greatly improved — especially for clean builds. It takes Vapor 2 ~90 seconds to download dependencies and compile from scratch. This is 36% faster than Vapor 1 which took ~140 seconds.
* Type-safe routing has been expanded to allow for infinite nesting.
* Fluent now has relations, joins, timestamps, soft delete, and much more.
* Creating, reading, and transforming data like JSON with Node has been made easier and more performant.
* Vapor 2 no longer includes LibreSSL. Any TLS provider that supports the OpenSSL API can be used.

Check out the 2.0.0 tag for more detailed information.

## Way Faster

The previous version, Vapor 1.5, was fast — up to 100x faster than popular web frameworks built with PHP and Ruby — but Vapor 2 is even faster. Initial benchmarks show response times up to 3x faster.

![image](/img/articles/vapor-2-less-code3.png)

This added speed comes from optimizations of our HTTP, URI, and TCP layers. Most notably, Vapor now uses an HTTP parser forked from Nginx.

## Less Code

![image](/img/articles/vapor-2-less-code4.png)

Thanks to a lot of code refactoring and cleanup, Vapor 2 is leaner and more focused.

Most notably, Vapor 2’s dependency architecture has been inverted making features like the Fluent ORM opt-in. This keeps Vapor 2 lightweight while allowing add-on packages to be updated independently.

## New Docs

Vapor’s documentation has been remastered. It features better mobile support, expandable navigation, and a dynamic table of contents for each section. You can even search through all pages of the docs in one place.

![image](/img/articles/vapor-2-less-code5.png)

Visit the new docs at https://docs.vapor.codes/2.0/.

## Available Now

If you haven’t tried Vapor yet, now is a great time to start your first project. Check out our brand new getting started guide.
