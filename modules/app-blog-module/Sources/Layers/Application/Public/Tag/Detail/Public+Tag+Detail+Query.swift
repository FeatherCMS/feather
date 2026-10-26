import BlogModule

extension Public.Tag.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
            func posts(tagID: String) async throws -> [Post]
        }
    }
}
