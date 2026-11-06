import NewsModule

extension Public.Article.Search.Query {
    public struct Output: Sendable {
        public let items: [Public.Article.Item]

        public init(items: [Public.Article.Item]) {
            self.items = items
        }
    }
}
