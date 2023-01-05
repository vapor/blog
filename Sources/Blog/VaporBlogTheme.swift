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
        buildIndexPage(page: index, context: context)
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        buildIndexPage(page: section, context: context)
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        let currentSite: CurrentSite = .blog
        #warning("Fix")
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
        let body: Node<HTML.DocumentContext> = .body {
            SiteNavigation(context: context, selectedSelectionID: nil, currentSite: .blog, currentMainSitePage: nil)
            Div {
                page.body
            }.class("container vapor-container")
            SiteFooter(currentSite: .blog)
        }
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: page, context: context, body: body)
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
    
    func buildIndexPage(page: Location, context: PublishingContext<Site>) -> HTML {
        let currentSite: CurrentSite = .blog
        let body: Node<HTML.DocumentContext> = .body {
            SiteNavigation(context: context, selectedSelectionID: nil, currentSite: .blog, currentMainSitePage: nil)
            Div {
                H1("Articles, tools & resources for Vapor devs").class("vapor-blog-page-heading")
                
                Div {
                    for item in context.paginatedItems.first ?? [] {
                        Div {
                            #warning("Fix")
                            let authorImageURL = "https://design.vapor.codes/images/author-image-placeholder.png"
                            let publishDate = DateFormatter.short.string(from: item.date)
                            let blogPostData = BlogPostExtraData(length: "\(item.readingTime.minutes) minutes read", author: .init(name: item.metadata.author, imageURL: authorImageURL), publishedDate: publishDate)
                            BlogCard(blogPostData: blogPostData, item: item, site: context.site)
                        }.class("col")
                    }
                }.class("row row-cols-1 row-cols-lg-2 g-4 mb-5")
                
                Pagination(activePage: 1, numberOfPages: context.paginatedItems.count, pageURL: { pageNumber in
                    context.index.paginatedPath(pageIndex: pageNumber - 1).absoluteString
                })
            }.class("container blog-container")
            SiteFooter(currentSite: currentSite)
        }
        
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: page, context: context, body: body)
    }
    
    func buildHead(for page: Location, context: PublishingContext<Blog>) -> Node<HTML.DocumentContext> {
            .head(for: page, on: context.site, stylesheetPaths: [
                "/static/styles/styles.css",
                "/static/styles/syntax.css"
            ])
        }
}
