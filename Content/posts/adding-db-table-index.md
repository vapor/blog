---
date: 2022-05-11 12:55
description: See how to add a database table index using SQLKit
tags: tips, Fluent
author: Tim
authorImageURL: /author-images/tim.jpg
---
# Adding a database table index

A common question that pops up is how to add a database table index when creating a table or adding a migration. Fluent doesn't natively support this (yet) due to complications with making it work across all supported databases.

However, it's easy enough to do by dropping down to SQLKit in a migration:

```swift
struct CreateTodoTitleIndex: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await (database as! SQLDatabase)
            .create(index: "todo_index")
            .on("todos")
            .column("title")
            .run()
    }

    func revert(on database: Database) async throws {
        try await (database as! SQLDatabase)
            .drop(index: "todo_index")
            .run()
    }
}
```

This creates an index called `todo_index` on the table named `todos` for the column `title`. 

> Note: this code example is for Postgres. For MySQL you need to pass the table name to the statement when reverting with `.on("todos")`
