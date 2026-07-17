public protocol CredentialQueries: Sendable {

    func find(
        id: String
    ) async throws -> CredentialDetail

    func findBy(
        accountID: String
    ) async throws -> CredentialDetail?

    func findBy(
        email: String
    ) async throws -> CredentialDetail?
}
