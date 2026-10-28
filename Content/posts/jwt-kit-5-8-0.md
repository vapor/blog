---
date: 2026-10-28 19:00
description: "JWTKit 5.8.0 has been released with a number of security fixes. You should upgrade to this version as soon as possible."
tags: framework, security update, jwt-kit
author: 0xTim
---
# JWTKit 5.8.0 Security Fixes

# JWTKit Security Update

We’ve released [JWTKit 5.8.0](https://github.com/vapor/jwt-kit/releases/tag/5.8.0) with fixes for several security vulnerabilities, alongside [vapor/jwt 5.2.0](https://github.com/vapor/jwt/releases/tag/5.2.0). Some of the reports describe the same underlying issue, while others came from fuzz testing we added during the investigation.

We had held these releases while waiting for CVE IDs. Since GitHub [is struggling to keep up with the volume of advisory requests](https://github.blog/security/supply-chain-security/inside-the-advisory-database-and-what-happens-when-vulnerability-volume-breaks-records/) we've decided to release now rather than wait any longer. We’ll update this post and the advisories with CVE IDs when they’re issued.

## Identity tokens could be accepted for the wrong client

[GHSA-gxx9-vxm7-hgrq](https://github.com/vapor/jwt-kit/security/advisories/GHSA-gxx9-vxm7-hgrq) affects applications that treat a verified Apple, Google, or Microsoft identity token as a login without checking its `aud` claim. A valid provider signature does not establish that the token was issued for your application. JWTKit now provides verification methods that take `expectedAudience` or `expectedAudiences`. The audience-free methods remain available for compatibility but are deprecated. The accompanying `vapor/jwt` release uses the new checks when an application identifier is configured and warns when a provider token is verified without one. **Updating packages alone does not fix an application that continues to accept identity tokens without checking its expected audience. You will need to migrate to the new APIs.**

## Malicious numeric JWT headers could crash an application

[GHSA-hfm2-66rr-3mcf](https://github.com/vapor/jwt-kit/security/advisories/GHSA-hfm2-66rr-3mcf) describes a crash when JWTKit converted a very large number in a token header to `Int`. Headers are parsed before signature verification, so the token did not need a valid signature. JWTKit now checks whether the number can be represented before converting it, allowing malformed headers to be rejected without terminating the application.

## Fuzzing found further denial-of-service crashes

We've adopted [swift-fuzz](https://github.com/brokenhandsio/swift-fuzz) and added fuzz tests that found a number of crashes described in [GHSA-jhmq-wqhf-47x2](https://github.com/vapor/jwt-kit/security/advisories/GHSA-jhmq-wqhf-47x2). Deeply nested header values could exhaust the stack, an empty multi-value claim such as `"aud": []` could reach a precondition, and an out-of-range date could trap when encoded as integer seconds. JWTKit now limits header nesting and returns decoding or encoding errors for those invalid values.

## A token could choose its certificate validation time

[GHSA-pfgx-7g34-46fm](https://github.com/vapor/jwt-kit/security/advisories/GHSA-pfgx-7g34-46fm) concerns `X5CVerifier`, which previously used a token payload’s `signedDate` to validate its certificate chain. Someone holding the private key for an expired certificate could backdate that value to a time when the certificate was valid. Certificate validation now uses the current time by default. Applications that need to verify historical signed payloads can explicitly choose validation at `signedDate`, preferably with a maximum age.

We recommend updating JWTKit and, if you use its Vapor integration, `vapor/jwt` together. Review identity-token login paths and configure the expected client IDs or Firebase project IDs; the deprecation and runtime warnings are there to help locate calls that still omit this check.

Thank you to [@tatianahub](https://github.com/tatianahub) and [@Nadav0077](https://github.com/Nadav0077) for their reports, and to [@ptoffy](https://github.com/ptoffy) and [@gwynne](https://github.com/gwynne) for helping review and fix the issues.