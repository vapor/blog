---
date: 2026-09-17 19:00
description: Now that the Vapor 5 beta is here, let's take a look and see what has actually changed!
tags: vapor, 10 years, framework
author: 0xTim
---
# What's New in Vapor 5 Beta

Now that we've [released the Vapor 5 beta](https://blog.vapor.codes/posts/vapor-5-beta/), it's time to look at what has actually changed! In this post, we'll discuss how Vapor 5 works, the changes we made and what your new code will look like.

> This post is part of a series of posts for Vapor Week. See the [main blog post](https://blog.vapor.codes/posts/ten-years-of-vapor/) for more information.

## How Vapor 5 Looks

Here is a simple route in Vapor 5:

```swift
app.get("hello") { req in
    "Hello, world!"
}
```

Look familiar? In fact it's the same as Vapor 4! What about dealing with JSON via `Content`:

```swift
app.post("user") { req in
    let userData = try await req.content.decode(UserData.self)
    return UserMessage(message: "Hello \(userData.name), you are \(userData.age)")
}
```

Again, very familiar! You may notice the added `await` on the `decode` call - since Vapor 5 is now streaming by default, nothing collects the body if it's not needed, so the call is `async`.

Finally let's take a look at using Fluent:

```swift
// dbPool is a `Databases` type defined at application configuration

app.get("todos") { req in
    let todos = try await Todo.query(on: dbPool.database).all()
    return todos
}
```

This is probably the biggest difference that most people will notice. The reasons are explained in the next section, but it should hopefully be a small change for most people, and easy to automate.

> Note: The API for Fluent is still in flux so the exact naming may change

## Differences That You May Notice

The simple stuff looks pretty similar. And indeed, if you've migrated fully to async/await APIs, it _should_ be a smooth migration process. But some things have changed.

### Goodbye Locks

Vapor 4's work to adopt `Sendable` was a huge success - we went from a monthly GitHub issue reporting a data race that was hard to diagnose to **zero** reports of data race crashes! This was an incredible achievement. However to actually make it safe we had to introduce locks _everywhere_, which hampered any performance optimisations. Now, with an API we can break (`Application` has changed a bit, `Request` and `Response` are both structs, some properties are now immutable), we can finally remove them! I think I removed over 50 locks from the codebase and only required a few `Mutex` additions in the places where we truly need some kind of mutable type.

### No More `Storage`

This is probably one of the big ones, but unless you write packages for Vapor, you're unlikely to notice. You will however notice the service changes, which we'll discuss next.

In Vapor 3 and Vapor 4, the model was that everything related to a `Request` was tied to that request's `EventLoop`. This gave you some semblance of safety - since, in essence, everything was tied to a single thread - and also a good performance boost, since there was no thread hopping when dealing with requests. This did, however, force the introduction of `Storage` so we could store factories and cache types that were tied to the right event loop. With Swift Concurrency, this model goes out the window and you're reliant on the task pool to decide where your code is run (custom executors aside). This frees up the requirement of needing the logger, the client, the database all to be tied to the same event loop and means we can remove `Storage`.

### Real Service Dependency Injection

Because we no longer need to ensure services use the same event loop as the `Application` and `Request`, services have changed significantly and this will be the change that will affect you the most. Gone are the extensions and computed properties, in favour of simple dependency injection. Vapor's `Application` offers some types, like the `ViewRenderer` and `Client` that are created at initialisation, but if you need the `Databases` (essentially the database connection pool), then you just pass it in! I'm a big fan of clear, direct DI like this as it makes it explicitly clear which of your types, like your controllers, need what dependency, like a client or database, and it's easy to test with protocols. If you prefer your own favourite DI framework then nothing should stop you from using these to pass the types to your controllers and services.

### Streaming

You no longer need to specify the body collection method when declaring routes since all routes are streaming by default. If you use any of the helpers to collect the body (like `.collect()` or functions that build on top like `content.decode()`) then this will use the `maxBodySize` parameter. Otherwise if you invoke the streaming API yourself, you're in control of how much to collect (since for most use cases where this is required you'll handle each chunk individually). You can read a request body simply with:

```swift
app.post("upload") { req -> UploadResult in
    var bytesReceived = 0

    try await req.body.forEachChunk { chunk in
        bytesReceived += chunk.count
        // Process or persist the chunk here before asking for the next one.
    }

    return UploadResult(bytesReceived: bytesReceived)
}
```

Each chunk in this case is `Span<UInt8>`. Because we specify the lifetime, the compiler prevents you from escaping it. Reading the body also supports backpressure automatically for you.

Response bodies receive a writer to write to:

```swift
app.get("events") { req in
    Response(
        headers: [.contentType: "text/event-stream"],
        body: .init(stream: { writer in
            for count in 1...5 {
                try await writer.write("data: \(count)\n\n")
                try await Task.sleep(for: .seconds(1))
            }
        })
    )
}
```

Again, this supports backpressure (through the `await` in the write call) automatically and we use Swift's lifetime guarantees to ensure the writer is never escaped.

### Macros

We've introduced an experimental `VaporMacros` product you can add as a dependency that gives you access to be able to define routes and controllers with macros:

```swift
@Controller
struct UserController {
    @GET("users")
    func index(req: Request) async throws -> [User] {
        // Fetch the users from your repository.
    }

    @GET("users", UUID.self)
    func show(req: Request, id: UUID) async throws -> User {
        // `id` has already been extracted and decoded for us.
        User(id: id, name: "Vapor")
    }

    @POST("users")
    func create(req: Request) async throws -> User {
        let input = try await req.content.decode(CreateUser.self)
        return User(id: UUID(), name: input.name)
    }
}
```

What's really cool with this is that it gives us type-safe routing! So if you define a route with `@GET("users", UUID.self)` you must attach it to a function with a parameter that's a UUID. If you use the wrong type, or forget to specify the `id` parameter, you'll get a compiler error. This should make a big difference to those, like me, who were never a fan of defining strings for all their routes.

We also have macros for authentication:

```swift
@GET("account", "me")
@AuthMiddleware(User.self, TokenAuthMiddleware())
func me(req: Request, user: User) async throws -> User {
    // You have a guaranteed user here!
} 
```

Again, you'll get compiler errors if your route handler is not defined correctly and you will have a type checked user model here. If you only want to see if a user is there, make the parameter optional and it will change from throwing a **401 Unauthorized** if the user doesn't exist, to letting it pass through! This macro is something I'm especially excited by!

Note that this is still very much in active development. We have a prototype for defining middleware and currently are fighting the compiler when it comes to being able to pass dependencies into middleware so keep an eye out on the releases for improvements to this.

### Partial Route Parameters

One new feature our router supports that's quite niche but super important to those that need it (like package registries!) is partial route parameters! So this now works:

```swift
app.get("files", ":{file}.json") { req -> String in
    let file = try req.parameters.require("file")
    return "Requested JSON file: \(file)"
}
```

This should remove a lot of string matching and custom code to make this work.

### Deeper Ecosystem Integration

Finally, as with every major release, we can take full advantage of the expanded ecosystem and integrate better with it. For example, ConsoleKit now just offers a high-performance `LogHandler`. All the command work is handed off to Swift Argument Parser. Speaking of logging, we now use `Logger.current` everywhere, which makes it much simpler when needing to access a logger anywhere in your services or routes. And because we now support this, any log invocation from inside a request will automatically have the request ID attached in the metadata.

We now use Swift Configuration for setting up your server, meaning you can use whatever configuration format you like, YAML files, .env files, environment variables, command line arguments, and we'll pick it up if you specify the provider. All of the types we expose for requests and responses now come from Swift HTTP Types, no more needing to convert back and forth with NIO types!

Finally we provide integrations with Swift Service Lifecycle. First, if you have other `Service`s you want your Vapor app to handle, you can pass it to your app and Vapor will start it when the application starts and stop it when the application shuts down, with one simple command:

```swift
app.addService(MyWorker())
```

If you are managing multiple services yourself and want to just drop your Vapor application into the group, `Application` conforms to `Service` allowing you to do just that:

```swift
let app = try await Application()

let services = ServiceGroup(
    configuration: .init(
        services: [
            .init(
                service: app,
                successTerminationBehavior: .gracefullyShutdownGroup
            ),
            .init(
                service: MyWorker(),
                successTerminationBehavior: .gracefullyShutdownGroup
            ),
        ],
        gracefulShutdownSignals: [.sigterm, .sigint],
        logger: Logger.current
    )
)
try await services.run()
```

## A Better Vapor

All of these changes add up to a Vapor release that's nicer to use, more performant, integrates better with the ecosystem and allows you to write better, safer applications! We can't wait to see what you build!