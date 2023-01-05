import Foundation
import Publish
import Plot
import ReadingTimePublishPlugin

// This type acts as the configuration for your website.
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var author: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://blog.vapor.codes")!
    var name = "The Vapor Blog"
    var description = "Welcome to the blog of Vapor, the Swift HTTP/Web Framework"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var favicon: Favicon? {
        Favicon(path: "/favicon.ico", type: "image/x-icon")
    }
}

try Blog().publish(using: [
    .optional(.copyResources()),
    .addMarkdownFiles(),
    .installPlugin(.readingTime()),
    .sortItems(by: \.date, order: .descending),
    .group([.generatePaginatedPages()]),
    .generateHTML(withTheme: .vaporBlog),
    .generateRSSFeed(including: Set(Blog.SectionID.allCases)),
    .generateSiteMap(),
])
