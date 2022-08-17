import Publish

extension Blog {
    func paginatedPath(for tag: Tag, pageIndex: Int) -> Path {
        guard pageIndex != 0 else { return self.path(for: tag) }
        return self.path(for: tag).appendingComponent("\(pageIndex + 1)")
    }

    func paginatedTagListPath(pageIndex: Int) -> Path {
        guard pageIndex != 0 else { return tagListPath }
        return tagListPath.appendingComponent("\(pageIndex + 1)")
    }
}
