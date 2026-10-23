public import AccountModule

extension Invitation.Validate {
    public enum Query {
        public protocol Interface: Sendable {
            func getBy(token: String) async throws -> Output
        }
    }
}
