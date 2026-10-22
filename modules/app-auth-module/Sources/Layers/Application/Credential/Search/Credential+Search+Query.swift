public import AuthModule

extension Credential.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query, userId: String?) async throws
                -> Output
        }
    }
}
