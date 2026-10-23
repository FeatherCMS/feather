public import AuthModule

extension Session.ListByIdentity {
    public enum Query {
        public protocol Interface: Sendable {
            func list(identityId: String) async throws
                -> Session.ListByIdentity.Output
        }
    }
}
