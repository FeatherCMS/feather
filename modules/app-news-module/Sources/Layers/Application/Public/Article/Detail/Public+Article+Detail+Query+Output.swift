public import FeatherApplication

extension Public.Article.Detail.Query {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
