public import AccountModule

extension Invitation.Detail.Query {
    public protocol Interface: Sendable {
        func getBy(id: String) async throws -> Invitation.Detail.Output
        func getBy(token: String) async throws -> Invitation.Detail.Output
    }
}
