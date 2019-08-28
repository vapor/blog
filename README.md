# Vapor Blog

This is the official code repository for the Vapor Blog.

## Creating a new blog post

Make sure you have the gohugo CLI installed locally.

MacOS:

```
brew install hugo
```

Linux:

```
snap install hugo
```

### Creating file

Clone this repository locally:

```
git clone git@github.com:qutheory/vapor-blog.git
cd vapor-blog
```

Now create the file

```
hugo new articles/my-blog-post-title.md
```

You can now edit the file `articles/my-blog-post-title.md`

### Spin up local server

To spin up the project locally run

```
hugo server
```
You can now access http://localhost:1313/