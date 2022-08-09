import Plot
import Publish
import Foundation

struct TagsPage: Component {
    let selectedTag: Tag?
    let context: PublishingContext<Blog>
    let dateFormatter: DateFormatter

    var items: [Item<Blog>] {
        let sortingKeyPath: KeyPath<Item<Blog>, Date> = \.date
        let order: Publish.SortOrder = .descending

        guard let selectedTag = selectedTag else {
            return context.allItems(sortedBy: sortingKeyPath, order: order)
        }

        return context.items(taggedWith: selectedTag, sortedBy: sortingKeyPath, order: order)
    }

    @ComponentBuilder
    var body: Component {
        SiteHeader(context: context, selectedSelectionID: nil)
        Wrapper {
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
                dateFormatter: dateFormatter
            )
        }
        SiteFooter()
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
