public import AccountModule

extension Invitation.List.Query {
    public protocol Interface: Sendable {
        func list() async throws -> Invitation.List.Output
    }
}
