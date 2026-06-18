import Domain

public protocol PageRepository: Repository {

    func find(
        id: String
    ) async throws -> Page?

    func insert(
        _ model: Page.New
    ) async throws -> Page

    func update(
        _ model: Page
    ) async throws -> Page

    func delete(
        id: String
    ) async throws -> Bool
}
