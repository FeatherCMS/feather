public import BlogModule

extension Public.Author.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Author.Search.Input.Query) async throws
                -> Author.Search.Output
        }
    }
}
