---
date: 2022-02-21 10:22
description: Discussing the future of Vapor and the next steps in Vapor's Life
tags: framework, growth, business
author: Tim
authorImageURL: /author-images/tim.jpg
---
# The next steps for Vapor

Over the last six (6!) years, Vapor has grown from a small experimental project for Swift developers to a full-featured, popular web framework depended upon by thousands and thousands of people. It has been quite a ride. Today we want to share the next steps for Vapor, both in terms of the framework itself and the Vapor community as a whole.

## Vapor 5

We're currently in the early stages of planning Vapor 5. This will be the next major release of Vapor and will complete several years of work of migrating Vapor from a synchronous, blocking framework to an asynchronous framework. We don't know much of what it will look like yet, but `EventLoopFuture`s will no longer be a feature, that's for certain 🎉. Vapor 5 will allow us to make use of the latest Swift Concurrency features like `AsyncSequence`s for streaming bodies, `Actor`s for shared state and `Sendable` conformances to prevent data race conditions. We're extremely excited to see how Vapor 5 turns out and for everyone to use it.

**Note**: the timeline for Vapor 5 is still very much unknown and at the time of writing is waiting on a future version of NIO and Swift 6.

### Helping the Community

We know that a major release of Vapor can be disruptive and time consuming for everyone. Whether you're learning the framework, writing community packages, building production apps or even writing books and tutorials, migrating to a Vapor 5 will take some time. To help with this we will be releasing a comprehensive migration guide to help everyone get up to speed quickly. 

We will also be announcing a support timeline for the first time and will commit to support Vapor 5 for _at least_ 2 years. This should provide some reassurances to Vapor users about the stability of Vapor 5 and know they can put the work in early to migrate and it will pay off for the years to come.

We'll post regular updates on this blog when things start in earnest and detail all the fun technical challenges we solve along the way!

## Expanding the Community

Outside of Vapor 5, we also have a number of other initiatives that we are rolling out. As a community there's a lot more we can do to 'sell' Vapor and server-side Swift in general. We are also aware that Vapor has reached a maturity level now where it is being used in production by a number of companies, but we are missing some key features that will encourage more to try it out.

### Website Overhaul

The [website for Vapor](https://vapor.codes) is certainly due an overhaul. We are going to expand it and update it with links to more docs, more tutorial sites and more community initiatives. There have been plenty of conference talks on Vapor over the years and we should feature these on the site. We also have several large companies building applications using Vapor with very large user bases. These will be highlighted in a new showcase section to show that Vapor can and does handle large production apps.

This blog is also a part of an increased focus on showing off Vapor and helping people understand it. We're going to be posting regular blog posts about both the development of Vapor and short form tutorials that don't fit into the documentation site. This should also help with people Googling for Vapor answers!
 
Both the main website and blog will be getting a full redesign in the coming weeks. If you have ideas, then send them our way in the `#design` channel in Discord.

### Improving the developer experience
 
Speaking of documentation, there are several fronts where we can improve the developer experience for new and experienced developers. First, we plan on further growing the [documentation](https://docs.vapor.codes) with more expansive docs. Whether it's examples of more complex use cases or more unusual uses of Fluent, they should be easily discoverable. If you have any ideas for what you'd like to see, please [raise an issue on GitHub](https://github.com/vapor/docs/issues/new/choose). And as always, contributions are more than welcome!
 
We also need to do a better job of aggregating all of the useful information out there. The [SSWG guides](https://github.com/swift-server/guides) for instance contain a ton of useful information, both for deploying applications and measuring performance. There are lots of blog posts, GitHub projects, books, tutorials, videos and many other useful things for learning about Vapor we should link to. Having somewhere either on the website or a regular blog post to link to them would be a great start in helping the community learn about each other.
 
Currently the Vapor docs are available in English and Chinese. We'd love to expand this to more languages, so if you're interested in translating the docs into another language please get in touch!
 
Finally, we are planning on adding a jobs section to the website. There are Vapor jobs out there and also Vapor developers out there. We can help facilitate linking these two groups up!

### Introducing Vapor Evangelists

One of the best ways for developers to hear and learn about Vapor is at conference talks. There have been plenty over the years by several different people but we want to encourage and grow this, and not just at iOS conferences. We are introducing a Vapor evangelist program for those helping to spread the Vapor word! Not only will you feature on the website with your talk linked, we'll also send you t-shirts to wear at the conferences and stickers to give away when there!

If you want to talk at a conference feel free to contact Tim (@0xTim on Discord) as he's done plenty and can advise.

## Securing Vapor's Future

Running an open source project on Vapor's scale is not an easy prospect. Whilst Vapor is in a good position currently to weather any storms we want to ensure we're in the best possible place we can be. We have an amazing selection of [sponsors](https://github.com/sponsors/vapor) and want to continue to grow that. If you have found Vapor useful personally and are interested in supporting us then please take a look.

If you are using Vapor in your company then consider sponsoring us at one of our corporate tiers. You'll get dedicated time from the core team and a dedicated line to be able to ask questions. Sponsors are by far the best way to support the project and ensure it continues to grow and succeed. Whether it is an individual supporting at $5 a month or a company supporting us at a corporate tier we are incredibly grateful. More sponsors would allow us to fund more full-time core engineers, more work like the redesign and build a better product.

### The Vapor Support Program

Whilst Vapor is being used by several large companies we know that one of the things that holds companies back sometimes from choosing Vapor is the uncertainty of both what happens when things go wrong and how to teach Vapor to new developers. To combat this, we're launching the Vapor Support Program. We're going to be partnering with a number of companies who offer training courses and professional support for Vapor. That means that if a company needs any kind of help, either in the form of an SLA contract, custom work or a training workshop, they can pick one of the companies vetted and approved by Vapor for this. We'll have a dedicated section on the website to showcase this and for companies to find the support they need.

[Broken Hands](https://brokenhands.io) will be the first company to join the Vapor Support Program but if you're interested in becoming a part of it, please get in touch.

### The Vapor Shop

Finally, we're going to be resurrecting the Vapor shop and actually helping people find it! We'll have a range of merchandise and stickers which will help support the framework, all updated with new Vapor logos!

## Improving Vapor's Infrastructure

Last and not least we have a fair amount of work to do to improve the infrastructure that we rely on for Vapor. We have a surprising amount of stuff we run for Vapor, including the various websites, documentation sites, Discord and GitHub bots.

At the moment most of it is across a mishmash of services and most sites are run on a single VPS! We'll be updating everything to run on a modern architecture to ensure that random failures don't mean all things Vapor are offline!

## Next Steps

Many of the things announced above are already under way or released. Aside from Vapor 5 our main focus for the next few weeks/months is going to be the big redesign of the sites. If you have any suggestions or ideas, please get in touch!
