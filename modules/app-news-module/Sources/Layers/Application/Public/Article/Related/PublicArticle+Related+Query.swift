public import NewsModule

extension PublicNewsArticle.Related {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublicRelated(
                categoryIDs: [String],
                excludingArticleID: String,
                limit: Int
            ) async throws -> Article.List.Output
        }
    }
}
