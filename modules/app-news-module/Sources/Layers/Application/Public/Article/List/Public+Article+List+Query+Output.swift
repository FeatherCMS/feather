public import FeatherApplication
import NewsModule

extension Public.Article.List.Query {
    public struct Output: DTO {
        public let items: [Public.Article.Item]

        public init(items: [Public.Article.Item]) {
            self.items = items
        }
    }
}
