---
title: "Vapor 4: Alpha 1 Releases Begin"
date: "2019-05-28"
tags: [
    "announcement",
    "framework"
]
author: "Tanner Nelson"
cover: "/img/articles/vapor4-alpha.png"
---

Hello, Droplets! We’re excited to announce the next milestone for Vapor 4’s release begins today: Alpha 1. These releases will begin rolling out today and will continue over the next few days / weeks.

We have been working incredibly hard on Vapor 4 for a while now. Tons of great feedback and contributions from the community have been put into this release and we think it’s going to be amazing.

## Release Process

Each Vapor 4 package will receive a tag suffixed with -alpha.1. We will start with core packages, such as NIOKit and CryptoKit, then slowly work our way up the dependency tree until all packages are tagged. `

To use alpha releases in your project, specify -alpha as a pre-release identifier in the `from:` section of your Package.swift dependency:

{{< highlight swift >}}
.package(url: "https://github.com/vapor/x.git", from: "4.0.0-alpha")
{{< /highlight >}}

Once all repositories are tagged, we will update our official templates and provide more information on how to help us test Vapor 4.

## What is an alpha release?

Alpha tags signify that Vapor 4 is ready for testing. They make it easier for other SPM packages, like projects, to depend on the releases and they simplify bug reporting.

It is important to note that APIs are still in flux and some features may still be missing or broken. It is not recommended that you begin migrating large projects to Vapor 4 during this phase.

Since APIs are still subject to change, we will not yet be creating full release notes or migration guides. These will most likely come during the beta phase.

### Reporting Bugs

If you find anything missing or broken, please report it as a GitHub issue to the repository in question. If you aren’t sure which repository to report to, you can fallback to: <a href="https://github.com/vapor/vapor" target="_BLANK">https://github.com/vapor/vapor</a>.

## Feedback on Vapor 4

A big part of these alpha releases is to get feedback from the community on Vapor 4’s overall direction. Although 3.0 to 4.0 is not as big of a change as from 2.0 to 3.0, there has still been wide-ranging improvements. Please take this chance to give us feedback on these changes — the sooner the better.

### Giving Feedback

The best ways to give us feedback are on GitHub and Discord:

* Filing issues on <a href="http://github.com/vapor" target="_BLANK">http://github.com/vapor</a> repositories
* Discussion in <a href="http://vapor.team" target="_BLANK">http://vapor.team</a> #development channel

## Documentation

Vapor’s official docs (http://docs.vapor.codes) have not been updated yet. The best ways to get more information on how to use alpha packages are:

* master branch API docs: <a href="https://api.vapor.codes" target="_BLANK">https://api.vapor.codes</a>
* Asking questions in <a href="http://vapor.team" target="_BLANK">http://vapor.team</a> #development channel

## Going forward

There will likely be several iterations on these alpha releases before we feel ready to move into beta. This will largely depend on the feedback we get from the community. Here are some things we are looking for to indicate beta-readiness:

* Public API feeling stable
* Majority of feedback moves to bugs, not larger issues or missing features

## Thanks!

We want to give a huge thanks to the community for helping us get to this point. Vapor 4 is chock-full of great improvements and we can’t wait for you to try them out.
