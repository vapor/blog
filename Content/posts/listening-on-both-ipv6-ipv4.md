---
date: 2022-04-09 17:00
description: See how to listen to connections from both IPv4 and IPv6 connections in Vapor
tags: tips
author: Tim
---
# How to listen to connections from both IPv4 and IPv6 addresses

This [came up on the forums](recently) but is worth posting here as well for visibility. The default Vapor template listens on `127.0.0.1` which only allows local _IPv4_ connections. If you want to allow connections from other devices you need to set the hostname to `0.0.0.0`. However, again this only accepts IPv4 connections. If you want to allow IPv4 and IPv6 connections you can set the hostname to `::`. This will accept connections from all addresses on both IP stacks. 

Thanks to Cory for posting the answer!
