import Domain

public protocol MetadataRepository: Repository {

    func find(
        id: String
    ) async throws -> Metadata?

    func find(
        slug: String
    ) async throws -> Metadata?

    func find(
        reference: Metadata.Reference
    ) async throws -> Metadata?

    func insert(
        _ model: Metadata.New
    ) async throws -> Metadata

    func update(
        _ model: Metadata
    ) async throws -> Metadata

    func delete(
        id: String
    ) async throws -> Bool

    func delete(
        reference: Metadata.Reference
    ) async throws -> Bool
}
