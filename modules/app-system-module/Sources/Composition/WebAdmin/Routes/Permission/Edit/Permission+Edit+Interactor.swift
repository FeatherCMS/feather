import FeatherAdmin
import SystemModule

extension Permission.Edit {
    enum Interactor {}
}

extension Permission.Edit.Interactor {
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
