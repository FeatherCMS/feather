import Domain

public protocol MenuRepository: Repository {

    func find(
        id: String
    ) async throws -> Menu?

    func find(
        key: String
    ) async throws -> Menu?

    func insert(
        _ model: Menu.New
    ) async throws -> Menu

    func update(
        _ model: Menu
    ) async throws -> Menu

    func delete(
        id: String
    ) async throws -> Bool
}
