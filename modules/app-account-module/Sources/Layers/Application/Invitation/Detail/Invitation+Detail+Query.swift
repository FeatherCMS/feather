public import AccountModule


extension Invitation.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func getBy(id: String) async throws -> Output
        }
    }
}
