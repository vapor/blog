import Plot
import Publish
import Foundation

struct TagsPage: Component {
    let selectedTag: Tag?
    let pageNumber: Int
    let items: [Item<Blog>]
    let context: PublishingContext<Blog>

    @ComponentBuilder
    var body: Component {
        H1("Blog tags")
        List(context.allTagLinks) { tagLink in
            var name = tagLink.name
            if tagLink.name == selectedTag?.string ||
                (tagLink.path == context.site.tagListPath && selectedTag == nil) {
                name = "[ " + name + " ]"
            }
            return ListItem {
                Link(name, url: tagLink.path.absoluteString)
            }
            .class("tag")
        }
        .class("all-tags")
        .class("browse-all")

        ItemList(
            items: items,
            site: context.site,
            dateFormatter: .dayMonthYear
        )

        if let selectedTag = selectedTag {
            PaginationList(
                numberOfPages: context.paginatedItems(for: selectedTag).count,
                activePage: pageNumber,
                pageURL: { context.site.paginatedPath(for: selectedTag, pageIndex: $0 - 1).absoluteString }
            )
        } else {
            PaginationList(
                numberOfPages: context.paginatedItems.count,
                activePage: pageNumber,
                pageURL: { context.site.paginatedTagListPath(pageIndex: $0 - 1).absoluteString }
            )
        }
    }
}

extension TagsPage {
    struct TagLink {
        var name: String
        var path: Path
    }
}

extension PublishingContext where Site == Blog {
    var allTagLinks: [TagsPage.TagLink] {
        var tagLinks = [TagsPage.TagLink(name: "View all", path: site.tagListPath)]
        tagLinks.append(contentsOf: allTags.sorted().map { .init(name: $0.string, path: site.path(for: $0)) })
        return tagLinks
    }
}
