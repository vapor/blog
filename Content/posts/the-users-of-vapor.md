---
date: 2026-09-18 19:00
description: Take a look at some of the teams, apps and users of Vapor and how they find working with it.
tags: vapor, 10 years
author: 0xTim
---
# The Users of Vapor

> This post is part of a series of posts for Vapor Week. See the [main blog post](https://blog.vapor.codes/posts/ten-years-of-vapor/) for more information.

In the last post for Vapor Week, we thought we'd take a look at the people who actually use Vapor. These days, Vapor is used by many, many companies, from the small one-person indie apps to some of the biggest corporations in the world. It's amazing (and sometimes a little scary!) to see the range of people using it. Here are some of them.

First, I want to highlight a really cool project, [Swift Fiddle](https://swiftfiddle.com). This site is used for testing out Swift snippets, essentially a playground on the web. It has the LSP built-in to the browser, offering code-completion and you can run code on Swift versions all the way back to Swift 2.2! Along with its sister site, [The Swift AST Explorer](https://swift-ast-explorer.com/), it is well known among compiler engineers and Swift users. As well as being powered by Vapor, it is fully open source!

![A demo of SwiftFiddle.com showing the Vapor logo](/static/images/posts/swift-fiddle.png)

[Frank Lefebvre](https://www.linkedin.com/in/franklefebvre) is well known in the iOS Community, and is currently working at a start-up where they use Vapor:

> I've been using server-side Swift frameworks since 2016, and especially Vapor since the beginning of version 4, both for public-facing APIs and for internal servers. Usually when I start a project from scratch, my first step is to create an OpenAPI spec, then I use the Swift OpenAPI generator to create scaffolding code for both the Vapor server and a client app. Then it's a breeze.
>
> The project I'm currently working on is a digital safe for lawyers to share documents with their clients, to be released soon. For this project I designed the security architecture (end-to-end encryption and authentication based on quantum-resistant algorithms). I implemented the back-end using Vapor, and Claire Sivadier has been working on a SwiftUI client for macOS, iOS and iPadOS. The OpenAPI spec and generator plug-ins are provided in a Swift PM module, to be shared easily between applications. Eventually the service will be deployed in the cloud, but currently the development and staging servers run on a small cluster of Raspberry Pi boards in my office: this setup makes it much easier to monitor and debug the service.

Another company is [Litmaps](https://www.litmaps.com), a scientific literature graphing service, and their service [ResearchRabbit](https://www.researchrabbit.ai), both built on Vapor. It's safe to say Vapor powers a significant amount of traffic from their users, helping them find the research papers they need:

![A screenshot of metrics of Litmaps showing millions of requests a minute](/static/images/posts/litmaps-stats.png)

Some well-known users of Vapor include the award-winning Things app by Cultured Code. They gave a talk at the ServerSide.swift conference talking about their migration to Swift using Vapor. I think the talk speaks for itself:

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/oJArLZIQF8w?si=3EGl3f_MENWU0bf4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen class="mb-2"></iframe>

Speaking of migrations, Apple published a post on Swift.org about migrating the monitoring service used in the Passwords app comparing against Java. The [whole post is well worth a read](https://www.swift.org/blog/swift-at-apple-migrating-the-password-monitoring-service-from-java/), but the before and after graph showing hardware utilisation, memory usage and throughput was a standout:

![A graph showing Swift against Java with 50% less hardware utilisation, 90% less memory usage and 40% more throughput](/static/images/posts/passwords-monitoring-service-graph.png)

Another talk from the conference was from [TelemetryDeck](https://telemetrydeck.com), a privacy-first mobile analytics service:

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/Uvnp7bq6Hf0?si=YmSeC-iGkq47QjWG" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen class="mb-2"></iframe>

Finally, a special shoutout to the [SwiftPackageIndex](https://swiftpackageindex.com), who have built an amazing platform that serves the Swift community to discover packages, running on Vapor.

We're adding more and more people to our [showcase site](https://www.vapor.codes/showcase/), so if you'd like to be included, please [reach out](https://github.com/vapor/website/issues/new).

## Sponsors

As I've mentioned in every post this week, Vapor wouldn't be possible without the support of our sponsors. So if you do use Vapor and have found it useful, please consider sponsoring us, either through [GitHub Sponsors](https://github.com/sponsors/vapor) or [Open Collective](https://opencollective.com/vapor). It really helps ensure that we can continue to build great libraries for you to use and build amazing things. We will also be announcing some new corporate tiers and support packages that may help with ensuring the support of your critical services in the near future. If this is something you would be interested in, please [reach out to us](mailto:tim@vapor.codes).

Over the years we've had countless individuals and companies sponsor us. So if you have sponsored Vapor, whether it be a one-off sponsorship, or recurring, or bought merch from [the store](https://store.vapor.codes/) - thank you! The last ten years have been an incredible journey, and we can't wait to see what we build in Vapor, and what you build with it in the next ten years.

The Vapor Team

> This is the last in a series of posts for Vapor Week. Also in the series:
> * [Ten Years Of Vapor](https://blog.vapor.codes/posts/ten-years-of-vapor/)
> * [Vapor 5 Beta 1 released](https://blog.vapor.codes/posts/vapor-5-beta/)
> * [Documentation for all](https://blog.vapor.codes/posts/documentation-for-all/)
> * [What's New in Vapor 5 Beta](https://blog.vapor.codes/posts/whats-new-in-vapor-5-beta/)
> * [The Users Of Vapor](https://blog.vapor.codes/posts/the-users-of-vapor/)