import NewsModule

extension Public.Article.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func searchPublic(query: Input.Query) async throws -> Output
            func countPublic(search: String?) async throws -> Int
        }
    }
}
