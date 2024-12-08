---
date: 2024-12-08 14:00
description: Embracing more parts of the Swift on Server ecosystem as we progress towards Vapor 5
tags: framework, vapor5, ecosystem
image: /static/images/posts/Vapor5.png
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Embracing the Ecosystem

As the march to Vapor 5 continues, we are starting to see what our packages will look like in the modern ecosystem. Part of this involves integrating the many packages that are becoming integral to Swift on the server.

[JWTKit](https://github.com/vapor/jwt-kit) is the prime example of this, with the new major version taking advantage of Swift 6, [Swift Testing](https://github.com/swiftlang/swift-testing), [Benchmark](https://github.com/ordo-one/package-benchmark), and the latest improvements in [Swift Crypto](https://github.com/apple/swift-crypto). JWTKit v5 was an important release that removed a vended copy of BoringSSL to improve build times for everyone building it and was built with Swift Concurrency in mind from the start.

[MultipartKit](https://github.com/vapor/multipart-kit) is the next package to get the same treatment. Part of this involves migrating to Swift Testing to make it easier to write tests (it is much, much nicer!), and writing benchmark tests to ensure we make the package as performant as possible. We're also getting ready for the Swift Concurrency world by removing SwiftNIO as a dependency. This may seem like an odd step, given we're "embracing the ecosystem", but it's not needed. We can take advantage of `AsyncSequence`s to provide a full streaming API, which is helpful for large payloads. 

Using Swift Concurrency means that we don't need `EventLoopFuture`s and we can make the payload type agnostic so they don't require `ByteBuffer`s. The future of Swift on the Server likely involves migrating away from `ByteBuffer`s to `AsyncSequence<ArraySlice<UInt8>>` or similar. However, the performance isn't there yet so we can allow `ByteBuffer`s to be used when desired. Removing NIO as a dependency allows packages like [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator) to integrate MultipartKit, removing duplication across the ecosystem.

Vapor 5 will integrate many of these packages as well. Tests will use Swift Testing, and the new [Vapor Testing module](https://github.com/vapor/vapor/pull/3257) will make it easy for users of Vapor to write their tests using Swift Testing. Benchmarks will allow us to start measuring performance properly so we can objectively improve it. [Swift Argument Parser](https://github.com/apple/swift-argument-parser) is another package that didn't exist when Vapor 4 was released and will remove a lot of duplicated behaviour. 

Swift Service Lifecycle is a fundamental package in the world of Structured Concurrency and another package that Vapor (and our database drivers) will adopt to control the lifecycle of packages. Check out [Franz's awesome talk](https://www.youtube.com/watch?v=JmrnE7HUaDE) from the ServerSide.swift conference that explains why it's important and how it can be used. Then we also have the Swift Middleware and HTTP Server libraries that are currently under development to again remove duplication and make it easier to share code across the ecosystem.

All of these will put Vapor 5 in good stead to work with the ecosystem and provide a mature foundation to grow and evolve from.