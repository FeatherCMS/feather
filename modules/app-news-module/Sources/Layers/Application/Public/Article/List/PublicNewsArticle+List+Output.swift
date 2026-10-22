public import FeatherApplication

extension PublicNewsArticle.List {
    public struct Output: DTO {
        public let items: [PublicNewsArticle.Summary.Item]
        public let total: Int
        public let page: Int
        public let pageSize: Int

        public init(
            items: [PublicNewsArticle.Summary.Item],
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
}
