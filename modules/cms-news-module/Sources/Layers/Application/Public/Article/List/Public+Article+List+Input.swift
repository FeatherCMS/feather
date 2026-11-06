public import FeatherApplication
import NewsModule

extension Public.Article.List {
    public struct Input: DTO {
        public let limit: Int

        public init(limit: Int = 10000) {
            self.limit = limit
        }
    }
}
