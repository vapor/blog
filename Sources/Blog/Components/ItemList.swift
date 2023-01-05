import Plot
import Publish
import Foundation

struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site
    
    var body: Component {
        
        List(items) { item in
            Article {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = item.date.dateFormatWithSuffix()
                return ComponentGroup {
                    H1(Link(item.title, url: item.path.absoluteString))
                    Div(dateFormatter.string(from: item.date)).class("post-date")
                    ItemTagList(item: item, site: site)
                    Paragraph(item.description)
                }
            }
        }
        .class("item-list")
    }
}
