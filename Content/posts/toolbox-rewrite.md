---
date: 2025-03-07 16:00
description: The Toolbox has been rewritten using the best tools in the ecosystem, and it's now more powerful than ever!
tags: toolbox, templates, ecosystem
authors: Francesco
authorImageURLs: /author-images/francesco.jpg
---
# The new Vapor Toolbox

## The state of the Toolbox

The Vapor Toolbox is a command line tool that used to help with common tasks when working with Vapor, such as creating, building, running and deploying projects.

Nowadays, most of the Toolbox subcommands are deprecated, as Swift and the ecosystem have evolved to provide better tools for these tasks.
The only feature that is still very useful is the `new` command, which is used to create new Vapor projects from templates.

Toolbox templates are Git repositories that contain a Vapor project, and they use Mustache to replace placeholders with user input.
To do the Mustache templating, the Toolbox used [a library maintained by Vapor Community](https://github.com/vapor-community/mustache), which is a Swift wrapper around the [`mustach` parser](https://gitlab.com/jobol/mustach), written in C.

The Toolbox was built using [`ConsoleKit`](https://github.com/vapor/console-kit), a library made by the Vapor team that provides APIs for creating interactive CLI tools, developed before [Swift Argument Parser](https://github.com/apple/swift-argument-parser) was introduced.
The argument handling capabilities of `ConsoleKit` are now considered obsolete, and it's recommended to use Swift Argument Parser instead.

## Rewriting the Toolbox

We are happy to announce that the Vapor Toolbox [has been rewritten](https://github.com/vapor/toolbox/pull/471) from the ground up, using the best tools in the ecosystem and the latest Swift features.

All deprecated subcommands have been removed, and the only feature left is the `new` command.

We have replaced the `mustach` wrapper with Hummingbird's [`swift-mustache`](https://github.com/hummingbird-project/swift-mustache), which is a Mustache rendering library written completely in Swift.

We have also dropped the dependency on `ConsoleKit` and replaced it with Swift Argument Parser, which is now the recommended way to build command line tools in the Swift ecosystem.
Swift Argument Parser doesn't support dynamic arguments out of the box, which are a fundamental feature of Toolbox templates.
To work around this limitation, we have implemented [a solution](https://www.ackee.agency/blog/argumentparser-loading-dynamic-arguments) that relies on custom reflection, which allows us to dynamically generate the command line arguments based on the template manifest file.

The new Toolbox is written in Swift 6, so we can use the latest language features and improvements, such as Swift Testing for unit tests and Swift Format for code linting.

This rewrite is another step towards embracing the Swift ecosystem, while also providing the best tools for the Vapor community.

## New features and backwards compatibility

All templates that worked with the old Toolbox, including [Vapor's official template](https://github.com/vapor/template) and all existing custom templates, should continue to work with the new version.

The defining characteristic of a Vapor Toolbox template is the presence of a YAML manifest file, which lists the user input variables and specifies the Mustache template files that will be rendered using those values, and the overall structure of this file hasn't changed. However, we have added new functionality to it, such as allowing nested variables for conditional rendering of files and directories, and the ability to define a custom path to the manifest file via the new `--manifest` flag (the default remains `manifest.yml`, as before).

We have also added a new `--verbose` flag to the `new` command, which when enabled will print output similar to the old Toolbox.
The new default console output is much more concise.

There's also a new **hidden** `--dump-variables` flag, which dumps the template variables as JSON.
This can be useful when integrating the Toolbox with other tools, say for example a GUI or (spoiler alert!) a VS Code extension.

> Note: The `--dump-variables` flag is experimental and unstable. Future releases may change its behavior or remove it.

Despite the fact that the manifest file structure hasn't changed much and should be mostly backward compatible, there are some minor changes with the flags; for example, the short version of the `--template` flag has changed from `-T` to `-t`.

This new version of the Toolbox has therefore been released as a major version bump and we don't guarantee full backwards compatibility.

Take a look at the `--help` screen for the `new` command to see all the available flags and options.

## Wrapping up

The new Vapor Toolbox is available via Homebrew on macOS and Linux or can be compiled from source by cloning the GitHub repository and using the `Makefile` to install it.
You can find all the instructions on how to install it in the Toolbox's [README](https://github.com/vapor/toolbox/blob/main/README.md). There you'll also find instructions on how to create your own custom templates.

Toolbox templates are very powerful, and they can be used to scaffold any kind of project, not just Vapor ones.
If you have a kind of project that you find yourself creating over and over again, consider creating a Toolbox template for it!

Right now, the official Vapor template is using only the tip of the iceberg feature-wise, but with the new functionality added to the Toolbox in this rewrite we can add more features and improvements to it, so expect some updates soon!