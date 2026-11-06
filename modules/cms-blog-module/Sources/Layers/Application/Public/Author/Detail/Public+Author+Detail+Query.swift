import BlogModule

extension Public.Author.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
            func links(authorID: String) async throws -> [Link]
            func posts(authorID: String) async throws -> [Post]
        }
    }
}
