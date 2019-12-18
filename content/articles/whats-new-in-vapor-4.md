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

We've been working on the fourth major release of Vapor for almost a year now. The first alpha version was tagged last May with the first beta following in October. During that time, the community has done amazing work helping to test, improve, and refine this release. Over [500 issues and pull requests](https://github.com/orgs/vapor/projects/2) have been closed so far!

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

Fluent's new model API also makes it possible to do partial reads and updates on the database. When models fetched from the DB are updated and saved, Fluent now sends only the updated field values to the database.

## XCTVapor

Vapor 4 includes a new testing framework that makes it easier to test your application using `XCTest`. Importing `XCTVapor` adds `test` methods to your application that you can use to easily send requests.

```swift
import XCTVapor

app.test(.GET, to: "hello") { res in
    XCTAssertEqual(res.status, .ok)
    XCTAssertEqual(res.body.string, "Hello, world!")
}
```

Applications are tested in-memory by default. To boot an HTTP server and run the tests through an HTTP client, use `testable`.

```swift
app.testable(method: .running).test(.GET, to: ...) {
	// verify response
}
```

## HTTP/2 & TLS

Support for HTTP/2 and TLS is now shipped by default with Vapor 4. HTTP/2 support can be enabled by adding `.two` to the HTTP server's supported version set.

```swift
app.server.configuration.supportVersions = [.two]
```

TLS can be enabled by setting the server's TLS configuration struct.

```swift
app.server.configuration.tlsConfiguration = .forServer(...)
```

Hosting your app behind a reverse-proxy like NGINX is still recommended for production use cases. 

## Synchronous Content

Vapor's Content APIs are now synchronous.

```swift
let newUser = try req.content.decode(CreateUser.self)
print(newUser) // CreateUser
```

This is thanks to a new default policy on route handlers to collect streaming HTTP bodies before calling the handler. HTTP body collection can be disabled when registering routes.

```swift
app.on(.POST, "streaming", body: .stream) { req in
    // req.body.data may be nil
    // use req.body.collect
}
```

## Backpressure

In addition to new request body collection strategies, request body streaming now supports back pressure. `req.body.drain`, which streams incoming body data, nwow accepts a `EventLoopFuture` return value. Until this future result is completed, further request body chunks will not be requested from the operating system. 

This allows for Vapor apps to stream extremely large files directly to disk without ballooning memory. 

Vapor's multipart parsing package `MultipartKit` has been rewritten to support streaming `multipart/form-data` uploads. This means you can benefit from backpressure with both direct and form-based file uploads. 

## Graceful Shutdown

Close attention to graceful shutdown has been given to all Vapor types that deal with long-lived resources. `Application`, and many other types, have `close()` or `shutdown()` methods that now must be called before they deinitialize. 

```swift
let app = Application()
defer { app.shutdown() }
```

Using explicit shutdown methods is a pattern adopted from SwiftNIO and can help reduce bugs. These shutdown methods also help to prevent reference cycles from leaking memory in your application.

Beyond stricter adherence to good graceful shutdown practices, Vapor's HTTP server now supports NIO's `ServerQuiescingHelper` by default. This handler helps to ensure that any in-flight HTTP requests are given time to complete after a server initiates shutdown. 

## New Command API

Vapor's Command APIs have also seen improvements thanks to property wrappers. Commands now define `Signature` structs that use wrapped properties to declare accepted arguments. When the command is run, the signature is decoded automatically and passed to the run function.

Available property wrappers are `@Argument`, `@Option`, and `@Flag`. 

```swift
final class ServeCommand: Command {
    struct Signature: CommandSignature {
        @Option(name: "hostname", short: "H", help: "Set the hostname")
        var hostname: String?
        
        @Option(name: "port", short: "p", help: "Set the port")
        var port: Int?
        
        @Option(name: "bind", short: "b", help: "Set hostname and port together")
        var bind: String?
    }

    func run(using context: CommandContext, signature: Signature) throws {
    	print(signature.hostname) // String?
    }
}
````

## APNS

A new [APNS](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html) integration package will ship its first release alongside Vapor 4. This package is built on the great work done by Kyle Browning with [APNSwift](https://github.com/kylebrowning/APNSwift).

This package integrates APNSwift into Vapor's application and request types, making it easy to configure and use. 

```swift
import APNS
import Vapor

try app.apns.configuration = .init(
    keyIdentifier: "...",
    teamIdentifier: "...",
    signer: .init(file: ...),
    topic: "codes.vapor.example",
    environment: .sandbox
)

app.get("send-push") { req -> EventLoopFuture<HTTPStatus> in
    req.apns.send(
        .init(title: "Hello", subtitle: "This is a test from vapor/apns"),
        to: "..."
    ).map { .ok }
}
```

The new package is located at [vapor/apns](https://github.com/vapor/apns).

## Leaf Syntax

As first [described](https://forums.swift.org/t/pitch-new-leaf-body-syntax/18188) on the Swift forums, Leaf's new body syntax is complete and will ship with Vapor 4.

This change replaces Leaf's usage of curly braces with an `#end` prefix syntax.

```leaf
#for(user in users)
   Hello #(user.name)!
#endfor
```

Leaf also has a new syntax for template inheritance. 

base.leaf:
```html
<html>
    <head><title>#import("title")</title><head>
    <body>#import("body")</body>
</html>
```

hello.leaf:
```leaf
#extend("base"):
    #export("title", "Welcome")
    #export("body"):
        Hello, #(name)!
    #endexport
#endextend
```

result when compiled with context `["name": "Vapor"]`

```html
<html>
    <head><title>Welcome</title><head>
    <body>Hello, Vapor!</body>
</html>
```

## Jobs

Jobs, a queue system for Vapor, will be seeing its 1.0 release alongside Vapor 4. This package allows you to define job handlers that can handle long-running tasks in a separate process. Your Vapor route handlers can quickly dispatch jobs to these handlers to keep your application fast without compromising error handling.

Job handlers are declared using the `Job` protocol and must implement a `dequeue` method.

```swift
struct Email: Codable {
    var to: String
    var message: String
}

struct EmailJob: Job {
    func dequeue(_ context: JobContext, _ email: Email) -> EventLoopFuture<Void> {
    	print("sending email to \(email.to)")
    	...
    }
}
```

Job handlers are then configure using Jobs' convenience APIs.

```swift
import Jobs
import Vapor

app.jobs.add(EmailJob())
```

When booting your app, start up the jobs handling process using the new `jobs` command.

```sh
swift run Run jobs
```

Once setup, you can easily dispatch jobs from route handlers using the request.

```swift
app.get("send-email") { req in
    req.jobs.dispatch(EmailJob.self, Email(...))
        .map { HTTPStatus.ok }
}
```

Once dispatched, the job will be later dequeued and run in the separate jobs process. If any errors occur, the `EmailJob` handler will be notified. 

Jobs also supports scheduling jobs to run at certain times using a new, fluent schedule building API. 

```swift
// weekly
app.jobs.schedule(Cleanup())
    .weekly()
    .on(.monday)
    .at("3:13am")

// daily
app.jobs.schedule(Cleanup())
    .daily()
    .at("5:23pm")

// hourly
app.jobs.schedule(Cleanup())
    .hourly()
    .at(30)
```