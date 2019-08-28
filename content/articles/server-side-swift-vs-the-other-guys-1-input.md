---
title: "Server Side Swift vs. The Other Guys — 1: Input"
date: "2016-05-28"
tags: [
    "Benchmark",
    "Vapor"
]
author: "Tanner Nelson"
---

What makes Swift different than the other popular web frameworks that exist today? Does Swift work well as a server-side language? That’s what this series will attempt to answer. We’ll compare Vapor, a web framework written in Swift, to popular frameworks written in other languages.

This first post will cover input, i.e. request data. Fetching input from a request, ensuring it is the correct type, and most importantly, not crashing. These are common tasks that most web developers deal with daily. All of the frameworks have their own unique way of doing these tasks–Let’s see how they contrast.

## The Frameworks

* Vapor (Swift)
* Ruby on Rails (Ruby)
* Laravel (PHP)
* Express (JavaScript)
* Django (Python)
* Spring (Java)

## The Test

The test consists of parsing the following JSON input and fetching the 2nd user’s identifier as an integer.

{{< highlight json >}}
{
    "name": "Test",
    "users": [
        { "id": 1337, "email": "foo@gmail.com" },
        { "id": 42, "email": "bar@gmail.com" },
        { "id": 500, "email": "baz@gmail.com" },
    ]
}
{{< /highlight >}}

The integer should then be returned as the following JSON response.

{{< highlight json >}}
{
    "second_user_id": 42
}
{{< /highlight >}}

If the data is invalid, a 400 response should be returned.

### Aside

I have only developed server-side software using Swift, JavaScript, and PHP before this test. For the rest of the frameworks, it was my first attempt, and it took a lot of Googling around.

## Vapor (Swift)

As a contributor to Vapor, it was very easy for me to complete the test. It took less than two minutes in total.

![Vapor](/img/articles/vs-the-other-guys-vapor.png)

With the 0.9 release came path indexing which allows for the convenient comma-separated access into request data. Accessing the data and checking or casting into the proper type (Int) are done in one line. And, most importantly, it’s not going to crash if the data doesn’t match (a different story for the other frameworks).

In the case that the request doesn’t have the data necessary, the convenience Abort error is thrown. This triggers a default JSON response by Vapor, but can also be caught with Middleware to provide a custom response.

Finally the JSON response is a simple native Swift dictionary wrapped with an initialization call to JSON.

![Vapor](/img/articles/vs-the-other-guys-vapor2.png)

Vapor passes the test with a 200 and a stunning 3ms response time (without optimizations enabled).

## Ruby on Rails (Ruby)

I have never used Rails before, so it took a long time to get set up and get my brain wrapped around Ruby.

![Ruby](/img/articles/vs-the-other-guys-ruby.png)

The syntax here is definitely more verbose than I would have liked. Both for fetching the data from the input and returning the JSON response. It would be much easier and more tempting to simply use:

{{< highlight ruby >}}
params[:users][1][:id]
{{< /highlight >}}

But this will create a 500 error if the data is malformed.

![Ruby](/img/articles/vs-the-other-guys-ruby2.png)

After a bit of messing around with session configuration and figuring out how to setup the routes,

{{< highlight ruby >}}
post ‘input’ => ‘input#input’
{{< /highlight >}}

Rails passed the test with a 19ms response time.

## Laravel (PHP)

Creating a new Laravel project only took a few minutes, and the self packaged PHP server was quick to create a development environment.

![PHP](/img/articles/vs-the-other-guys-php.png)

Laravel’s input method accepts key paths which made it easy to get the desired identifier (Vapor also accepts key paths: request.data[path: “key.path”]). Laravel also doesn’t crash if the data is malformed.

It did take an extra step to confirm the identifier was an integer, a step that may be necessary if certain integer-only functions are to be called on it.

Laravel also makes it easy to return JSON. The test passed with flying colors– the only problem was it took 70ms.

![PHP](/img/articles/vs-the-other-guys-php2.png)

## Express (JavaScript)

Express was the easiest of the non-Swift frameworks to setup. It was also the fastest, returning in 3ms.

![Express](/img/articles/vs-the-other-guys-express.png)

But it suffered from the same problem Rails had. If you don’t explicitly check the input data integrity, you will get a crash. The resulting code was clunky, and I’m still not 100% sure there’s no way this can crash.

## Django (Python)

Python was interesting. I was able to catch the KeyError, so indexing into the JSON data could be done in one line. But checking for an integer value had to be done as a separate step.

![Django](/img/articles/vs-the-other-guys-django.png)

It was a little tricky to get setup with Django, since I’ve never worked with it before. I got a lot of weird errors, like the following:

![Django](/img/articles/vs-the-other-guys-django2.png)

The routing was also a bit strange. I don’t know what r’^ has to do with anything.

![Django](/img/articles/vs-the-other-guys-django3.png)

But after some trial and error, Django passed the test with a speedy 4ms response time.

## Spring (Java)

Last but not least is Spring. This one was the hardest to get set up and took the most steps to pass the test. Java really wants to force you to use classes for your JSON. This is a good idea for big projects, but there should be a simpler way.

(In Vapor, Swift’s protocols allow any class that conforms to JSONRepresentable to be used anywhere a standard JSON object can be used.)

![Spring](/img/articles/vs-the-other-guys-spring.png)

After a few NullPointerExceptions, Spring passed the test with something that ended up looking like this.

![Spring](/img/articles/vs-the-other-guys-spring2.png)

The RequestBody maps to a UsersRequest object which looks like this.

![Spring](/img/articles/vs-the-other-guys-spring3.png)

Basically, Spring maps the JSON onto classes. Or at least that’s the only way I could get it to accept and produce JSON.

Needless to say it was a lot of unnecessary files and work to pass the test. And, when Spring finally did pass the test, it took a whopping 194ms to get the response. (EDIT: This is from a cold start. The average response time is closer to 7ms).

## Conclusion

It’s clear that something simple like reading and responding JSON could be made better in a lot of the popular web frameworks out there. The ability to access nested request data easily and without worrying about crashes is essential to every day web development. Swift makes some of these basic, repetitive tasks more concise, expressive, and safe. It’s also a lot faster.

![Conclusion](/img/articles/vs-the-other-guys-conclusion.png)

Check out Vapor’s <a href="http://qutheory.io/" target="_BLANK">website</a>, <a href="http://github.com/qutheory/vapor" target="_BLANK">GitHub</a>, and <a href="http://twitter.com/qutheory" target="_BLANK">Twitter</a>.

The next “Server Side Swift vs. The Other Guys” will cover installation and setup times.
