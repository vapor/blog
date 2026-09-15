---
date: 2026-09-15 14:00
description: After 6 and a half years of Vapor 4, we're excited to show off the next version of Vapor, Vapor 5 with the first beta release
tags: vapor, 10 years
author: 0xTim
---
# Vapor 5 Beta

10 years to the day that Vapor 1.0 was tagged, and after nearly 6 and a half years and 306 releases of Vapor 4, I'm super excited to announce the first beta release of Vapor 5!

![The Vapor 5 Logo](/static/images/posts/vapor-5-logo.png)

Work started on Vapor 5 over 2 years ago and we've been quietly working on the alphas since the first alpha release in June. Now, after 49,000 lines of code changed, with all of the architectural changes complete, we're ready for more eyes and people to actually try out the new version.

> This post is part of a series of posts for Vapor Week. See the [main blog post](https://blog.vapor.codes/posts/ten-years-of-vapor/) for more information.

## New Features

Vapor 5 is essentially a complete rewrite of all of the framework. The highlights include:

* Now more `EventLoop` or `EventLoopFuture`! Vapor 5 is fully async/await with real structured concurrency support. We've even managed to almost completely remove NIO from the public APIs, with a couple of `ByteBuffer`s to remove from Multipart and some NIO work around compression and TLS to figure out.
* A brand new HTTP server. Vapor 5 builds upon the new [Swift HTTP Server](https://github.com/swift-server/swift-http-server), which is a new, modern HTTP server with support for bidirectional streaming, HTTP/3, and much more. Vapor can now concentrate on being a great web framework and hand off the HTTP handling to the new server.
* Streaming by default. Vapor5 request and response bodies and now streaming-first, making it super easy to work with large files, backpressure, and make it much more memory efficient. We still have lots of syntactic sugar on top, so if you're dealing with `Data` or `JSON` you can easily handle those. Even better, the streaming closures use `Span`, making it as performant as possible.
* Service Lifecycle support. Vapor 5's `Application` is just a `Service` making it super easy to integrate with bigger applications. We also allow you to pass other services to you `Application` and let Vapor handle the lifecycle of those services as well.
* Swift Configuration support. We now use Swift Configuration to manage configuration of Vapor, making it easier to integrate with the rest of the Swift ecosystem.
* Swift HTTP Types. Our request and response types now expose `HTTPTypes` such as `Status` to better integrate with the ecosystem and make the HTTP server (and NIO) an implementation detail.
* A brand new, rewritten, Vapor Testing library that unifies the API with one way to test your application.
* Streaming support in the `Client` and `VaporTesting`.
* _All_ of the SwiftPM flags! We have enabled almost every flag we could, including `InternalImportsByDefault`, `NonisolatedNonsendingByDefault` and `.strictMemorySafety()`. Not only does this ensure we are as safe as possible, but it sets us up for the future to handle Swift versions.
* New traits that make it easy to turn off certain features to shrink down the amount of Vapor you need to compile, use and distribute
* A new, experimental macro library. We've built a new experimental macro library to help you define your routes and controllers. This brings type-safe routing and parameters, compiler checked authentication, and simpler route definitions! This will be a separate post and is still moving quickly.

## Known Issues

Vapor 5 Beta 1 has a couple of known issues, notably support for compression, which is coming soon, and support for Websockets, which is waiting on an implementation in the HTTP server. Keep an eye on the releases for these getting released!

## Swift 6.4 Required

Vapor 5 requires Swift 6.4 or later (and macOS 26 or later), which luckily was released just yesterday! This is because we take full advantage of the new Swift features, full `Span` support, and to ensure a lot of common errors, including things like trying to capture the request body are compiler errors.

## Vapor 4

Vapor 4 is still the current version of Vapor, though most of the effort and new feature development will now happen in Vapor 5. However, we will be announcing a support schedule closer to the release of Vapor 5, but rest assured Vapor 4 will continue to receive bug fixes and security updates long after the Vapor 5 release, with official paid extended support for those that need it.

## Try It Out

The [template](https://github.com/vapor/template) has already been updated on the `vapor5` branch with support for Fluent if desired. Leaf integration will be available soon. You can create a new project with:

```bash
vapor new MyVapor5App --branch vapor5
```

Note: the template currently relies on FluentKit directly, with some of the integration work done in the template. That will likely move over to `vapor/fluent` in the future once we update that.

Whilst the betas should be fairly stable, we don't recommend running this in production just yet for critical services. However, we are excited to see how you find Vapor 5. As always, if you discover issues, you can [raise an issue on GitHub](https://github.com/vapor/vapor/issues/new/choose) or reach out [on Discord](https://vapor.team/). We don't have a complete timeline for the Vapor 5 release, some of it depends on the ecosystem dependencies and we want to make sure we get it right. Vapor 4 has been the supported version for 6 and a half years and counting, we want a similar lifespan for Vapor 5.

Happy building!