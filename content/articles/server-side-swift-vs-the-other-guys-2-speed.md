---
title: "Server Side Swift vs. The Other Guys — 2: Speed"
date: "2016-06-13"
tags: [
    "benchmark",
    "framework"
]
author: "Tanner Nelson"
---

After the last article about reading and responding JSON, it was clear that people wanted to see the frameworks benchmarked. So we gathered some really smart guys — web development professionals from around the world — and worked together on a Digital Ocean droplet to test and benchmark the top web frameworks.

## Frameworks

* Vapor (Swift)
* Ruby on Rails (Ruby)
* Laravel (PHP)
* Lumen (PHP)
* Express (JavaScript)
* Django (Python)
* Flask (Python)
* Spring (Java)
* Nancy (C#)
* Go (Pure Go, no framework)

## Test

* Plaintext
* JSON
* Random SQLite Fetch

## Benchmark

The following wrk commands were run 3 times per framework on a separate Digital Ocean droplet in the same zone.

{{< highlight json >}}
wrk -d 10 -t 4 -c 128 http://<host>:<port>/plaintext
wrk -d 10 -t 4 -c 128 http://<host>:<port>/json
wrk -d 10 -t 4 -c 128 http://<host>:<port>/sqlite-fetch
{{< /highlight >}}

## The Results

Vapor and Express are the fastest frameworks out there, competing with (and even sometimes surpassing) pure Go.

### Plaintext

The plaintext test is the simplest and its results show the maximum possible speed of each framework.

Vapor surprised us with how close it got to Go. The pure Swift HTTP server Vapor uses is thread based where as Go uses coroutines. Coroutines can be a lot faster, but require additional libraries and setup. It’s possible Vapor could adopt this type of parallelism in the future. (Read more about threads vs. coroutines in the code section).

Additionally, Swift on Linux is still beta and compiles with unoptimized toolchains. As the compiler nears production in the coming months, Swift has the possiblility to dethrone Go.

![Results](/img/articles/vs-the-other-guys2-results.png)

### JSON

Express gets the obvious advantage being written in JavaScript (JSON stands for JavaScript Object Notation in case anyone doesn’t know). Vapor falls into third place due to it’s nascent JSON parsing on Linux (Apple is still working on the official one). Still, Swift proves to be at least 3x if not 10x faster than the rest of the frameworks tested.

![JSON](/img/articles/vs-the-other-guys2-results2.png)

### SQLite Fetch

Express came in with a surprising lead, and Go dropped to a surprising fourth place. Even more surprising is that Vapor came in second being the only framework besides Spring to use an ORM (Vapor includes Fluent by default).

{{< highlight swift >}}
// Fluent ORM
let user = try User.random()
// No ORM
let row = DB.raw("SELECT * FROM users ORDER BY random() LIMIT 1")
{{< /highlight >}}

The SQLite Fetch test is arguably the best test to look to when examining a framework since it shows how it performs doing real world tasks. As Vapor’s dependencies such as the Fluent-SQLite library mature, it will surely see improvements in this type of test.

![SQLite](/img/articles/vs-the-other-guys2-results3.png)

## Code

This section shows the code and configuration used to run each framework.

### Vapor

Vapor ran using the built in POSIX-thread based HTTP server. It was compiled using Swift’s 06–06 toolchain with release configuration and optimizations.

{{< highlight json >}}
vapor run --release --port=8000
{{< /highlight >}}

The Vapor CLI made creating and running the application easy. All of the code required to pass the test follows.

Setting up the database was easy using Fluent. And Swift’s do/try syntax ensures the application won’t crash or produce a 500, even if the database isn’t where we think it should be.

#### Speed

Vapor’s speed comes from the fact that it is both compiled and has modern syntax and language features. Swift can reach C performance if worked correctly, and advancments like Array Slices make it easy and readable to make incredibly performant and optimized applications.


#### Thread vs. Coroutines

Threads require interacting with the kernel when accepting requests, which makes them much slower than Go-style coroutines. This is because the operating system manages creating and scheduling threads.

Though they are slower, they are arguably easier to use since the same application can run on different server setups without knowing the number of cores before hand. They also don’t require any external libraries or C dependencies, as almost all operating systems have full POSIX compliance out of the box.

### Ruby

Rails was run using the supplied server in production mode. The database and routes were configured in separate files.

{{< highlight json >}}
bin/rails s — binding=107.170.131.198 -p 8600 -e production
{{< /highlight >}}

### Nancy

Nancy is an open source and lightweight .Net framework. It focuses on easy testing, extensability, and staying out of your way. With over 250 contributors and a vibrant community it shows how awesome C# on the web can be.

The code was concise and and it was very fast.

### Laravel

Laravel were served using Nginx and PHP 5.

### Lumen

Lumen was served similarly to Laravel.

### Express

Express ran clustered using NPM with cluster.

{{< highlight json >}}
npm run cluster
{{< /highlight >}}

The entire app resided in one file.

#### Speed

Express gets its speed from being so lightweight and relying on highly performant C dependencies. Even though you write in JavaScript, the requests are parsed using Node’s C libraries.

### Django

Django was served using the wsgi and gunicorn running 4 workers.

### Flask

Flask was served the same as Django.

### Go

Go’s built in web server, router, and entire application fit in one file.

### Spring

Java barely made it in to the results (10pm last night). It tooks a long time to set up and get everything installed on the Droplet. And it kept destroying the SQLite database. 😆

{{< highlight json >}}
[10:54]
it took ​_a hundred and seventy-seven seconds_​ but it finally nuked the rows out of `users` and started itself up
[10:54]
:alien_guy: Java
{{< /highlight >}}

Edit: This doesn’t mean Spring is bad, we like Spring. :)

Java was run using Spring Boot on the Java Virtual Machine, one of the fastest and most battle-tested VMs out there.

The full Java code can be seen here: <a href="https://github.com/hlprmnky/vapor-spring-benchmark" target="_BLANK">https://github.com/hlprmnky/vapor-spring-benchmark</a>

## Contributors

* Shaun Harrison (<a href="https://github.com/shnhrrsn" target="_BLANK">https://github.com/shnhrrsn</a>)
* Paul Wilson (<a href="https://github.com/paulatwilson" taget="_BLANK">https://github.com/paulatwilson</a>)
* Willie Abrams (<a href="https://github.com/willie" taget="_BLANK">https://github.com/willie</a>)
* Jonathan Channon (<a href="https://github.com/jchannon" target="_BLANK">https://github.com/jchannon</a>)
* Chris Johnson (<a href="https://github.com/hlprmnky" target="_BLANK">https://github.com/hlprmnky</a>)
* Sven Schmidt (<a href="https://github.com/feinstruktur" target="_BLANK">https://github.com/feinstruktur</a>)