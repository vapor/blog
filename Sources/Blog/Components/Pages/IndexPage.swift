import Publish
import Plot
import Foundation
import VaporDesign

struct IndexPage: Component {
    /// The page number this page represents
    let pageNumber: Int
    let context: PublishingContext<Blog>

    @ComponentBuilder
    var body: Component {
        SiteNavigation(context: context, selectedSelectionID: nil, currentSite: .blog, currentMainSitePage: nil)
        Div {
            H1("Articles, tools & resources for Vapor devs").class("vapor-blog-page-heading")
            
            Div {
                for item in context.paginatedItems[pageNumber - 1] {
                    Div {
                        let authors = item.metadata.allAuthors
                        let authorImageURLs = item.metadata.allAuthorImageURLs
                        let publishDate = DateFormatter.short.string(from: item.date)
                        let blogPostData = BlogPostExtraData(
                            length: "\(item.readingTime.minutes) minutes read",
                            author: .init(name: authors[0], imageURL: authorImageURLs[0]),
                            contributingAuthors: zip(authors, authorImageURLs).dropFirst().map { .init(name: $0, imageURL: $1) },
                            publishedDate: publishDate
                        )
                        BlogCard(blogPostData: blogPostData, item: item, site: context.site)
                    }.class("col")
                }
            }.class("row row-cols-1 row-cols-lg-2 g-4 mb-5")
            
            Pagination(activePage: pageNumber, numberOfPages: context.paginatedItems.count, pageURL: { pageNumber in
                context.index.paginatedPath(pageIndex: pageNumber - 1).absoluteString
            })
        }.class("container blog-container")
        SiteFooter(currentSite: .blog)
    }
}
