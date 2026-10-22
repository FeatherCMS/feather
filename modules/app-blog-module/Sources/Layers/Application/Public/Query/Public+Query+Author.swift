public import BlogModule

extension Public.Query {
    public enum AuthorContent {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Author.Detail.Output
            func list(query: Author.Search.Input.Query) async throws
                -> Author.Search.Output
        }
    }
}
