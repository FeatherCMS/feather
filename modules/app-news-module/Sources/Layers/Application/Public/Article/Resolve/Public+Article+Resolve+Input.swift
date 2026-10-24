public import FeatherApplication
import NewsModule

extension Public.Article.Resolve {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
