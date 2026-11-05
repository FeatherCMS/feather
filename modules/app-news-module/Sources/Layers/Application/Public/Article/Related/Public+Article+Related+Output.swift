public import FeatherApplication
import NewsModule

extension Public.Article.Related {
    public struct Output: DTO {
        public let items: [Public.Article.Summary.Item]

        public init(items: [Public.Article.Summary.Item]) {
            self.items = items
        }
    }
}
