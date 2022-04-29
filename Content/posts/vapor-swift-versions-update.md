---
date: 2022-04-29 17:00
description: Updating Vapor's Supported Swift Versions
tags: vapor, framework
author: Tim
---
# Updating Vapor's Supported Swift Versions

Vapor will be dropping support for older Swift versions over the coming weeks to [match our dependencies](https://forums.swift.org/t/swiftnio-swift-version-support/53232). Vapor and it's related packages will soon move to support Swift 5.4 and above. This allows us to ensure we can use the newest APIs and features from our dependencies.

We will continue to backport any security fixes for the next 6 months for older versions of Swift that affect Vapor.

We will continue to follow Swift NIO's Swift version support in Vaopr 4, supporting the current release of Swift and two previous minor versions. We may update this as we adopt `Sendable` but will announce any changes here in advance.