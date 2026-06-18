import Hummingbird

protocol AdminListWebMenuInteractor: Sendable {

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
