---
title: "What's New in Vapor 4"
date: "2019-10-25"
tags: [
    "announcement",
    "framework"
]
author: "Tanner Nelson"
cover: "/img/articles/vapor4-alpha.png"
---

We've been hacking away at the fourth major release of Vapor for almost a year now. The first alpha version was tagged last May with the first beta following in October. During that time, the community has done amazing work helping to test, improve, and refine this release. Over [500 issues and pull requests](https://github.com/orgs/vapor/projects/2) have been closed so far!

If we look at Vapor 3's pre-release timeline, there were 7 months between alpha.1 and the final release. If history repeats itself, that would mean 4.0.0 sometime in February 2020. 

As we near the end of the active development phase, efforts are moving to documentation and polish. Since APIs have mostly settled down at this point, I'd like to take this opportunity to introduce you to some of the exciting changes coming in Vapor 4. Let's dive in.

## New Dependency Injection API

Vapor 3 introduced a pure Swift configuration framework _Services_ that replaced Vapor 2's JSON configuration files. In Vapor 4, we're taking this a step further and leveraging the compiler even more to make configuring Vapor apps as easy as possible.

Vapor 4's new dependency injection APIs are now based on Swift extensions instead of type names. This means services offered by third party packages or Vapor itself will now be more discoverable and feel native in Swift.

This is best explained by examples, so let's take a look at some common use cases of the Services API in Vapor 3 and what they would look like in Vapor 4. 

```swift
// changing the default HTTP server port

// vapor 3
services.register(NIOServerConfig.self) { _ in
	return NIOServerConfig.default(port: 1337)
}

// vapor 4
app.server.configuration.port = 1337
```

```swift
// setting leaf as view render

// vapor 3
services.register(LeafConfig.self) { _ in
	return LeafConfig(...)
}
config.prefer(LeafRenderer.self, for: ViewRenderer.self)

// vapor 4
app.leaf.configuration = .init(...)
app.views.use(.leaf)
```

## NIO 2 

Vapor 4 upgrades to [SwiftNIO](https://github.com/apple/swift-nio) 2.0. This release includes tons of great quality of life improvements, performance enhancements, and awesome features like vendored BoringSSL and pure Swift HTTP/2 implementation.

## SSWG

A huge focus this release was on integrating with the new [Swift Server Working Group](https://swift.org/server/) (SSWG) ecosystem. Vapor joined forces with Apple to help define common standards for things like [Logging](http://github.com/apple/swift-log) and [Metrics](http://github.com/apple/swift-metrics). Vapor 4 has adopted these new standards with open arms. What this means for you is great logging, metrics, and (soon) tracing that works seamlessly across all of your packages. 

Vapor 4's Postgres driver was the first non-Apple package to go through the SSWG's proposal process and become an accepted project. The [SSWG incubation process](https://github.com/swift-server/sswg/blob/master/process/incubation.md) is designed to improve the overall quality and compatibility of the server-side Swift ecosystem. Vapor 4's MySQL driver is in the early stages of proposal with many more packages to come in the future. 

## Async HTTP Client

[async-http-client](https://github.com/swift-server/async-http-client) is a new pure Swift HTTP client built on top of Swift NIO. This package is meant as a more perfomant and lightweight alternative to URLSession, especially on Linux. Vapor 4 has adopted async-http-client, replacing URLSession as the framework's default HTTP client

## New `vapor new`

Vapor 4's toolbox includes an improved `new` command that lets you customize newly generated projects. Instead of having to pick from pre-existing templates on GitHub, the `new` command will now ask you which packages you want to include in your new project. Based on which packages you include, different sample code will be provided. For example, if you select both "fluent" and "jwt", sample code can be included showing how to integrate the packages together.

## New Model API

Fluent 4's model API has been redesigned to take advantage of [property wrappers](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md) in Swift 5.1. Property wrappers give Fluent much more control over how models work internally which has been key to enabling long requested features like eager loading with a concise API. 

When declaring models, fields are now declared using the `@Field` property wrapper. Identifiers use the special `@ID` wrapper. 

```swift
final class Galaxy: Model {
	@ID(key: "id")
	var id: UUID?

	@Field(key: "name")
	var name: String
}
```

Relations are declared with the property wrappers `@Parent`, `@Children`, and `@Siblings`. 


```swift
final class Planet: Model {
	@ID(key: "id")
	var id: UUID?

	@Field(key: "name")
	var name: String

	@Parent(key: "galaxy_id")
	var galaxy: Galaxy
}

final class Galaxy: Model {
	...

	@Children(for: \.$galaxy)
	var planets: [Planet]
}
```

## Eager Loading

Fluent can now preload a model's relations right from the query builder. Model's will automatically include eager-loaded relations when serializing to Codable encoders.

Taking the example from above, a query for `Planet` could eager-load its `Galaxy` parent with the following query:

```swift
let planets = try Planet.query(on: db).with(\.$galaxy).all().wait()
for planet in planets {
	print(planet.galaxy) // Galaxy
}
```

JSON output for this array of planets would look something like:

```json
[
	{
		"id": ..., 
		"name": "Earth",
		"galaxy": {
			"id": ...,
			"name": "Milky Way"
		}
	},
	...
]
```

## Partial Reads & Updates

Property wrappers also make it 

## XCTVapor

## HTTP/2 & TLS

## Synchronous Content

## Graceful Shutdown

## Backpressure

## New Command API

## APNS

## Leaf Syntax

## Streaming Multipart

## Jobs

