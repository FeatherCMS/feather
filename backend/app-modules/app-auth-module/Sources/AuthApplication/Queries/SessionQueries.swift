import AuthDomain

public protocol SessionQueries: Sendable {

    func find(
        id: String
    ) async throws -> SessionDetail

    func list(
        query: SessionList.Query
    ) async throws -> SessionList
}
