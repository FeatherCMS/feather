public import NewsModule

extension PublicNewsArticle.List {
    public enum Query {
        public protocol Interface: Sendable {
            func listPublic(
                query: Article.List.Input.Query,
                categoryID: String?
            ) async throws -> Output
            func countPublic(
                query: Article.List.Input.Query,
                categoryID: String?
            ) async throws -> Int
        }
    }
}
