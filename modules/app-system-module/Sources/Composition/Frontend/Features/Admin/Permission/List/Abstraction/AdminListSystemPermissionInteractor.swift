import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionInteractor: Sendable {

    func listSystemPermissions(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemPermissionModel

    func remove(
        ids: [String]
    ) async throws
}
