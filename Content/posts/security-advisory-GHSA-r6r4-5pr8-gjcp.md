---
date: 2024-01-03 16:00
description: We've fixed an issue in Vapor's URI Parsing - CVE-2024-21631
tags: framework, security update
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Vapor URI Parsing Security Vulnerability

We've just released [Vapor 4.90.0](https://github.com/vapor/vapor/releases/tag/4.90.0) which contains a fix for a security vulnerability in Vapor's URI parsing. Due to the use of `uint16_t` indexes, it was possible to cause an integer overflow in the parser which could result in potential host spoofing. This doesn't affect Vapor applications directly but could affect users parsing untrusted input as a `URI`. This has been designated as CVE-2024-21631.

We've fixed this by removing the old C code used for parsing URIs and replacing it with a new Swift implementation. This provides a more maintainable implementation and removes any issues caused by using an unsafe language. You can see more details on the [Security Advisory on GitHub](https://github.com/vapor/vapor/security/advisories/GHSA-r6r4-5pr8-gjcp).

We recommend you upgrade to this release if you are parsing URIs from untrusted sources as soon as possible. 

Thank you to [baarde](https://github.com/baarde) for reporting!
