import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Edit {
    enum Repository {}
}

extension WebAdmin.System.Permission.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> SystemPermissionDetailsModel

        func update(
            id: String,
            input: SystemPermissionEditFormInput
        ) async throws
    }
}
