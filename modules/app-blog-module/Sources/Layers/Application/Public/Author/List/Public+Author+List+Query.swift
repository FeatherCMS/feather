public import BlogModule

extension Public.Author.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: BlogModule.Author.Search.Input.Query) async throws
                -> Output
            func findAuthor(id: String) async throws -> Author
        }
    }
}
