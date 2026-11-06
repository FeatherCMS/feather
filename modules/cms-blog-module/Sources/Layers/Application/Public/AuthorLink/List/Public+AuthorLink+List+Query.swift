import BlogModule

extension Public.AuthorLink.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(authorId: String) async throws -> Output
        }
    }
}
