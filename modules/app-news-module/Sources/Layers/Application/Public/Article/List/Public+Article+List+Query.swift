import NewsModule

extension Public.Article.List {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublic(
                query: Input.Query
            ) async throws -> Output
            func countPublic(categoryID: String?) async throws -> Int
        }
    }
}
