import FeatherApplication
import NewsModule

extension PublicNewsArticle.Resolve {
    public struct Output: DTO {
        public let items: [PublicNewsArticle.Item]

        public init(items: [PublicNewsArticle.Item]) {
            self.items = items
        }
    }
}
