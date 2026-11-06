public import AuthModule

extension Session.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(
                identityId: String,
                query: Input.Query
            ) async throws -> Output
        }
    }
}
