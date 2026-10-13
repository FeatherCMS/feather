import FeatherAdmin
import SystemAdminAPI

protocol AdminViewSystemPermissionRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel
}
