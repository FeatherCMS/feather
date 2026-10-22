public import BlogModule

extension Public.AuthorLink.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(
                authorId: String,
                query: AuthorLink.Search.Input.Query
            ) async throws -> AuthorLink.List.Output
        }
    }
}
