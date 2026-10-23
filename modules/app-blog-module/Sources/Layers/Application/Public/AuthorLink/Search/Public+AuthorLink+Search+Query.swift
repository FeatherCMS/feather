public import BlogModule

extension Public.AuthorLink.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(
                authorId: String,
                query: BlogModule.AuthorLink.Search.Input.Query
            ) async throws -> Output
        }
    }
}
