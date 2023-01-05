---
date: 2023-01-05 18:00
description: We're starting to roll out Vapor's new Design to the websites!
tags: redesign, growth
author: Tim
authorImageURL: /author-images/tim.jpg
---
# New Year, New Me

It's been a long time coming, but we're finally ready to start rolling out our new design! As Vapor matures and grows, it's important that we have a site (or rather, sites) that do a good job of selling Vapor and provide a consistent look and feel across all sites. Eventually all of Vapor's sites will implement the new design, but since it's the start of a new year, it's time to roll it out to the blog!

The design has been a long time in the planning (they were handed over by the design agency several months ago 😬). We've done things properly, using modern practices (vanilla JavaScript as needed, CSS animations, Sass compiled CSS etc) that should allow us to scale and grow. We also support light and dark mode out of the box and I think you'll agree, it looks pretty sweet!

We have a new [Design Repo](https://github.com/vapor/design) that contains all the source files and images for the design, the build pipeline and an example site, hosted at [https://design.vapor.codes](https://design.vapor.codes). This is our CDN that hosts our images and CSS. The repo also contains a Swift package that contains a number of Publish components we can use for building our sites. The [PR for this redesign](https://github.com/vapor/blog/pull/65) is remarkably simple.

We'll continue to evolve the design as we roll it out and there are a number of tweaks we need to make, especially on mobile. If you spot any issues (especially around accessibility or layout on different devices) then feel free to raise issues. 