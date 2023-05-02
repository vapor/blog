---
date: 2023-04-30 12:00
description: You may notice some changes in Vapor's templates - we've updated then for Swift 5.8, with a unified target and using the latest `@main` syntax.
tags: templates
authors: Tim; Gwynne
authorImageURLs: /author-images/tim.jpg; /author-images/gwynne.jpg
---
# Updating Vapor's Templates for Swift 5.8

If you've run `vapor new` recently, you may have noticed some changes to the templates. We've updated them for Swift 5.8, with a unified target and using the latest `@main` syntax.

## Swift 5.8 and a Unified Target

The template now has a minimum supported Swift version of 5.8 to allow you to easily use the latest Swift features. The `Dockerfile` has been updated to use Swift 5.8 as well, so deploying should be as easy as ever.

Swift 5.3 (yes, believe it or not it was that long ago) introduced the `@main` syntax for defining the entry point of your application. This allows you to annotate any type as the entry point of your application. Swift 5.5 then finally made it possible to run unit tests for an `.executableTarget` in a SwiftPM package, removing the need for the separate `Run` target Vapor traditionally used.

We held off migrating to this new syntax partly for backwards compatibility, to avoid breaking all the tutorials, books, and examples out there, and because there wasn't a clear reason to migrate. Now that Vapor supports Swift Concurrency, we need to start planning on how to support asynchronous setup functions and commands for your apps. This change takes the first step in that direction by moving to an `async` entry point.

## The Toolbox and Documentation

Vapor's toolbox was built in a time when Swift Package Manager wasn't nearly as capable as it was today. We had to pass `--enable-test-discovery` flags to all `swift build`, `swift test` and `swift run` commands to make your code run. We also had old commands for making it easy to setup Heroku, Vapor Cloud, `supervisord` etc., when deploying your app wasn't as easy as it is today.

These commands have been discouraged for a while now; the toolbox is really best used only for generating new projects. We've now updated all the documentation to reflect this, and the commands in the toolbox - except `vapor new`, of course - all have deprecation warnings. We've also updated the toolbox to detect whether your app has the old `Run` executable target or the new `App` executable target and use the right one.

If you're still relying on the toolbox to build, test, or run your app, you should migrate to using Swift Package Manager commands directly. However, there is a new [toolbox release](https://github.com/vapor/toolbox/releases/tag/18.7.0) for those that need it. As ever, if you encounter any issues, either running your applications or with the documentation, please let us know on [GitHub](https://github.com/vapor/vapor/issues) or [Discord](https://discord.gg/vapor).

## Future Changes

There is still a bit of work to do to properly support fully asynchronous entry points. There are some underlying changes in Vapor's old blocking `Application.run()` method we're currently working on around in order to avoid the temporary `runFromAsyncMainEntrypoint()` workaround the new template is using. Once we've solved this, we'll update the templates again to remove the workaround.

For now, enjoy building with asynchronous `configure()` functions!