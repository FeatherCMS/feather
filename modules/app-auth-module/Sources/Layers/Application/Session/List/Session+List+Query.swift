public import AuthModule

extension Session.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Input.Query) async throws -> Output
        }
    }
}
