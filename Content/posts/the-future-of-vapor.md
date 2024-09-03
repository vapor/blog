---
date: 2024-09-03 12:00
description: Discussing what the future holds for Vapor
tags: framework, vapor5
image: /static/images/posts/Vapor5.png
author: Tim
authorImageURL: /author-images/tim.jpg
---
# The Future of Vapor

After nearly 4 and a half years, and nearly 400 releases of the main Vapor project alone, Vapor 4 is starting to show its age. [A couple of years ago](https://blog.vapor.codes/posts/vapor-next-steps/) we discussed a vague plan for Vapor 5, what we wanted to add and how we thought the future of the ecosystem would look. A lot has changed in those years and we made a bit of a gamble with the timescales for Swift 6 that didn't pan out. But such is life!

Those changes in the ecosystem were substantial. `async`/`await` was introduced, `Sendable` support was added with the use of lots of locks. It wasn't pretty but it worked. We added async streaming bodies for the request and response, we have 0 warnings with Swift 6 strict concurrency checking.

Now, with the release time of Swift 6 known, it's time to look forward.

## Vapor 5

![Vapor 5](/static/images/posts/Vapor5.png)

Work has [now begun](https://github.com/vapor/vapor/pull/3229) on the next version of Vapor, Vapor 5. Whilst the APIs are very much up for change, we have some high-level goals we want to hit. Our absolute goal is for Vapor to not only be one of the de facto frameworks when building Swift applications, but a de facto choice for building a backend in _any_ language.

The main goals include:

* The same, great, Vapor experience
* Full structured concurrency
* Full up-to-date ecosystem integration
* Provide a foundation for a modern backend
* Rewrite of the WebSocket and the MultipartKit APIs

### The Same Vapor Experience

Vapor has always been known for providing a great developer experience with an API that's easy to work with and _feels_ Swifty. We want to ensure this stays the same and make it even better. This includes APIs that make sense, documentation that is clear and tutorials that are easy to follow, based on our fantastic community.

This is what has made Vapor so popular and that is not going to change. We want to try and build on Swift's ethos of progressive disclosure, so whilst it's easy to get started with Vapor and simple to write a basic API, the hooks to write more complicated and complex applications are there and you're not constrained by the framework.

### Full Structured Concurrency

Vapor 3 introduced the `EventLoopFuture` and whilst it was the right direction to go in and set us up for the next several years, it was a hard learning curve. I remember writing the original Vapor book and trying to understand these new APIs and really struggling at the start! Thankfully `async`/`await` arrived and solved the usability problem. But it was always bolted on to the existing `EventLoopFuture` APIs and not full structured concurrency.

With a new major version, we can change all of that! There will be no APIs in Vapor that return `EventLoopFuture` and we can provide a full structured concurrency experience. This will make it easier to write and reason about your code, provide a way more performant framework and make it safer to work in an async world.

This will start with Swift Service Lifecycle, which Vapor will integrate natively with to make it easy to control all the different services and make them work cohesively together.

### Full Up-to-Date Ecosystem Integration

As well as Swift service lifecycle, there are a number of new libraries we can take advantage of. There's a new HTTP Server we can build on top of, based on Adam's great work from Hummingbird. There's a new Middleware package being worked on that will make it easy for us to share middlewares between different frameworks.

There's also the [new HTTP Types library](https://github.com/apple/swift-http-types) and Swift Argument Parser we can build on. Less stuff for Vapor to maintain and better integration with the rest of the Swift ecosystem - a win-win.

### Provide a Foundation for a Modern Backend

Vapor is used by companies big and small and powers some very large applications. We want to ensure that Vapor not only works well for small, simple APIs but also the most demanding backends. This includes ensuring we have a full observability journey, with logging, metrics and tracing all supported out of the box.

The new HTTP server will allow us to easily provide first class support for gRPC, async body streaming and SSE. OpenAPI will also be a first class system, both from generating documentation from routes and generating routes from an OpenAPI spec.

And of course, with structured concurrency and Sendable, threading issues and data races are a thing of the past. Vapor 5 will provide a highly performant foundation to satisfy the most demanding users.

### Rewrite of the WebSocket and MultipartKit APIs

MultipartKit was split out into a separate package in the early days of Vapor 4 but before Swift Concurrency was a thing. Whilst it works well, we don't currently provide an API for streaming multipart bodies, either parsing requests or streaming responses. Which can make it hard to work with either very large files, or with APIs like `NIOFileSystem`. As part for Vapor 5, we'll be releasing a new version of MultipartKit that will provide a streaming API for multipart bodies.

Websockets in Vapor have always been difficult when working with asynchronous code. That only got harder with Swift Concurrency and currently it does not work well in an async world. So we'll also be providing a new WebsocketKit release with an updated API. With committing to anything, I'd love to be able to do something like:

```swift
for await message in websocket {
    // do something with message
}
```

## Next Steps and Timescales

The journey to Vapor 5 will follow a rough plan:

1. Remove all the old future-based APIs (this is already done)
2. Implement the 'new' service architecture, AKA dependency injection
3. Fix all the tech debt with Sendable, migrate to value type Request and Responses etc
3. Switch out the HTTP server to provide a full async stack
4. Migrate to Swift Service Lifecycle
5. Migrate to Swift Testing
6. Rewrite the WebSocket and MultipartKit APIs
7. Investigate new APIs for routing, validation and any other areas we want to touch

Note that Fluent 5 is a separate thing that Gwynne will discuss in a separate post, but it's likely that FluentKit 4 will work with Vapor 5.

We're aiming to have an initial alpha out when Swift 6 is released. This will focus on providing an async stack and removal of all the `EventLoopFuture` APIs and we can work from there as we implement the above goals and explore some new APIs. You can follow along on GitHub and in the `#vapor-5` channel in Discord.

## Support Timelines

Vapor 4 has been out (and stable) for nearly 4 and a half years now. Hopefully that dispels the myth that Vapor constantly introduces breaking changes! Vapor 4 is now in maintenance mode and will not be receiving any new features unless absolutely needed. PRs are still accepted however and I will endeavour to review them. We will continue to fix bugs and security issues in Vapor 4 for at least 6 months after Vapor 5 is released.

Vapor 5 will get a support period of **at least 3 years**. As with Vapor 4, it could well be longer, but we want to provide some stability to the ecosystem and by setting out a long support period from the outset, we hope it will encourage everyone to migrate, more people to adopt and importantly persuade library authors to update their frameworks.

## Wrapping Up

Vapor 5 is going to be a huge release that will set Vapor up for the years to come in the Swift Concurrency world. We're excited to get started and look forward to discussing the changes in Discord. If you want to live on the bleeding edge, please feel free to try out alphas as they are tagged! Once all the major APIs have been implemented we can start tagging some betas that should be more stable.