public import BlogModule

extension AuthorLink.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(
                authorId: String,
                query: Input.Query
            ) async throws -> Output
        }
    }
}
