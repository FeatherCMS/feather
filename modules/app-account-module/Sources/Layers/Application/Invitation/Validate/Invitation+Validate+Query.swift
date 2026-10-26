public import AccountModule

extension Invitation.Validate {
    public enum Query {
        public protocol Interface: Sendable {
            func find(token: String) async throws -> Output
        }
    }
}
