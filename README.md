# Vapor Blog

This is the official code repository for the Vapor Blog.

## Install Publish

Make sure you have publish installed:

```bash
brew install publish
```

## Creating a new blog post

Open the Swift Package:

```bash
open Package.swift
```

### Creating file

Now create the file in `Content/posts/my-blog-post-title` and add the new content. Run the Swift Package to generate the new content.

### Spin up local server

To spin up the project locally run

```
publish run
```

You can now access http://localhost:8000/