import Domain

public protocol MenuItemRepository: Repository {

    func find(
        id: String
    ) async throws -> MenuItem?

    func insert(
        _ model: MenuItem.New
    ) async throws -> MenuItem

    func update(
        _ model: MenuItem
    ) async throws -> MenuItem

    func delete(
        id: String
    ) async throws -> Bool
}
