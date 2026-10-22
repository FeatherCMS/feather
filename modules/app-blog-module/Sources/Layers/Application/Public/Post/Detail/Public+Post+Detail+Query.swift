public import BlogModule

extension Public.Post.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Post.Detail.Output
        }
    }
}
