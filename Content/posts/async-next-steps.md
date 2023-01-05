---
date: 2022-08-16 18:00
description: The next steps for embracing async/await in Vapor
tags: vapor, framework
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Vapor's Next Steps with `async`/`await`

A while ago, we [updated Vapor's supported Swift versions](/posts/vapor-swift-versions-update/). The time has come to update it again and take a look at the next steps for Vapor and it's support for Swift's Concurrency model.

With Swift 6, and therefore Vapor 5, looking a while away yet, we're taking the opportunity to make some changes to Vapor with the following goals:

* Allow user's to back-deploy async/await to older OSes
* Ensure that we're safe in an async/await world.
* Allow easier adoption of Sendable in Vapor

The TL;DR of the upcoming changes is that we're going to start requiring Swift 5.6 as the minimum supported Swift version and heavily push developers to use the async APIs.

## Back-deploying async/await

Although not too common, we have had several requests to allow Vapor's async/await support to be backported to older OSes. A common use case is macOS and iOS apps embedding Vapor servers and wanting to run on older OSes. Currently all Vapor's Concurrency supported is gated behind macOS 12, iOS 15, watchOS 8 and tvOS 15. This was to match NIO until backporting was possible.

However, backporting is not as simple as just lowering the availability checks. The reason is that not all versions of Xcode and Swift 5.5 shipped with a concurrency runtime. When Xcode 13.0 and 13.1 were introduced, they did not ship a Concurrency runtime. In order for us to support anyone running those versions of Xcode, we'd need to duplicate _all_ of our `async` APIs and then ensure they all worked. This isn't feasible from a maintenance point of view. Jumping to 5.6 as the minimum supported Swift version means we can guarantee that anyone compiling will have access to a Concurrency runtime and we can remove all our checks and make it possible to backdeploy.

## Ensuring we're safe in an async/await world

For the most part, anyone using Vapor can start porting their route handlers and code over to use `async`/`await` without any issue. The code is much more readable and maintainable and there's no learning curve for `EventLoopFuture`s 🎉. It's a far better experience.

However there are some edge cases that can blow up on you. Anyone trying to run concurrent code in parallel (such as using `TaskGroup`s or `async let`) means that their route handlers are now running across multiple async contexts and potentially reading and writing from multiple contexts and/or threads. Vapor's assumption in the `EventLoopFuture` world was that everything in an event hander was run on the same `EventLoop` and therefore on the same thread. We could optimise our code for this case and not have to worry about thread safety. However, now in a Swift Concurrency world, it's something we need to be aware of. For most people it's not an issue, but having a ticking timebomb under you is not a good place to be!

So in a future release we're going to be deprecating things like Vapor's `Storage` type and migrating to actor-based async versions. This ensures that no matter which thread, `Task` or context you try and read and write data from and to, it will be safe.

This is a far reaching change, and in order to ensure that anyone using Vapor is using the safe versions, we're going to be deprecating all of the old unsafe versions. This means that you'll need to migrate to the `async` versions and start writing `async` code if you're not already. This is the strongest push from Vapor to get users onto async/await so far and we think it's totally justified.

## Adopting `Sendable`

Tied nicely into making everything safer, we're going to start adopting `Sendable` throughout Vapor where we can. `Sendable` is a protocol applied to types to get the compiler to check memory access. This moves any data races from runtime to compile time!

Setting Swift 5.6 as our minimum supported Swift version makes adopting `Sendable` practical. Before 5.6 we'd need a lot of code gated behind Swift versions, which turns into a maintenance nightmare for a codebase like ours. So this makes your code safer, and our lives easier!

## Schedule

You can see the [initial PR on GitHub](https://github.com/vapor/vapor/pull/2873) where most of the work will be done. We may break it up into multiple PRs, but it won't be released until Swift 5.7 is released. This means Vapor will support Swift 5.6 and Swift 5.7, which should be a good tradeoff between support and maintainability. 
