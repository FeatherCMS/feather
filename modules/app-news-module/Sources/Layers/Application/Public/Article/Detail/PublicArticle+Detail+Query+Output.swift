import FeatherApplication
import NewsModule

extension PublicNewsArticle.Detail.Query {
    public struct Output: DTO {
        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
