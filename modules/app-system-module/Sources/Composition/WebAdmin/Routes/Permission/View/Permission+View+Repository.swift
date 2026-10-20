import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension Permission.View {
    enum Repository {}
}

extension Permission.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> SystemPermissionDetailsModel
    }
}
