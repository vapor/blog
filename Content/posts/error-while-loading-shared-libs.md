---
date: 2099-07-18 09:00
description: As little as possible, but no less
tags: tips, docker
author: Galen
---
# Docker image: Error while loading shared libraries: libcurl4 or libxml2

Most Vapor apps can run without `libcurl4` and `libxml2`, and omitting them from your Docker image makes the run image significantly smaller (189 MB vs. 233 MB). When they are needed, Vapor's default `Dockerfile` [now makes installing them easier](https://github.com/vapor/template-bare/commit/829f5fb2a3dc6e5c623cfec7ccdacf5517ff5c1c), while also drawing attention to the fact that they have been omitted in the first place:

``` Dockerfile
[…]
# ================================
# Run image
# ================================
FROM ubuntu:focal

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      ca-certificates \
      tzdata \
# If your app or its dependencies import FoundationNetworking, also install `libcurl4`.
      # libcurl4 \
# If your app or its dependencies import FoundationXML, also install `libxml2`.
      # libxml2 \
    && rm -r /var/lib/apt/lists/*
[…]
```

When your app executable has been linked to the dynamic library for either `libcurl4` or `libxml2` but they aren't installed, your app will crash immediately on load with one of the following errors:

> ./Run: error while loading shared libraries: libcurl.so.4: cannot open shared object file: No such file or directory

> ./Run: error while loading shared libraries: libxml2.so.2: cannot open shared object file: No such file or directory

* If your app or its dependencies import `FoundationNetworking`, you'll need `libcurl4`.
* If your app or its dependencies import `FoundationXML`, you'll need `libxml2`.

Start by omitting both `libcurl4` and `libxml2` if you're unsure that your app needs them. Then, build and run your app image. Your app will crash immediately on load if either or both are needed. (You can also inspect your binary's dynamic dependencies using `ldd`.)

See the full [Dockerfile](https://github.com/vapor/template-bare/blob/main/Dockerfile) for the latest recommended practices.
