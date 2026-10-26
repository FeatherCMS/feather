public import FeatherApplication
import NewsModule

extension Public.Article.Resolve {
    public struct Output: DTO {
        public let items: [Public.Article.Summary.Item]

        public init(items: [Public.Article.Summary.Item]) {
            self.items = items
        }
    }
}
