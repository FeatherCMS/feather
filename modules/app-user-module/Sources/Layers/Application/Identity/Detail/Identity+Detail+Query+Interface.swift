public import UserModule

extension Identity.Detail.Query {
    public protocol Interface: Sendable {
        func find(id: String) async throws -> Identity.Detail.Output
    }
}
