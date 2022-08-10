import Publish

extension PublishingContext {
    func allPaginatedItems<T: Comparable>(
        sortedBy sortingKeyPath: KeyPath<Item<Site>, T>,
        order: SortOrder = .ascending
    ) -> [[Item<Site>]] {
        allItems(sortedBy: sortingKeyPath, order: order).chunked(into: Constants.numberOfItemsPerIndexPage)
    }
}
