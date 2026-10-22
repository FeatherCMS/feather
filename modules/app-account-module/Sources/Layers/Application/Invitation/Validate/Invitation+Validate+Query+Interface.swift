public import AccountModule

extension Invitation.Validate.Query {
    public protocol Interface: Sendable {
        func getBy(token: String) async throws -> Invitation.Validate.Output
    }
}
