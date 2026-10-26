import BlogModule

extension Public.Post.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
            func findAuthor(id: String) async throws -> Author
            func findTag(id: String) async throws -> Tag
        }
    }
}
