import Plot
import VaporDesign
import Publish
import Foundation

struct TagsPage: Component {
    let selectedTag: Tag?
    let pageNumber: Int
    let items: [Item<Blog>]
    let context: PublishingContext<Blog>
    
    @ComponentBuilder
    var body: Component {
        SiteNavigation(context: context, selectedSelectionID: nil, currentSite: .blog, currentMainSitePage: nil)
        Div {
            H1("Explore Vapor’s articles by tags").class("vapor-blog-page-heading")
            
            Div {
                Div {
                    let tags = context.allTags
                    let allPosts = context.allItems(sortedBy: \.title)
                    let tagsWithPostCount = tags.map { tag in
                        let postCount = allPosts.filter { $0.tags.contains(tag) }.count
                        return TagWithPostCount(tag: tag, postCount: postCount)
                    }
                    let selectedTagWithCount: TagWithPostCount?
                    if let selectedTag {
                        selectedTagWithCount = tagsWithPostCount.first { $0.tag == selectedTag }
                    } else {
                        selectedTagWithCount = nil
                    }
                    return ComponentGroup(BlogTagList(tags: tagsWithPostCount, site: context.site, selectedTag: selectedTagWithCount, totalPosts: allPosts.count))
                }.class("col-lg-3 mb-4")
                Div {
                    Div {
                        for item in items {
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
                    }.class("row row-cols-1 g-4")
                }.class("col")
            }.class("row mb-5")
            
            if let selectedTag {
                Pagination(activePage: pageNumber, numberOfPages: context.paginatedItems(for: selectedTag).count, pageURL: { pageNumber in
                    context.site.paginatedPath(for: selectedTag, pageIndex: pageNumber - 1).absoluteString
                })
            } else {
                Pagination(activePage: pageNumber, numberOfPages: context.paginatedItems.count, pageURL: { pageNumber in
                    context.site.paginatedTagListPath(pageIndex: pageNumber - 1).absoluteString
                })
            }
        }.class("container blog-container")
        SiteFooter(currentSite: .blog)
    }
}
