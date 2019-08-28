---
title: "Seeking help benchmarking frameworks"
date: "2016-06-02"
tags: [
    "benchmark",
    "framework"
]
author: "Tanner Nelson"
---

We’re looking for professionals in the following web frameworks to help us write our next Server Side Swift vs The Other Guys article which will cover benchmarking.

### Information on how to help is at the bottom.

* [x] Vapor (Swift)
* [ ] Ruby on Rails (Ruby)
* [x] Laravel (PHP)
* [x] Express (JavaScript)
* [ ] Django (Python)
* [x] Spring (Java)

Frameworks with an “x” mean we already have at least one professional. But feel free to apply still. The more tests the better.

### Setup

Each framework will be installed in a directory on the same cloud server (Digital Ocean):

* 8GB Memory
* 4 Core Processor

SSH Credentials will be provided

### Tests

Each framework will need to fulfill the following three tests.

### Plain Text

{{< highlight json >}}
HTTP/1.1 200 OK
Hello, World!
{{< /highlight >}}

### JSON

{{< highlight json >}}
HTTP/1.1 200 OK
{
    "array": [1, 2, 3]
    "dict": {"one": 1, "two": 2, "three": 3}
    "int": 42,
    "string": "test",
    "double": 3.14,
    "null": null
}
{{< /highlight >}}

### SQLite fetch

{{< highlight json >}}
HTTP/1.1 200 OK
{
    "id": 1,
    "name": "Test User",
    "email": "test@gmail.com"
}
{{< /highlight >}}

### Benchmark

This is the preliminary benchmark and is subject to change if someone knows a better method to test with.

{{< highlight json >}}
wrk -d 10 -t 4 -c 128 http://<host>:<port>/plaintext
wrk -d 10 -t 4 -c 128 http://<host>:<port>/json
wrk -d 10 -t 4 -c 128 http://<host>:<port>/sqlite-fetch
{{< /highlight >}}

* 10 runs for each route
* Average the 10 runs

### Apply

Email <tanner@qutheory.io> with the subject “Benchmarking Help” to get instructions on how to help.
