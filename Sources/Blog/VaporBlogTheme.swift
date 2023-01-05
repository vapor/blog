import Plot
import Publish
import Foundation
import VaporDesign

extension Theme where Site == Blog {
    static var vaporBlog: Self {
        Theme(htmlFactory: VaporBlogThemeHTMLFactory())
    }
}

private struct VaporBlogThemeHTMLFactory: HTMLFactory {
    typealias Site = Blog
    
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            buildHead(for: index, context: context),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    IndexPage(
                        pageNumber: 1,
                        items: context.paginatedItems.first ?? [],
                        context: context
                    )
                }
//                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            buildHead(for: section, context: context),
            .body {
                SiteHeader(context: context, selectedSelectionID: section.id)
                Wrapper {
                    H1(section.title)
                    ItemList(items: section.items, site: context.site)
                }
//                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        let currentSite: CurrentSite = .blog
        let authorImageURL = "https://design.vapor.codes/images/author-image-placeholder.png"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = item.date.dateFormatWithSuffix()
        let publishDate = dateFormatter.string(from: item.date)
        let blogPostData = BlogPostExtraData(length: "\(item.readingTime.minutes) minutes read", author: .init(name: item.metadata.author, imageURL: authorImageURL), publishedDate: publishDate)
        let body: Node<HTML.DocumentContext> = .body {
            SiteNavigation(context: context, selectedSelectionID: item.sectionID, currentSite: .blog, currentMainSitePage: nil)
            BlogPost(blogPostData: blogPostData, item: item, site: context.site)
            SiteFooter(currentSite: currentSite)
        }
        
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: item, context: context, body: body)
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            buildHead(for: page, context: context),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper(page.body)
//                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            buildHead(for: page, context: context),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    TagsPage(
                        selectedTag: nil,
                        pageNumber: 1,
                        items: context.paginatedItems.first ?? [],
                        context: context
                    )
                }
//                SiteFooter()
            }
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            buildHead(for: page, context: context),
            .body {
                SiteHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    TagsPage(
                        selectedTag: page.tag,
                        pageNumber: 1,
                        items: context.paginatedItems(for: page.tag).first ?? [],
                        context: context
                    )
                }
//                SiteFooter()
            }
        )
    }
    
    func buildHead(for page: Location, context: PublishingContext<Blog>) -> Node<HTML.DocumentContext> {
            .head(for: page, on: context.site, stylesheetPaths: [
                "/static/styles/styles.css",
                "/static/styles/syntax.css"
            ])
        }
}
