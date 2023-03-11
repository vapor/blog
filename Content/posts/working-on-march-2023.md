---
date: 2023-03-05 14:00
description: Learn about what we're working on this month for Vapor and what our goals are for the next 6 months.
tags: framework, growth, what we're working on
authors: Tim; Gwynne
authorImageURLs: /author-images/tim.jpg; /author-images/gwynne.jpg
---
# What We're Working On: March 2023

This is the first post in a new series where we'll be sharing what we're working on for Vapor for the current month and sharing some longer term plans. The idea is to provide a bit more transparency as to what it takes to maintain the framework, offer some insight into why PRs sometimes get stuck and unattended, and let you know what we have planned for the future. We'll be sharing this every month, so keep an eye out for the next post!

## Just Shipped

We recently finished two big projects that were consuming a fair bit of time but which provide a solid foundation for building Vapor going forward - [migrating to AWS and migrating the API docs to DocC](https://blog.vapor.codes/posts/finalsing-our-migration-aws/). This was the culmination of a lot of hard work by the Core Team and lots of community members. DocC is clearly the future for documenting Swift code and any PRs that are merged going forwards will need full DocC comments on all new public symbols. We have a lot of backporting to do as well, so if you want to start contributing and are looking for easy tasks to get started, adding missing DocC comments will be a great place to start and really help everyone using Vapor.

Finishing the migration to AWS (finally!) not only saves us money but allows us to investigate to areas of interest (think a Vapor jobs site) and make it easier to roll out things like the new website design and previewing PRs is all done via CI.

Finally, there's been a fair amount of activity in Fluent. A [number](https://github.com/vapor/fluent-kit/pull/554) [of](https://github.com/vapor/fluent-kit/pull/550) [PRs](https://github.com/vapor/sql-kit/pull/162) in Fluent to reduce the number of `fatalError()`s, add better support for composite primary keys and align features across the Fluent ecosystem.

## Coming Up

There are three big pieces of work going on this month (and likely the next few months). On top of those, we'll be working to clear some of the backlog of issues and PRs that have been sitting around for a while.

### New Design

Vapor's [new design](https://github.com/vapor/design/tree/main-site-components) is coming along. Having [shipped the redesign to the blog](https://blog.vapor.codes/posts/rolling-out-the-new-design), we're now working on the main website. This is a much bigger project as it encompasses many more components and pages. We're also migrating the site from VueJS to [Publish](https://github.com/JohnSundell/Publish). The blog was written in Publish from the start with the knowledge that we'd be doing the redesign, making it a much faster process. There's also a lot more dynamic content for the main site with the showcase sections, sponsors, etc. We have most of the components for the homepage done; next up will be the different pages.

If you want to help contribute then feel free to get involved! We have some outstanding issues on the [design site](https://github.com/vapor/design) that could be good to start with.

### MySQLNIO Rewrite

Over the last few months we ("we", of course, being Gwynne) have been working on a rewrite of the [MySQLNIO](https://github.com/vapor/mysql-nio) package, which provides the low-level MySQL wire protocol implementation for Fluent. It's a long overdue task, focused on filling in major gaps in basic feature support, fixing some (hopefully all!) of the literally dozens of known bugs and limitations, and improving in a big way the increasingly inadequate runtime performance. Basically the idea is to bring the package up to par with the truly inspired work that was done on [PostgresNIO](https://github.com/vapor/postgres-nio) by [Fabian Fett](https://github.com/fabianfett), particularly emphasizing the Concurrency support and robust error handling.

### Full Concurrency Support in Vapor

Finally, with the design underway, API docs migrated and infrastructure complete, we can pick up the [concurrency work](https://blog.vapor.codes/posts/async-next-steps/) again. This will ensure that `Request` (or maybe a new `AsyncRequest` type) fully supports `Sendable` and any changes needed to make that happen. We'll switch some of the underlying types to actors where it makes sense and ensure Vapor is easy _and safe_ to use with Swift Concurrency.

One of the goals of this was to enable backporting of Vapor's support for Swift Concurrency to older Apple Platforms - [that was merged](https://github.com/vapor/vapor/pull/2926) a few weeks ago 🎉. This means that Vapor 4.68.0 and above will work on macOS 10.15, iOS 13, tvOS 13 and watchOS 6. If you're using Vapor on iOS and other Apple platforms, this should make it easier to use Vapor's concurrency support.

## Wrapping Up

As you can see, we have a fair amount on our plate for a Core Team of two! Thankfully we have an awesome community and if you want to help out by answering issues on GitHub, giving PRs a review, or answering questions on Discord, that frees us up to continue to work on Vapor!

If there's anything you'd like to see in these monthly posts that you think is missing, then let us know on Discord!
