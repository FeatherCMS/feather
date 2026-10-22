public import AccountModule

extension Invitation.Search.Query {
    public protocol Interface: Sendable {
        func search(
            query: Invitation.Search.Input.Query
        ) async throws -> Invitation.Search.Output
    }
}
