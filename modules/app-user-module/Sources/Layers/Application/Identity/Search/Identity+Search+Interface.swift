public import UserModule

extension Identity.Search {
    public protocol Interface: Sendable {
        func search(
            query: Identity.Search.Input.Query
        ) async throws -> Identity.Search.Output
    }
}
