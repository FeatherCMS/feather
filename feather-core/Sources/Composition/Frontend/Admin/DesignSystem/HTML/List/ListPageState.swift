public struct ListPageState: Sendable, Equatable {
    public let page: Int
    public let pageSize: Int
    public let total: Int

    public init(page: Int, pageSize: Int, total: Int) {
        self.page = page
        self.pageSize = pageSize
        self.total = total
    }

    public var totalPages: Int {
        max(1, (total + pageSize - 1) / pageSize)
    }

    public var isPageOutOfRange: Bool {
        total > 0 && page > totalPages
    }
}
