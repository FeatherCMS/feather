public import FeatherApplication
import NewsModule

extension Public.Article.List {
    public struct Output: DTO {
        public let items: [Public.Article.Summary.Item]

        public init(items: [Public.Article.Summary.Item]) {
            self.items = items
        }
    }
}
