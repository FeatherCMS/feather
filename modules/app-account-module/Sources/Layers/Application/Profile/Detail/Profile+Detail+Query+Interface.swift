public import AccountDomain
public import AccountModule

extension Profile.Detail.Query {
    public protocol Interface: Sendable {
        func get(userId: String) async throws -> Profile.Model
    }
}
