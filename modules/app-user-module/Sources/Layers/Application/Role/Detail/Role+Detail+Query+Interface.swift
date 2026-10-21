public import UserModule

extension Role.Detail.Query {
    public protocol Interface: Sendable {
        func find(id: String) async throws -> Role.Detail.Output
    }
}
