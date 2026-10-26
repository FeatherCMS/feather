import NewsModule

extension Public.Article.List {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublic(limit: Int) async throws -> Output
        }
    }
}
