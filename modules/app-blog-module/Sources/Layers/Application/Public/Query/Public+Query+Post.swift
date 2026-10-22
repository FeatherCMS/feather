public import BlogModule

extension Public.Query {
    public enum PostContent {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Post.Detail.Output
            func list(query: Post.Search.Input.Query) async throws
                -> Post.List.Output
        }
    }
}
