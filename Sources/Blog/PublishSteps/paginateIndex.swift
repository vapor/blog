import Publish

extension PublishingStep where Site == Blog {
    static func generatePaginatedIndexPages() -> Self {
        .step(named: "Add paginated index pages") { context in
            let paginatedItems = context.allPaginatedItems(
                sortedBy: \.date,
                order: .descending
            )

            // dropFirst to avoid a duplicated Page 1 (Publish already added the first, original, index page)
            paginatedItems.dropFirst().indices.forEach { pageIndex in
                context.addPage(
                    Page(
                        path: context.index.paginatedPath(pageIndex: pageIndex),
                        content: .init(body: .init(components: {
                            PaginatedIndexPage(
                                activePageIndex: pageIndex,
                                context: context
                            )
                        }))
                    )
                )
            }
        }
    }
}
