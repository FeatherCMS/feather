import Domain

public protocol TagRepository: Repository {

    func find(
        id: String
    ) async throws -> Tag?

    func insert(
        _ model: Tag.New
    ) async throws -> Tag

    func update(
        _ model: Tag
    ) async throws -> Tag

    func delete(
        id: String
    ) async throws -> Bool
}
