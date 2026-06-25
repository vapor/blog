import Kiln
import VaporDesignTheme

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
        // Shared header/footer/cards come from the design package as a theme
        // layer; anything in this site's own Theme/ still overrides them.
        sharedLayers: [VaporDesignTheme.directory],
        palette: .autoLightDark(primary: .black, accent: .blue)
    ),
    // Strings the shared design partials read. `siteId` tells them this is the
    // blog so footer/nav links point "home" links here and elsewhere absolute.
    languages: [
        Language(
            .english,
            isDefault: true,
            customStrings: [
                "siteId": "blog",
                "footer.tagline": "Vapor provides a safe, performant and easy to use foundation to build HTTP servers, backends and APIs in Swift.",
                "footer.joinDiscord": "Join our Discord",
                "footer.supporters": "Supporters",
                "footer.frameworkDocs": "Framework Docs",
                "footer.apiDocs": "API Docs",
            ]
        )
    ],
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
        authors: authors
    )
)

try await Kiln.build(
    site,
    contentDirectory: "Content",
    outputDirectory: "site"
)
