---
date: 2023-05-24 12:00
description: Advance warning of some upcoming changes to Vapor as we continue our Concurrency journey.
tags: vapor, framework
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Upcoming changes to Vapor with `Sendable`

Adopting Swift Concurrency has consumed a large amount of the core team's time (including a failed experiment to switch some of Vapor's internals to use actors!). However, it's a fundamental piece of the concurrency journey and we want to make sure we get it right.

Over the next few days and weeks we're going to start rolling out `Sendable` annotations to Vapor's repositories, starting with [this PR](https://github.com/vapor/websocket-kit/pull/131). The changes to the main Vapor repository are extensive and we'll be releasing a beta to allow people to test their code against the changes before we release it.

These changes will make Vapor safer in the long run and ensure we're following best practices as more warnings are turned on at the compiler. Once the `Sendable` work is complete, this unblocks a lot of other PRs and work that have been queued behind it, so it could be a busy few weeks for releases!
