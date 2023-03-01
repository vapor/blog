---
date: 2023-03-01 14:00
description: The API docs have been migrated to DocC and we've finished migrating all of Vapor's infrastructure to AWS.
tags: docs, infrastructure
author: Tim
authorImageURL: /author-images/tim.jpg
---
# API and Infrastructure Updates

Today I switched off the original, old Digital Ocean droplet. Over the last year or so we've migrated all of Vapor's infrastructure to AWS to provide a better experience for our users and set us up for growth going forward.

## API Docs

The last piece of infrastructure to migrate was the [API docs](https://api.vapor.codes). Up until this point, the API docs were using the now archived [`swift-doc`](https://github.com/SwiftDocOrg/swift-doc) project. This worked reasonably well for us but came with some pitfalls. Namely tooling support, integration with Xcode and feature development.

With the release of [DocC](https://www.swift.org/documentation/docc/) - Swift's first class documentation tool - we decided to migrate the API docs to DocC. This was a fairly straightforward process, but did require a bit of work to get the existing documentation into the DocC format by adding a DocC catalog. We still have a lot of work to do to make sure that symbols are linked correctly, (not to mention adding documentation for all the missing symbols!) but all of Vapor's API docs are now available in DocC format, at [api.vapor.codes](https://api.vapor.codes).

DocC is evolving and growing quickly and at some point in the future we'd love to have all of Vapor's docs using DocC once features such as localization, search and cross-module linking are added. We're making use of the experimental features as well and look forward to seeing those grow. The final piece that will take time to implement is making the documentation fit our new [design](https://design.vapor.codes).

### DocC Linking Woes

We hit some pain points around linking on Linux with DocC. Linking in Swift works differently on macOS compared to Linux. Foundation for example is linked to the Objective-C runtime bundled in the OS on macOS, but on Linux it pulls it in from the Swift toolchain. One main thing this changes is anyone using `@_exported`. On Linux, any module imported with `@_exported` is included as _your_ module. Vapor unfortunately uses this a lot, partly to make working with `EventLoopFuture`s significantly easier, and partly due to some trigger happy development that will be removed in Vapor 5. What this means is that every symbol in Foundation, Crypto and any other dependency that Vapor marks with `@_exported` were part of the DocC documentation. So instead of uploading a reasonable archive for Vapor's symbols we ended up trying to upload over 100,000 files to AWS, to everything from Vapor's `Application` to Foundation's [`UserDefaults` functions](https://developer.apple.com/documentation/foundation/userdefaults/1412197-persistentdomain). As well as taking a long time to upload it made functions like search unusable and also would cost a lot of money to upload!

The solution to this is to import dependencies properly and not mark them with `@_exported`. Whilst we would love to do this, this is a breaking change that would break a lot of people's code so needs to wait for Vapor 5. What we ended up doing was wrapping our exports with a [`BUILDING_DOCS` flag](https://github.com/vapor/vapor/blob/4f25c4d584f6921d40bf268faf6b863000a7e582/Sources/Vapor/Exports.swift#L1). This flag is set when building the docs and allows us to import the dependencies properly and not mark them with `@_exported`. This means that the symbols are no longer included in the DocC archive and the upload is much faster and we only include the symbols we want.

### Migrating the API docs to AWS

The API docs were the last piece to be migrated to AWS for good reason. As well as the main site, the API docs consist of 27 packages that all need to be built, uploaded and hosted without interfering with the other packages. Before the migration, whenever a pull request was merged in one of the repos it kicked off the old API docs GitHub action in each repo. This action would SSH onto the Digital Ocean server and kick off a script to build the docs. It had to clone _every single repo_, build each one, generate the documentation and then copy it to the correct directory. This process took a long time and consistently errored out. We had a timeout of 30 minutes set in the SSH action which worked most of the time, but would fail regularly. If two packages had commits to `main` at the same time, the second one would fail because the first one was still building.

Finally, running all the API docs on one fragile server in Digital Ocean does not provide a great experience for anyone reading them. Things were a bit more stable towards the end when it was the only service running on the droplet but we still had issues with builds failing and timing out.

Now, the API docs use a much more modern setup. The [API Docs repo](https://github.com/vapor/api-docs) now only builds the main page for now. It hosts a reusable GitHub action workflow that the other packages use to pull in a [Swift script](https://github.com/vapor/api-docs/blob/main/generate-package-api-docs.swift) to build the docs for just that package. Each package now only builds the docs for itself and then uploads it to the right place in S3.

## Infrastructure

Vapor surprisingly has a lot of infrastructure behind the scenes. As well as the API docs, we have the [main documentation](https://docs.vapor.codes) (now available in English, Chinese, German and Dutch!), the soon-to-be-updated [main website](https://vapor.codes), redirects for [vapor.team](https://vapor.team) to Discord and this blog. Then we have a number of lambdas to [automate releases](https://github.com/vapor/release-bot) and run interactions for Penny, our [community Discord bot](https://github.com/vapor/penny-bot). Penny itself consists of a Docker container connected to Discord's Gateway receiving webhooks for everything going on in Discord.

Previously, all of this was running on a single Digital Ocean droplet. This needed regular maintenance to keep updated, and was a single point of failure. We also had to manually SSH into the server to do anything. We previously had an incident where due to a credit card issue, a payment was declined which we were unaware of, and the server was shut down. This resulted in several hours of downtime for all things Vapor whilst we had to manually recreate everything on a new server.

Now, all static sites are hosted in S3 and served via CloudFront, AWS's CDN. This provides a number of benefits. First, it's significantly cheaper to run! All of Vapor's sites cost barely a dollar every month, and we get a significant amount of traffic. Second, S3 and CloudFront are built for serving static content. This has resulted in a significant improvement in loading times for the site. If you are in the east coast of the US, you should see loading times drop from an average of 1.5s to a few hundred milliseconds. If you live on the other side of the planet, such as in Asia, loading times will again be a few hundred milliseconds. Previously it was an average of 3 seconds because it had to retrieve it from the server in the US. Now CloudFront will serve it from the nearest edge location to you. This is a huge improvement and makes the site feel much faster.

Finally, all the static sites, like everything else, are configured using CloudFormation stacks. This is commonly known as Infrastructure as Code, but means that if we need to change or update any infrastructure, or even move stuff to an entirely different AWS region, it's a single commit to GitHub and our CI will deploy it for us automatically.

Most of our compute is now running in AWS lambda, where it makes sense. For instance the release bot is only triggered when a PR is merged on GitHub, which at most happens a few times a day. So that code now runs in AWS Lambda, and only runs when needed. We currently have one compute service that needs to be long lived, which is the core of Penny. This needs to always be on as it works via a websocket connection to Discord. This is a Vapor app running in a Docker container on Fargate and ECS in AWS. Again, this is all automated and managed by CloudFormation and CI and there are no servers for us to manage or maintain.

## Conclusion

Whilst the infrastructure that runs Vapor is invisible to most people, it's an important piece that needs to allow us to grow and evolve in the future. Whether we want to launch an interactive job site, add new localizations to our docs, or completely migrate from MKDocs to DocC, having a solid foundation to build on is important. Much like our new design framework, having the pieces ready to go that we can use when needed will allow us to grow quicker without worrying about whether it's up to the job or provide a bad experience for our users.
