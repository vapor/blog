import Publish

extension Index {
    func paginatedPath(pageIndex: Int) -> Path {
        guard pageIndex != 0 else { return path }
        return path.appendingComponent("\(pageIndex + 1)")
    }
}
