import FeatherWebAdmin
import SystemAdminAPI
import SystemModule

extension Permission.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> SystemPermissionDetailsModel
    }
}
