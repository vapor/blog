import Plot
import Publish
import Foundation

struct PaginationList: Component {
    let numberOfPages: Int
    let activePage: Int
    let pageURL: (_ pageNumber: Int) -> String

    var body: Component {
        List(1...numberOfPages) { pageNumber in
            var linkText = "\(pageNumber)"
            if pageNumber == activePage {
                linkText = "[\(linkText)]"
            }
            return ListItem {
                Link(linkText, url: pageURL(pageNumber))
            }
            .class("tag")
        }
        .class("all-tags")
        .style("text-align:center;")
    }
}
