import BlogModule

extension Public.Post.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
            func relatedCandidates(excludingID id: String) async throws
                -> [Output]
            func findAuthor(id: String) async throws -> Author
            func findTag(id: String) async throws -> Tag
        }
    }
}
