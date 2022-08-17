import Publish

extension PublishingContext where Site == Blog {
    var paginatedItems: [[Item<Blog>]] {
        allItems(sortedBy: \.date, order: .descending).chunked(into: Constants.numberOfItemsPerIndexPage)
    }

    func paginatedItems(for tag: Tag) -> [[Item<Blog>]] {
        items(taggedWith: tag, sortedBy: \.date, order: .descending).chunked(into: Constants.numberOfItemsPerTagsPage)
    }
}
