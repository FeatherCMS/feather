import Hummingbird

protocol AdminListSystemPermissionInteractor: Sendable {

    func listSystemPermissions(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemPermissionModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
