import Kiln

// The Vapor blog (blog.vapor.codes), built with Kiln.
//
// Posts are the markdown files in `Content/posts/*.md`; Kiln's blog feature
// renders each as a post page (`/posts/<slug>/`), generates the paginated index
// (`/`, `/2/`, …), the tag pages (`/tags/`, `/tags/<slug>/`), and an RSS feed
// (`/feed.rss`). The look comes from a custom theme under `Theme/` that emits
// the shared Vapor design-system markup (served from design.vapor.codes).

let site = KilnSite(
    name: "Vapor",
    // The blog is its own host. Absolute URLs (canonical, og:url, sitemap, feed)
    // are built from this.
    url: "https://blog.vapor.codes",
    description: "Articles, tools and resources for Vapor developers.",
    // Default OpenGraph/Twitter preview image, used for any post without its own
    // `image:` front matter. Site-relative to the content directory.
    image: "static/images/opengraph/blog-og.png",
    twitterSite: "@codevapor",
    organization: .init(
        name: "Vapor",
        url: "https://www.vapor.codes",
        logo: "https://design.vapor.codes/favicons/apple-touch-icon.png",
        sameAs: [
            "https://twitter.com/codevapor",
            "https://hachyderm.io/@codevapor",
            "https://bsky.app/profile/vapor.codes",
            "https://github.com/vapor",
        ]
    ),
    copyright: "© QuTheory, LLC 2026",
    theme: .custom(
        directory: "Theme",
        palette: .autoLightDark(primary: .black, accent: .blue)
    ),
    // Posts don't show the permalink "#" anchor next to headings (headings keep
    // their ids, so direct #fragment links still work).
    markdown: MarkdownExtensions(tableOfContents: .init(permalink: false)),
    // The design system ships all blog styling; AI/agent output isn't generated
    // for the blog (it's nav-driven, and the blog has no navigation tree).
    llmsText: false,
    blog: Blog(
        postsPerPage: 8,
        feedTitle: "The Vapor Blog",
        feedDescription: "Articles, tools and resources for Vapor developers.",
        indexTitle: "Articles, tools & resources for Vapor devs",
        tagsTitle: "Explore Vapor's articles by tags",
        // Author registry. Posts reference an author by `username` (matched
        // case-insensitively) in their `author:` / `authors:` front matter, e.g.
        // `author: tim`; legacy `author: Tim` still resolves. Add `url:` (a
        // profile page) and `sameAs:` (social profiles) to strengthen authorship
        // signals — they produce a linked byline and JSON-LD `Person` url/sameAs:
        //   Author(username: "tim", name: "Tim", imageURL: "/author-images/tim.jpg",
        //          url: "https://...", sameAs: ["https://github.com/...", ...])
        authors: authors
    )
)

try await Kiln.build(
    site,
    contentDirectory: "Content",
    outputDirectory: "site"
)
