import Domain

public protocol AuthorRepository: Repository {

    func find(
        id: String
    ) async throws -> Author?

    func insert(
        _ model: Author.New
    ) async throws -> Author

    func update(
        _ model: Author
    ) async throws -> Author

    func delete(
        id: String
    ) async throws -> Bool
}
