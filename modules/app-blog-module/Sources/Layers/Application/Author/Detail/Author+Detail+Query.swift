public import BlogModule

extension Author.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
