public import BlogModule

extension Public.Query {
    public enum AuthorLinkContent {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> AuthorLink.Detail.Output
            func list(
                authorId: String,
                query: AuthorLink.Search.Input.Query
            ) async throws -> AuthorLink.List.Output
        }
    }
}
