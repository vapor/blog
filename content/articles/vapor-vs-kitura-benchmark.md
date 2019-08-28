---
title: "Vapor vs. Kitura Benchmark"
date: "2016-08-04"
tags: [
    "Benchmark",
    "Vapor"
]
author: "Tanner Nelson"
cover: "/img/articles/vapor-vs-kitura.png"
---

A recent Swift London talk by Chris Bailey from the IBM-Swift team showed an interesting benchmark graph for server-side Swift.

I was really surprised by these results, so I ran some local benchmarks against the latest Vapor (0.15), the last performance focused release (0.11), and Vapor’s Engine (0.4 used in Vapor 0.15) against Kitura (0.24).

![image](/img/articles/vapor-vs-kitura2.png)

The results show Vapor’s last performance release beating Kitura, and the latest release ~5% behind. Not quite the 40% lead seen in IBM-Swift’s graph. Moreover, Vapor’s Engine — which is arguably more comparable to Kitura — has a significant lead.

Possibly IBM’s tests are finding a weakpoint in Vapor, but it’s hard for us to know since the exact environment and benchmark weren’t included in IBM’s results. If someone has details on the environment and process, please comment so we can improve our tuning!

## Results

As always, here are the in-depth details and results of the benchmarks run in this article.

### Machine

![image](/img/articles/vapor-vs-kitura3.png)

### Vapor (0.11)

{{< highlight json >}}
Gertrude:~ tanner$ wrk -d 10 -t 4 -c 8 http://localhost:8080/plaintext
Running 10s test @ http://localhost:8080/plaintext
4 threads and 8 connections
Thread Stats Avg Stdev Max +/- Stdev
Latency 438.06us 97.97us 5.03ms 84.30%
Req/Sec 4.53k 140.02 5.04k 70.79%
182307 requests in 10.10s, 25.91MB read
Requests/sec: 18050.53
Transfer/sec: 2.56MB
{{< /highlight >}}

### Vapor (0.15)

{{< highlight json >}}
Gertrude:~ tanner$ wrk -d 10 -t 4 -c 8 http://localhost:8080/plaintext
Running 10s test @ http://localhost:8080/plaintext
4 threads and 8 connections
Thread Stats Avg Stdev Max +/- Stdev
Latency 475.26us 82.59us 3.63ms 88.41%
Req/Sec 4.19k 153.49 4.44k 83.91%
168460 requests in 10.10s, 15.90MB read
Requests/sec: 16679.73
Transfer/sec: 1.57MB
{{< /highlight >}}

### Vapor Engine (0.4)

{{< highlight json >}}
Gertrude:~ tanner$ wrk -d 10 -t 4 -c 8 http://localhost:8080/plaintext
Running 10s test @ http://localhost:8080/plaintext
4 threads and 8 connections
Thread Stats Avg Stdev Max +/- Stdev
Latency 403.89us 103.08us 5.38ms 93.14%
Req/Sec 4.94k 246.49 5.19k 90.10%
198474 requests in 10.10s, 9.46MB read
Requests/sec: 19651.14
Transfer/sec: 0.94MB
{{< /highlight >}}

### Kitura (0.24)

{{< highlight json >}}
Gertrude:~ tanner$ wrk -d 10 -t 4 -c 8 http://localhost:8090/plaintext
Running 10s test @ http://localhost:8090/plaintext
4 threads and 8 connections
Thread Stats   Avg      Stdev     Max   +/- Stdev
Latency   459.65us  205.53us   9.85ms   95.29%
Req/Sec     4.32k   675.34     5.33k    61.04%
173126 requests in 10.10s, 23.57MB read
Requests/sec:  17141.44
Transfer/sec:      2.33MB
{{< /highlight >}}

## Code

And of course, the source code.

### Vapor (0.11)

{{< highlight swift >}}
import Vapor
let app = Application()
app.get("plaintext") { request in
    return “Hello, world”
}
app.globalMiddleware = []
app.start()
{{< /highlight >}}

### Vapor (0.15)

{{< highlight swift >}}
import Vapor
let drop = Droplet()
drop.get("plaintext") { request in
    return "Hello, world"
}
drop.globalMiddleware = []
drop.serve()
{{< /highlight >}}

### Vapor Engine (0.4)

{{< highlight swift >}}
import HTTP
final class Responder: HTTP.Responder {
    func respond(to request: Request) throws -> Response {
        let body = “Hello World”.makeBody()
        return Response(body: body)
    }
}
let server = try Server<
    TCPServerStream, 
    Parser<Request>, 
    Serializer<Response>
>(port: port)
try server.start(responder: Responder()) { error in
    print(“Got error: \(error)”)
}
{{< /highlight >}}

### Kitura (0.24)

{{< highlight swift >}}
import Kitura
let router = Router()
router.get("/plaintext") { request, response, next in
    response.send("Hello, World!")
    next()
}
Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
{{< /highlight >}}