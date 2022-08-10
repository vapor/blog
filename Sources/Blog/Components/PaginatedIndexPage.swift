import Publish
import Plot
import Foundation

struct PaginatedIndexPage: Component {
    let activePageIndex: Int
    let context: PublishingContext<Blog>

    @ComponentBuilder
    var body: Component {
        H1(context.index.title)
        Paragraph(context.site.description)
            .class("description")
        H2("Latest content")

        let paginatedItems = context.allPaginatedItems(
            sortedBy: \.date,
            order: .descending
        )

        ItemList(
            items: paginatedItems[activePageIndex],
            site: context.site,
            dateFormatter: .dayMonthYear
        )

        List(paginatedItems.indices) { pageIndex in
            var linkText = "\(pageIndex + 1)"
            if pageIndex == self.activePageIndex {
                linkText = "[\(linkText)]"
            }
            return ListItem {
                Link(linkText, url: context.index.paginatedPath(pageIndex: pageIndex).absoluteString)
            }
            .class("tag")
        }
        .class("all-tags")
        .style("text-align:center;")
    }
}
