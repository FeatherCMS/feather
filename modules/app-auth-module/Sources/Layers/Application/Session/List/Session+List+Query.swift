public import AuthModule

extension Session.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(identityId: String) async throws -> Output
        }
    }
}
