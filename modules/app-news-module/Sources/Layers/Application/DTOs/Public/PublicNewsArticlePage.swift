public import FeatherApplication

public struct PublicNewsArticlePage: DTO {
    public let items: [PublicNewsArticleSummary]
    public let total: Int
    public let page: Int
    public let pageSize: Int

    public init(
        items: [PublicNewsArticleSummary],
        total: Int,
        page: Int,
        pageSize: Int
    ) {
        self.items = items
        self.total = total
        self.page = page
        self.pageSize = pageSize
    }
}
