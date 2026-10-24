public import NewsModule

extension Public.Article.List {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublic(
                query: Article.List.Input.Query,
                categoryID: String?
            ) async throws -> Output
            func countPublic(
                query: Article.Search.Input.Query,
                categoryID: String?
            ) async throws -> Int
        }
    }
}
