public protocol CredentialQueries: Sendable {

    func list(
        query: CredentialList.Query
    ) async throws -> CredentialList

    func list(
        accountID: String,
        query: CredentialList.Query
    ) async throws -> CredentialList

    func count(
        query: CredentialList.Query
    ) async throws -> Int

    func count(
        accountID: String,
        query: CredentialList.Query
    ) async throws -> Int

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
