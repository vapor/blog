---
date: 2025-08-14 18:00
description: See how we approach releases in Vapor, so we can release quickly and often to save time and provide a better experience for users and contributors.
tags: Framework, Automation
author: Tim
authorImageURL: /author-images/tim.jpg
---
# How we approach releases at Vapor

I've had some interesting conversations recently at why we do releases the way we do in Vapor so thought it would be worth sharing. 

## Vapor Releases

Our release process is generally pretty simple. For everything outside of new major versions we treat each pull request as a new release. Each pull request will get tagged with one of three labels:

* `no-release-needed` - this usually encompasses things like test changes, updates to CI or the README or updates to governance files. Basically anything that doesn't touch `Sources` and wouldn't result in any changes for people pulling in the code. 
* `semver-patch` - in following with SemVer guidelines this would be bug fixes that don't have an effect on the public API. 
* `semver-minor` - changes that would introduce new APIs that can be adopted. 

The pull request will go through a review by one of the maintainers/core team, and obviously must pass all the tests in CI across the different platforms and Swift versions we support. Once that's all green, we merge the PR and use [Penny](), Vapor's bot, to create a release. The pull request title and body form the release title and body (which is why you might see us edit them if you submit a PR) and if the PR is tagged with SemVer patch or minor, Penny works out the release number, tags the code, creates a release in GitHub and notifies Discord. The only exception to this is security releases because GH doesn't support automations on security forks yet.

When I originally started contributing to Vapor, I really wasn't a fan of how releases were run. With a flurry of activity, we could have a few releases a day, or several in a week. And the numbers could get quite big (at the time of writing Vapor's minor version is on 115). But these days I really value the release process. It provides a lot of benefits and makes life as an open source project easier.

## What prompted this

Vapor's release process has been this way for several years now. In the beginning, release notes were hand written (GitHub didn’t have the feature to generate them for you back then). This is a slow, time consuming process and you need to decide when to cut a release. So the decision was made to automate it all.

## Saving Time

Open source development is always time constrained, let alone when we have 30+ packages to maintain and coordinate releases across. So anything we can do to save time is a win, especially tasks that take us away from actually improving Vapor. Releases are a great candidate to automate and save time and it makes releases such as easy process. Merge a PR and that’s it - it’s almost the holy grail of modern software development and as close as we can get to continuous delivery as possible as a framework. 

## Catching Bugs

We like to think we all write perfect software. And Vapor has a pretty good test suite covering a lot of behaviour. We also have an awesome group of maintainers who review and look over code. So there are a lot to checks in place to make sure we ship good code.

Despite this, sometime bugs do get through. It could be an edge case not currently tested, or it could be a code change that’s hit a bug in the compiler that means it doesn’t compile in release mode for a particular version of Swift for a particular platform (there’s a bug in 6.1 that’s bitten a few projects). So on very rare occasions we ship a bug, that’s a fact of software. But because each PR is its own release, it’s very easy to work out which release, and therefore which PR caused an issue. This gives us an immediate head start when debugging and makes it very easy to just roll back a change if something catastrophic happens. We don’t have to pick apart changes because 20 other commits have happened after, which make reverting the bug much harder.
All of which again, saves us time!

It also means bugs get caught quicker. Going back to the theme of continuous delivery, the whole ethos is to get code releases in smaller pieces, so it gets used quicker and bugs get caught quicker. Ideally they’d be caught by our test suite (and any bug fixes come with a regression test to ensure it doesn’t happen again), but with quick releases it means we don’t have code merged into `main` sat there for months with bugs.

## Good For Contributors

Another small thing that often gets overlooked is the benefit for contributors. If you submit a PR, you know that as soon as it’s merged, that’s _your_ release. Your code isn’t sat waiting to be tagged for a long time.

## What About Beta Testing

One question that comes up a lot is why not just use beta tests? And we could - we could do each release as a beta and let people test it first. But the reality is that unless we’re releasing betas for something like Vapor 5, no one really tests them. So it just takes longer to get code out to users and discover issues. So it's easier to just go straight to a release.

## Wrapping Up

The way we do releases in Vapor makes it easy to get releases out. We have a well defined, automated process that saves time and ultimately makes it easier to maintain the project.