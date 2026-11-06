public import FeatherApplication
import NewsModule

extension Public.Article.Search {
    public struct Output: DTO {
        public let items: [Public.Article.Summary.Item]
        public let total: Int
        public let page: Int
        public let pageSize: Int

        public init(
            items: [Public.Article.Summary.Item],
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
