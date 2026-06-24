---
date: 2023-05-10 13:30
description: "PostgresNIO 1.14.2 fixes CVE-2023-31136, a TLS flaw letting a man-in-the-middle inject responses to a client's first queries. Upgrade as soon as possible."
tags: framework, security update
authors: 0xTim; Gwynne
---
# PostgresNIO Security Vulnerability

> We're sorry for the delay in publishing. We had issues with our deployment pipeline that're now fixed.

We released [PostgresNIO 1.14.2](https://github.com/vapor/postgres-nio/releases/tag/1.14.2) last week, which contains a security fix for a vulnerability in PostgresNIO's TLS support. This has been designated as CVE-2023-31136.

Any user of PostgresNIO connecting to servers with TLS enabled is vulnerable to a man-in-the-middle attacker injecting false responses to the client's first few queries, despite the use of TLS certificate verification and encryption. This is related to the issue in PostgreSQL itself, [CVE-2021-23222](https://www.postgresql.org/support/security/CVE-2021-23222/).

Special thanks to PostgreSQL's Tom Lane &lt;tgl@sss.pgh.pa.us&gt; for reporting the original issue and [Fabian Fett](https://github.com/fabianfett) for the fix in PostgresNIO!

For more information, see the [security advisory on GitHub](https://github.com/vapor/postgres-nio/security/advisories/GHSA-9cfh-vx93-84vv).
