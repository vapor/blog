---
title: "Vapor 3.0.0 released"
date: "2018-05-05"
tags: [
    "announcement",
    "framework"
]
author: "Tanner Nelson"
cover: "/img/articles/vapor3-released.png"
---

Vapor 3 is officially here! We have been working hard on this release for more than six months now and we are incredibly excited to release it into the world.

See the GitHub release here: https://github.com/vapor/vapor/releases/tag/3.0.0

As you probably know by now, 3.0 is a complete rewrite of Vapor and all of its related packages. It’s a big change. The growth of Vapor and server-side Swift over these past two years has been astonishing and we want to make sure we have a rock-solid foundation to build on for years to come. This has been our main focus this release and has lead to three important new features:

* **Async:** Vapor is now completely non-blocking and runs on Apple’s SwiftNIO. This means Vapor 3 is ready to handle high levels of concurrency when your application needs it.
* **Services:** Gone are the JSON configuration files. Everything is Swift now thanks to Vapor’s new Dependency Injection framework Services.
* **Codable:** Parsing and serializing content from HTTP messages, creating database models, and rendering views is now more type safe and performant thanks to Codable integration throughout all of Vapor.

While those are the three biggest improvements, there are countless others. If you have used Vapor previously or you are just getting introduced, we recommend reading our new Getting Started guide.

## Documentation

A huge focus during this release has been put on documentation. This is the main reason 3.0’s release process has been so much slower than previous releases. Writing documentation is incredibly time consuming and frankly exhausting, but we think it is critical for Vapor 3’s success going forward.

## API Docs

Vapor’s API docs are updated and better than ever. Every package has 100% docblock coverage including:

* Helpful code samples where possible.
* Method parameter descriptions.
* `MARK` and code re-org to help make things readable in API doc form.

The API docs are available at https://api.vapor.codes. Use the selector to choose which repo, module, and version you would like to view docs for.

## Guide Docs

With the improvement of Vapor’s API documentation, the main docs are moving more toward a guide / tutorial feel. In contrast to the API docs which heavily focus on particular methods and protocols, we want the guide docs to cover broad use cases and practices. For example, “saving your first model”, or “making an external API request”.

The Guide docs are available at https://docs.vapor.codes/3.0/ and there is a section for each of Vapor’s modules.

## Discord

As part of Vapor 3’s release, we are officially moving Vapor’s team chat to Discord. You can join using this link: http://discord.gg/BnXmVGA

For more information about why we are making this move, see this post to #announcements.

![image](/img/articles/vapor3-released2.png)

## Books

We are incredibly excited to announce two books written for Vapor 3! This is a first for Vapor so make sure to show your support ❤️.

![image](/img/articles/vapor3-released3.png)

* <a href="https://store.raywenderlich.com/products/server-side-swift-with-vapor" target="BLANK">Server Side Swift with Vapor — RayWenderlich.com</a>
* <a href="https://www.hackingwithswift.com/store/server-side-swift" target="_BLANK">Server-side Swift (Vapor Edition)–HackingWithSwift.com</a>

## Benchmarks

As always, we want to include some benchmarks with the release article. The source code for these benchmarks is available on GitHub at vapor/benchmarks.

> If you find any errors in the configuration of one of the frameworks or how the benchmark was run, please notify us at benchmarks@vapor.codes we will update this article!

The benchmarks were run on two identical Digital Ocean droplets. One for hosting the frameworks and one for running the benchmark.

![image](/img/articles/vapor3-released4.png)

The following command was used to run the benchmarks.

{{< highlight json >}}
docker run -it witf .build/release/benchmarker wrk -t 8 -c 256 -d 10 -r 6 10.132.38.80
{{< /highlight >}}

The `benchmarker` program is a small script written in Swift that runs wrk and captures the results. It is capable of doing multiple runs and averaging the results.

In human terms, the above benchmark means:

> Run a 10 second test 6 times in a row using 8 threads and 256 connections.

The rules of the test (forked from tbrand/which_is_the_fastest) are simple:

> Respond `200 OK` to `GET /` with an empty body. A `Date` header must be included.

The benchmarker ensures these rules are met or the test fails.

## Results

The first graph shows the raw throughput in requests per second for each framework. The higher the better.

![image](/img/articles/vapor3-released5.png)

The second graph shows the average latency during the benchmark. The lower the better.

![image](/img/articles/vapor3-released6.png)

Here are the actual results as printed by the benchmarker.

{{< highlight json >}}
total requests:
#1 vapor (swift): 1202666 reqs
#2 perfect (swift): 1192318 reqs
#3 gin (go): 1008221 reqs
#4 kitura (swift): 641111 reqs
#5 express (node.js): 268176 reqs
#6 sinatra (ruby): 206693 reqs
#7 phoenix (elixir): 151975 reqs
#8 flask (python): 66672 reqs
#9 rails (ruby): 51524 reqs
#10 django (python): 47050 reqs
average latency:
#1 vapor (swift): 2420µs
#2 perfect (swift): 2596µs
#3 gin (go): 2936µs
#4 kitura (swift): 4631µs
#5 sinatra (ruby): 6220µs
#6 express (node.js): 9490µs
#7 phoenix (elixir): 17941µs
#8 rails (ruby): 22664µs
#9 flask (python): 24109µs
#10 django (python): 49053µs
{{< /highlight >}}

We were pleasently surprised to see Vapor coming in first as being asynchronous does not really help with plaintext benchmarks. Plaintext benchmarks are really only good at testing how fast a web framework is capable of parsing and serializing HTTP headers. However, it is a good indication of the performance of Swift.

We will be releasing benchmarks that deal with more realistic server-side workloads such as CRUD operations on a database and view rendering when the related packages (Fluent and Leaf) are officially released.

## Packages

Vapor 3 offers a couple of new packages this release. Most notably are the MySQL and PostgreSQL packages which are now non-blocking and built on SwiftNIO.

Here is a list of all Vapor 3 compatible packages and latest version at time of writing. (Last updated August 17th, 2018).

* **Core:** Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging. (3.1.6)
* **Service:** Dependency injection / inversion of control framework. (1.0.0)
* **Multipart:** Parses and serializes multipart-encoded data with Codable support. (3.0.1)
* **URLEncodedForm:** Parse and serialize url-encoded form data with Codable support. (1.0.0)
* **Routing:** High-performance trie-node router. (3.0.1)
* **DatabaseKit:** Core services for creating database integrations. (1.0.1)
* **SQL:** Build SQL queries in Swift. Extensible, protocol-based design that supports DQL, DML, and DDL. (1.0.0)
* **HTTP:** Non-blocking, event-driven HTTP built on Swift NIO. (3.0.5)
* **Console:** APIs for creating interactive CLI tools. (3.0.1)
* **Crypto:** Hashing (BCrypt, SHA2, HMAC), encryption (AES), public-key (RSA), and random data generation. (3.1.0)
* **Validation:** Extensible data validation library (name, email, etc) (2.0.0)
* **TemplateKit:** Easy-to-use foundation for building powerful templating languages in Swift. (1.0.0)
* **WebSocket:** Non-blocking, event-driven WebSocket client and server built on Swift NIO. (1.0.1)
* **Vapor:** A server-side Swift web framework. (3.0.0)
* **Redis:** Non-blocking, event-driven Redis client. (3.0.0)
* **SQLite:** SQLite 3 wrapper for Swift. (3.0.0)
* **PostgreSQL:** Non-blocking, event-driven Swift client for PostgreSQL. (1.0.0)
* **MySQL:** Pure Swift MySQL client built on non-blocking, event-driven sockets. (3.0.0)
* **Fluent:** Swift ORM framework (queries, models, and relations) for building NoSQL and SQL database integrations. (3.0.0)
* **FluentSQLite:** Swift ORM (queries, models, relations, etc) built on SQLite 3. (3.0.0)
* **FluentPostgreSQL:** Swift ORM (queries, models, relations, etc) built on PostgreSQL. (1.0.0)
* **Auth:** Authentication and Authorization layer for Fluent. (2.0.0)
* **JWT:** JSON Web Token signing and verification. (3.0.0)
* **Leaf:** An expressive, performant, and extensible templating language built for Swift. (3.0.0)

Packages will continue to roll out over the next weeks. Keep an eye on our Twitter @codevapor for details.

## Website

Be sure to check out our updated website at http://vapor.codes.

![image](/img/articles/vapor3-released7.png)

## More Information

For more information check out these related interviews / posts:

* <a href="https://www.hackingwithswift.com/articles/68/interview-tanner-nelson" target="_BLANK">@tanner0101’s interview–Hacking with Swift</a>
* <a href="https://www.swiftbysundell.com/podcast/18" target="_BLANK">“It’s like The Matrix”, with special guest Tanner Nelson — Swift By Sundell</a>
* <a href="https://geeks.brokenhands.io/blog/posts/whats-new-in-vapor-3/" target="_BLANK">What’s new in Vapor 3–Broken Hands</a>

## Thank you

Finally, we want to say **thank you** to all of the contributors and developers that helped us create and test Vapor 3. It would not have been possible without you. ❤️

