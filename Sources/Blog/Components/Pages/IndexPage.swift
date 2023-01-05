import Publish
import Plot
import Foundation

struct IndexPage: Component {
    /// The page number this page represents
    let pageNumber: Int
    /// The items this page should list
    let items: [Item<Blog>]
    let context: PublishingContext<Blog>

    @ComponentBuilder
    var body: Component {
        H1(context.index.title)
        Paragraph(context.site.description)
            .class("description")
        H2("Latest content")

        ItemList(items: items, site: context.site)

        PaginationList(
            numberOfPages: context.paginatedItems.count,
            activePage: pageNumber,
            pageURL: { context.index.paginatedPath(pageIndex: $0 - 1).absoluteString }
        )
    }
}
