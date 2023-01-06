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
        let authorImageURL = item.metadata.authorImageURL ?? "https://design.vapor.codes/images/author-image-placeholder.png"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = item.date.dateFormatWithSuffix()
        let publishDate = dateFormatter.string(from: item.date)
        let readingText: String
        if item.readingTime.minutes == 1 {
            readingText = "minute read"
        } else {
            readingText = "minutes read"
        }
        let blogPostData = BlogPostExtraData(length: "\(item.readingTime.minutes) \(readingText)", author: .init(name: item.metadata.author, imageURL: authorImageURL), publishedDate: publishDate)
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
            if page.title == "Error 404 - Page not found" {
                SiteNavigation(context: context, selectedSelectionID: nil, currentSite: .blog, currentMainSitePage: nil)
                Div {
                    page.body
                }.class("container vapor-container")
                SiteFooter(currentSite: .blog)
            } else {
                page.body
            }
        }
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: page, context: context, body: body)
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        let body: Node<HTML.DocumentContext> = .body {
            TagsPage(selectedTag: nil, pageNumber: 1, items: context.paginatedItems.first ?? [], context: context)
        }
        
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: page, context: context, body: body)
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        let body: Node<HTML.DocumentContext> = .body {
            TagsPage(selectedTag: page.tag, pageNumber: 1, items: context.paginatedItems(for: page.tag).first ?? [], context: context)
        }
        
        let builder = VaporDesign<Site>(siteLanguage: context.site.language)
        return builder.buildHTML(for: page, context: context, body: body)
    }
    
    func buildIndexPage(page: Location, context: PublishingContext<Site>) -> HTML {
        let body: Node<HTML.DocumentContext> = .body {
            IndexPage(pageNumber: 1, context: context)
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
