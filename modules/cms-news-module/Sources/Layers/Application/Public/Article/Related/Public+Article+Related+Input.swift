public import FeatherApplication
import NewsModule

extension Public.Article.Related {
    public struct Input: DTO {
        public let categoryIDs: [String]
        public let excludingArticleID: String
        public let limit: Int

        public init(
            categoryIDs: [String],
            excludingArticleID: String,
            limit: Int = 6
        ) {
            self.categoryIDs = categoryIDs
            self.excludingArticleID = excludingArticleID
            self.limit = limit
        }
    }
}
