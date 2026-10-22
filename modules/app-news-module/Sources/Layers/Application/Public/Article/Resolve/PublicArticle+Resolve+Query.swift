public import NewsModule

extension PublicNewsArticle.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(ids: [String]) async throws -> Article.List.Output
        }
    }
}
