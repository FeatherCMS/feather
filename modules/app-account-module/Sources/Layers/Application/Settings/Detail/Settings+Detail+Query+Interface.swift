public import AccountDomain
public import AccountModule

extension Settings.Detail.Query {
    public protocol Interface: Sendable {
        func get(userId: String) async throws -> Settings.Model
    }
}
