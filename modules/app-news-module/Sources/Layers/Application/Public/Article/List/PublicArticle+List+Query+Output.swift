import FeatherApplication
import NewsModule

extension PublicNewsArticle.List.Query {
    public struct Output: DTO {
        public let items: [PublicNewsArticle.Item]

        public init(items: [PublicNewsArticle.Item]) {
            self.items = items
        }
    }
}
