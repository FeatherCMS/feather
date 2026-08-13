import FeatherDomain

public protocol CredentialRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Credential?

    func findBy(
        userId: String
    ) async throws -> Credential?

    func findBy(
        email: String
    ) async throws -> Credential?

    func insert(
        _ model: Credential.New
    ) async throws -> Credential

    func update(
        _ model: Credential
    ) async throws -> Credential

    func delete(
        id: String
    ) async throws -> Bool
}
