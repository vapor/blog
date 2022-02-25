---
date: 2022-02-22 10:22
description: We're updating Vapor's template to use async/await
tags: template, async/await
author: Tim
---
# Updating Vapor's Template To Use `async`/`await`

Today we're updating [Vapor's template](https://github.com/vapor/template) to use `async`/`await`. This will make your code cleaner and easier to maintain and also brings the template in line with the docs, where `async`/`await` is standard. This also removes the need to update your project so that you can use the new concurrency features and get going straight away.

## Sticking to `EventLoopFuture`s

The downside to the update is that it requires macOS 12. We know that not everyone is able to update their machines to macOS 12 to there's a `macos10-15` branch you can use for new  projects:

```bash
vapor new MyProject --branch macos10-15
```

Happy coding!
