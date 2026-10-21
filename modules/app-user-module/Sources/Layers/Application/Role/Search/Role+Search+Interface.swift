public import UserModule

extension Role.Search {
    public protocol Interface: Sendable {
        func search(
            query: Role.Search.Input.Query
        ) async throws -> Role.Search.Output
    }
}
