public import BlogModule

extension Public.Tag.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Tag.Detail.Output
        }
    }
}
