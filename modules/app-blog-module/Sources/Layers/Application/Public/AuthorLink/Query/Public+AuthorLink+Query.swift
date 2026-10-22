public import BlogModule

extension Public {
    public enum AuthorLink {}
}

extension Public.AuthorLink {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> AuthorLink.Detail.Output
            func list(
                authorId: String,
                query: AuthorLink.Search.Input.Query
            ) async throws -> AuthorLink.List.Output
            func count(
                authorId: String,
                query: AuthorLink.Search.Input.Query
            ) async throws -> Int
        }
    }
}
