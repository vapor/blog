---
date: 2026-03-27 12:00
description: Vapor was selected for the 3rd session of the GitHub Secure Open Source Fund
tags: security
authors: Tim
authorImageURLs: /author-images/tim.jpg
---

# Securing Vapor for the Future - Our Experience in GitHub's Secure Open Source Fund

6 months ago Vapor was selected to join the 3rd session of GitHub's Secure Open Source Fund, a program helping open source projects ensure they are as secure as possible in the modern world, joining the likes of curl, Node.js, LLVM and many more projects. This is an amazing testament of how far Vapor has come, and a recognition of the maturity of the project and the widespread use it now has.

[![Open Source Security](/static/images/posts/open-source-security.png)](https://xkcd.com/2347/)

Funding in open source is always hard, but having a focused program on security gave us some dedicated time to look into Vapor's security. We covered basic security practices (spoiler alert - using Swift wipes out a large number of common vulnerabilities!), setting up security workflows, which we use to announce vulnerabilities, and start working on our threat model, which you'll see more in the coming months. We also covered how to set up things like fuzzing and be proactive in finding security issues. We have some exciting projects in the pipeline for this!

The month long focus was perfectly timed as we start to gear up for Vapor 5 and means we're thinking about security, and planning it in from the very beginning. Whether that's setting up Dependabot to ensure the website is up to date, keeping our GitHub Actions workflows secure or actually having a plan when something does get reported. We covered a huge amount of ground that will ensure we're set up for the future.

More importantly, the SOSF gave us access to a team of experts to ask questions, talk through vulnerabilities with and a group of open source maintainers in the exact same position to discuss issues with. Over the last 6 months the group have been through a number of varied security advisories (including [some in Vapor](https://blog.vapor.codes/tags/security/)) and it's been great to be able to share experiences, ask questions and decide when something is a security issue or not. For example, one takeaway is that we no longer treat vulnerabilities in Vapor's dependencies as a security issue in Vapor worthy of an advisory. This allows us to focus on real issues quicker.

Overall, this helps Vapor become more secure, gives us a quicker (and less stressful!) process to follow when security issues are uncovered and gives you as Vapor users a better framework to build on!