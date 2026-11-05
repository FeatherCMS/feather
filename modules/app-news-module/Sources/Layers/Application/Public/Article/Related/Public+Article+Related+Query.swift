import NewsModule

extension Public.Article.Related {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublicRelated(
                categoryIDs: [String],
                excludingArticleID: String,
                limit: Int
            ) async throws -> Output
        }
    }
}
