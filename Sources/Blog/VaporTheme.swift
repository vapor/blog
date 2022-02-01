import Plot
import Publish

extension Theme where Site == Blog {
    static var vapor: Self {
        Theme(htmlFactory: VaporThemeHTMLFactory())
    }
}

private struct VaporThemeHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Blog>) throws -> HTML {
        <#code#>
    }
    
    func makeSectionHTML(for section: Section<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        <#code#>
    }
    
    func makeItemHTML(for item: Item<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        <#code#>
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Blog>) throws -> HTML {
        <#code#>
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Blog>) throws -> HTML? {
        <#code#>
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Blog>) throws -> HTML? {
        <#code#>
    }
    
    
    typealias Site = Blog
    
}
