import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Edit {
    enum Interactor {}
}

extension WebAdmin.System.Permission.Edit.Interactor {
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
