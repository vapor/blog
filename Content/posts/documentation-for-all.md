---
date: 2026-09-16 14:00
description: We've revamped our documentation to make it more inclusive, more accessible, and more consistent.
tags: vapor, 10 years, documentation
author: 0xTim
image: /static/images/posts/new-sites.png
---
# Documentation For All

Vapor's documentation has always been well used, even if we were always playing catch up! In this post we'll look at the improvements you may have noticed to Vapor's documentation and documentation engine in preparation for Vapor 5.

> This post is part of a series of posts for Vapor Week. See the [main blog post](https://blog.vapor.codes/posts/ten-years-of-vapor/) for more information.

![A screenshot showing all of Vapor's new sites](/static/images/posts/new-sites.png)

## How We Used To Build Documentation

Previously, we had several steps for building the documentation:

* The main documentation used MkDocs with some extensions for styling and localisation. However we were pretty restricted in how we could style this, which is why it never really 'looked' like Vapor. The nail in the coffin was the end of life for Material for MkDocs which was the main engine. We were going to have to migrate to something anyway.
* The API docs used DocC, but we had to have a Swift script to stitch all the sites together. And again, the DocC renderer doesn't give you much in terms of customisation, so another site that didn't look like Vapor, and nothing like the documentation site.
* We also have the blog and website, that have been using our new design for a couple of years, but were built on Publish with some custom steps to make pagination work on the blog.

So in essence, 3 different pipelines, 3 different styles, 3 sets of problems.

## A Unified Engine

A few months ago I started experimenting with building a new documentation engine to replace MkDocs, which resulted in the release of [Kiln](https://github.com/brokenhandsio/kiln). This was originally designed to replace MkDocs with a feature-parity Swift engine that we could customise. And it worked really well! So well in fact that we could combine not only multiple languages, but also multiple versions. And importantly we could style it how we wanted, rolling out the Vapor design to match the website and blog. I soon then added static site and blog engine capability to Kiln and we had the documentation, main website, and blog all built with the same engine.

I then decided to look into DocC. DocC is great for code documentation but the renderer is lacking. But it turns out that it will produce a giant JSON archive, so I built the hooks in Kiln to parse it and produce a fully static HTML site that can be fully customised and builds on more DocC features to allow linking between different modules and different versions!

The end result is all four sites, with a unified look, that support multi-versions, all built with the same engine. And that means any improvements we make to SEO, a11y, build improvements or design can be rolled out to every site.

## Multi-Language Support

MkDocs allowed us to support multiple languages, which has been extremely important to Vapor's appeal, so it was important that we didn't lose any of the functionality. In fact, the docs have been expanded to another language, Arabic, adding right-to-left support to the site. We've also added localisation to the main website, with a switcher based on the user's locale that spots when your browser is set to another language and suggests it, and translated to Brazilian Portuguese (which should come to the docs soon). This takes the total number of supported languages to 12! With the migration to Kiln, we could also localise more of the sites, not just the content, with its strings catalogue support. So now the entire site is translated, making it more welcoming to non-English speakers.

We're experimenting with using AI to help supplement the translations and reduce the work our incredible translation team does updating and translating the docs. We'll announce more in the future when we think we have the right balance, but to be clear - human-led translations will always come first and be used.

If you'd like us to support a new language, please open an issue or PR on GitHub!

## Accessibility

According to the [World Health Organisation](https://www.who.int/health-topics/disability), an estimated 1.3 billion people, over 16%, experience significant disabilities. Over the last couple of months, we've run a number of audits on the sites, including the documentation to ensure that we support screen readers so the sites work for all. There's been significant effort to ensure that visual items that aren't useful to text-based readers are hidden, buttons are labelled correctly and the focus order makes sense. We've also tweaked the colours of the site to ensure that the contrast fits within an acceptable range according to WCAG 2.2 AA. After all, there's no point having documentation if the pages can't be read!

A11y is now something that we have built into the sites as standard and we want to ensure that we continue to improve in this area. If you see anything that needs to be improved, please reach out so that we can fix it!

## AI Agents

With the modern world, talk of AI is unavoidable and we know a significant portion of our traffic will be from AI agents wanting to understand how Vapor works. We've built a number of things to ensure that this works:

* All sites now offer an `llms.txt` which an agent or skill can parse to find out where to get more information.
* A future release of Kiln will ensure that every page has an accompanying markdown file so it doesn't need to parse HTML to reduce token cost. This is in place in some parts already but should be on all pages soon.
* A future release will also add support for version-aware `llms.txt` to ensure that you get suggested the right docs when interacting with an agent!

## An Ongoing Effort

Documentation is always an ongoing effort and especially with a new release of Vapor, we have a lot of work to do to update the docs, update the translations and ensure all public symbols are documented to ensure we fill in the gaps for our API docs. However, by growing the docs and making sure as many people as possible can use them, we make a better framework that benefits everyone!

As ever, we couldn't do this without the support of the community, especially those who translate the docs. If you have contributed to the translations, or made multiple contributions to the documentation, please reach out to ensure you are part of the translations team on GitHub. I'll be emailing everyone in that team so we can send out some merch to say thank you. And again, none of this would have been possible without the support of our sponsors, both from [Open Collective](https://opencollective.com/vapor) and [GitHub Sponsors](https://github.com/sponsors/vapor), so thank you to those!