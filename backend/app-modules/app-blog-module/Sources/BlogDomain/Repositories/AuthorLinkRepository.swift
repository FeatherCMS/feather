import Domain

public protocol AuthorLinkRepository: Repository {

    func find(
        id: String
    ) async throws -> AuthorLink?

    func insert(
        _ model: AuthorLink.New
    ) async throws -> AuthorLink

    func update(
        _ model: AuthorLink
    ) async throws -> AuthorLink

    func delete(
        id: String
    ) async throws -> Bool
}
