---
date: 2023-10-05 11:00
description: We've fixed an issue in Vapor's Error Handling - CVE-2023-44386
tags: framework, security update
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Vapor HTTP Error Handling Security Vulnerability

We've just released [Vapor 4.84.2](https://github.com/vapor/vapor/releases/tag/4.84.2) which contains a fix for a security vulnerability in Vapor's error handling. An attacker could crash a Vapor application by sending invalid requests, such as a GET request with a body and `Content-Length` that was incorrect, which under certain scenarios could lead to a Denial of Service attack. This has been designated as CVE-2023-44386. 

When the right conditions were met Vapor would attempt to write a response to a channel handler that had already been closed, triggering a NIO precondition. We've improved the checking in our channel handlers and channel handlers setup to ensure this is no longer possible and added tests to ensure we catch this behavior. You can see more details on the [Security Advisory on GitHub](https://github.com/vapor/vapor/security/advisories/GHSA-3mwq-h3g6-ffhm).

We recommend you upgrade to this release as soon as possible. 

Thank you to [t0rchwood](https://github.com/t0rchwo0d) for reporting!
