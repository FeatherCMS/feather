import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionRepository: Sendable {

    func listSystemPermissions(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemPermissionModel

    func delete(
        id: String
    ) async throws
}
