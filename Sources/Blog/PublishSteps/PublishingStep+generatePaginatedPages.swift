import Publish

extension PublishingStep where Site == Blog {
    static func generatePaginatedPages() -> Self {
        .group([
            .generatePaginatedIndexPages(),
            .generatePaginatedTagPages(),
            .generatePaginatedTagListPages()
        ])
    }

    private static func generatePaginatedIndexPages() -> Self {
        .step(named: "Generate paginated index pages") { context in
            // dropFirst to avoid a duplicated Page 1 (Publish already added the first, original, index page)
            context.paginatedItems.indices.dropFirst().forEach { pageIndex in
                context.addPage(
                    Page(
                        path: context.index.paginatedPath(pageIndex: pageIndex),
                        content: .init(title: context.index.title, description: context.index.description, body: .init(components: {
                            IndexPage(
                                pageNumber: pageIndex + 1,
                                context: context
                            )
                        }), date: context.index.date, lastModified: context.index.lastModified, imagePath: context.index.imagePath)
                    )
                )
            }
        }
    }

    private static func generatePaginatedTagPages() -> Self {
        .step(named: "Generate paginated tag pages") { context in
            context.allTags.forEach { tag in
                context.paginatedItems(for: tag).indices.dropFirst().forEach { pageIndex in
                    context.addPage(
                        Page(
                            path: context.site.paginatedPath(for: tag, pageIndex: pageIndex),
                            content: .init(title: "Blog Tags", description: "Tags for the Vapor Blog", body: .init(components: {
                                TagsPage(
                                    selectedTag: tag,
                                    pageNumber: pageIndex + 1,
                                    items: context.paginatedItems(for: tag)[pageIndex],
                                    context: context
                                )
                            }))
                        )
                    )
                }
            }

        }
    }

    private static func generatePaginatedTagListPages() -> Self {
        .step(named: "Generate paginated tag list page") { context in
            context.paginatedItems.indices.dropFirst().forEach { pageIndex in
                context.addPage(
                    Page(
                        path: context.site.paginatedTagListPath(pageIndex: pageIndex),
                        content: .init(title: "Blog Tags", description: "Tags for the Vapor Blog", body: .init(components: {
                            TagsPage(
                                selectedTag: nil,
                                pageNumber: pageIndex + 1,
                                items: context.paginatedItems[pageIndex],
                                context: context
                            )
                        }))
                    )
                )
            }
        }
    }
}
