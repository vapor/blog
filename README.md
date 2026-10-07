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

## License

This repository is dual licensed:

- **Code** — the Swift sources in `Sources/`, the Leaf templates in `Theme/`,
  the scripts in `scripts/`, and `Content/static/css/` — is licensed under the
  [MIT License](LICENSE).
- **Blog posts** — the Markdown files in `Content/posts/` — are licensed under
  [CC BY 4.0](LICENSE-CONTENT).

Not covered by either license: Vapor logos and branding, the author
photographs in `Content/author-images/`, images embedded in posts, and the
assets supplied by the proprietary [`vapor/design`](https://github.com/vapor/design)
package that this site is built with. See [LICENSE-CONTENT](LICENSE-CONTENT)
for the full list. Because of the `vapor/design` dependency, the site cannot
be built or republished in its rendered form without separate permission from
Vapor, even though the code here is MIT licensed.
