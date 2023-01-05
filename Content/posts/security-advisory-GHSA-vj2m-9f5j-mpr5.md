---
date: 2022-05-31 10:22
description: We've fixed an issue in Vapor's FileMiddleware - CVE-2022-31005
tags: framework, security update
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Vapor `FileMiddleware` Security Vulnerability

We've just released [Vapor 4.60.3](https://github.com/vapor/vapor/releases/tag/4.60.3) which contains a fix for a security vulnerability in Vapor's `FileMiddleware`. An attacker could crash a Vapor application by sending invalid `Range` headers under certain scenarios, leading to a Denial of Service attack. This has been designated as CVE-2022-31005. 

We improved the logic for checking the `Range` headers and added tests to ensure we catch this behavior. You can see more details on the [Security Advisory on GitHub](https://github.com/vapor/vapor/security/advisories/GHSA-vj2m-9f5j-mpr5).

If you're using Vapor's `FileMiddleware` we recommend you upgrade to this release as soon as possible. 

Thank you to [Johannes Weiss](https://github.com/weissi) for reporting!
