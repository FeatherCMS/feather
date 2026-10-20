import FeatherAdmin
import SystemModule

extension Permission.Edit {
    enum Repository {}
}

extension Permission.Edit.Repository {
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
