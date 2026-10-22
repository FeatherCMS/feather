public import BlogModule

extension Public.Post.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Post.Search.Input.Query) async throws
                -> Post.List.Output
        }
    }
}
