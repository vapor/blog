---
date: 2022-06-06 17:22
description: We've fixed an issue in Vapor's URLEncodedFormDecoder - CVE-2022-31019
tags: framework, security update
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Vapor `URLEncodedFormDecoder` Security Vulnerability

We've just released [Vapor 4.61.1](https://github.com/vapor/vapor/releases/tag/4.61.1) which contains a fix for a security vulnerability in Vapor's `URLEncodedFormDecoder`. An attacker could crash a Vapor application by sending heavily nested data in a request body with a `application/x-www-form-urlencoded` `Content-Type`, leading to a Denial of Service attack. This has been designated as CVE-2022-31019.

We've limited the amount of recursion the decoder can undertake to stop future attacks and audited other code instances where we recursively decode data. You can see more details on the [Security Advisory on GitHub](https://github.com/vapor/vapor/security/advisories/GHSA-qvxg-wjxc-r4gg).

Since this affects anyone calling `req.content.decode()` we recommend you upgrade to this release as soon as possible. 

Thank you to [Johannes Weiss](https://github.com/weissi) for reporting!
