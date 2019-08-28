---
title: "Vapor 3 Release Schedule"
date: "2018-01-30"
tags: [
    "announcement",
    "framework"
]
author: "Tanner Nelson"
---

The latest iteration of Vapor, a server-side Swift framework, is nearing completion! In taking a look at Swift 4.1, and the effects it will have on Vapor, we have decided to release 3.0 alongside Swift 4.1. This means we cannot give a concrete release date (unless Apple releases one). However, we have decided on a concrete release date for a GM (release candidate) version that should be suitable for early-adopters.

![image](/img/articles/vapor3-release-schedule.png)

## Swift 4.1

Swift 4.1 marks one of Swift’s biggest and best “.1” releases. The headlining feature is, of course, Conditional Conformance. This is something the Vapor team has been anxiously awaiting for (literally) years. Although it’s great news that this feature is coming in 4.1, it does pose an issue for Vapor 3. Conditional conformance has a big effect on the core of our framework — it is not a purely additive change. The hacks we used to get around not having conditional conformance in Swift 4.0 will break when compiled with Swift 4.1. For Vapor 3 to work with both Swift 4.0 and 4.1 would mean huge swaths of #if swift(>=4.1) / #else / #endif macros in our most critical code regions. Additionally, a critical bug in the macOS Security library that prevented our HTTP/2 code from compiling has been fixed in Swift 4.1. This means we can release Vapor 3 with native HTTP/2 support iff we rely on 4.1.

Considering these issues, we believe the best option to minimize bugs, confusion, and maintainers’ time is to simply require Swift 4.1.

Swift 4.1 can be downloaded from the Swift.org snapshots site for both macOS and Ubuntu. Xcode 9.3 beta should not be required. Vapor 3’s beta branch will begin depending on Swift 4.1 soon.

## Beta.1

The Beta.1 release coming on February 9th will be Vapor 3’s first fully-tagged release (modules in their correct repos). This will mean a big boost for stability since you must opt-in to updating by modifying your Package.swift file (`swift package update` alone will not break your code). Additionally, after February 9th, breaking changes must be critical issues to consider merging.

We expect tutorial writers to begin releasing early Vapor 3 content after this point (including a highly anticipated video series by the wonderful Ray Wenderlich). This will be a great time to start trying out Vapor 3. For package maintainers, this will be a great time to update your packages.

## RC.1

The RC.1 release coming on February 23rd will, for all intents and purposes, be Vapor 3’s official release — we will just be waiting on Swift 4.1. After this point, no breaking changes will be allowed. Only bug fixes and additive features will be merged.

The time after this release will be mostly dedicated to adding unit tests and documentation to the framework. Additionally, the core team will work on updating Vapor’s website, Vapor University, Penny, etc.

Although the documentation will continue to be a work-in-progress over this period, we think early adopters will have no problem moving to Vapor 3 at this point.

## Official Release

The official 3.0.0 will be coming alongside Swift 4.1. For the conservative adopters out there, the wait will be well worth it as all of the bugs and documentation issues will be solved by this point.

## Feedback

If you haven’t already, please join the #beta channel on our Slack team to give us feedback about this release schedule and of course Vapor 3 itself.

We hope you are as excited as we are — we think this is going to be Vapor’s best release yet!
