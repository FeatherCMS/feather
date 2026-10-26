import NewsModule

extension Public.Article.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(ids: [String]) async throws -> Output
        }
    }
}
