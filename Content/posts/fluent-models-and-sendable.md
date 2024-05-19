---
date: 2024-05-19 11:00
description: The situation with Fluent Models and Sendable warnings
tags: fluent, concurrency, warnings, vapor
author: Gwynne
authorImageURL: /author-images/gwynne.jpg
---
# On Fluent Models and Sendable warnings

Many users have noticed that since [the release of FluentKit 1.48.0](https://github.com/vapor/fluent-kit/releases/tag/1.48.0) almost a month ago, every one of their `Model` types is afflicted by a new warning:

> `Stored property '_id' of 'Sendable'-conforming class 'SomeModel' is mutable`

The TL;DR version: There's a corner case in Swift when property wrappers are used by `class`es that makes it impossible to satisfy `Sendable`'s requirements, but Fluent has to require `Sendable` models in order to satify those requirements itself. Users can and should suppress the warning by adding `@unchecked Sendable` conformance to each individual type conforming to `Model`, `ModelAlias`, `Schema` or `Fields`, as in the following example:

```swift
import Fluent

// ****** BEFORE: ******
final class SomeModel: Model {
// ****** AFTER: ******
final class SomeModel: Model, @unchecked Sendable {
    static let schema = "some_models"
    
    @ID
    var id: UUID?
    
    // ...
}
```

And that's pretty much all there is to it. For those who are interested, the remainder of this post gives some more detail on how things ended up like this.

## It's The Property Wrappers&rsquo; World, You're Just Living In It

A number of factors are involved in the problem and this being the chosen solution. Here's a mostly complete list:

- The Fluent property wrappers all have setters for their `wrappedValue` properties, which are critical to the ability to set values on a model. As a result, variables using any of the wrappers must themselves be mutable. Even if there was another way to input values for a model to the database, the setters couldn't be removed without breaking source compatibility completely.
- Fluent models are reference types (`class`es). This is also something that can't be changed short of major and backwards-incompatible changes to the API (and to a lot of Fluent's guts).
- Mutable properties in reference types can't be validated as `Sendable`-compliant by the compiler. Even if they are safe in reality - for example, if the properties are protected by a lock at runtime - there's no way for the compiler to figure that out. The `@unchecked Sendable` escape hatch is intended for that case.
- Protocols like `Model` can require `Sendable` compliance on all types conforming to them, but they can _not_ confer the `@unchecked Sendable` escape hatch on conforming types. So as nice as it would be for Fluent to apply it automatically, the language doesn't allow for it.
- It's also not viable to just leave out the `Sendable` requirement for models completely - for various reasons which boil down to "the guts of Fluent aren't built very well but we can't really fix it", non-`Sendable` models make it impossible to make the rest of Fluent `Sendable`-safe.
- Placing `@unchecked Sendable` on models is, unfortunately, lying to the compiler - the models are not _really_ `Sendable`-safe in practice. This is considered acceptable because models have _never_ been thread-safe- and also because when making them generically thread-safe was tried, it turned out to incur such severe performance penalties that Fluent became completely unusable. But there _are_ parts of Fluent which were previously "safe" (or at least, safe enough) which become unsafe with Concurrency in use, so simply leaving Fluent the way it was wasn't an option either.
- Last, but not least, one might ask why it's advised to apply `@unchecked Sendable` instead of, say, `@preconcurrency import Fluent`. There are three reasons for this:
  1. `@preconcurrency` would disable _all_ `Sendable` checking related to Fluent APIs, which is drastic overkill at best (and just a bad idea in general).
  2. Nearly none of Fluent's API actually lives in the `Fluent` package, but rather in the `FluentKit` package, with the latter (the actual implemenation of Fluent) being `@_exported` from the former (the Fluent provider for Vapor integration). `@_exported`, among myriad other problems, has ill-defined semantics, including whether or not an attribute like `@preconcurrency` applies transitively to imports. In testing, the results turned out to be unpredictable. In short, `@preconcurrency import Fluent` doesn't always work.
  3. Removing `@_exported` from Fluent would be yet another source compatibility break.

So bascially, at the end of day, it's all a kludge, but it was the best choice out of a bunch of bad options. Even the Swift core team was helpless to suggest anything better when I brought the problem to them. I promise to fix it for real in Fluent 5!

P.S.: Speaking of Fluent 5, stay tuned for updates on that subject in the near future 😶