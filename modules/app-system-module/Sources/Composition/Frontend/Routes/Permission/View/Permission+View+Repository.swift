import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Permission.View {
    enum Repository {}
}

extension WebAdmin.System.Permission.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> SystemPermissionDetailsModel
    }
}
