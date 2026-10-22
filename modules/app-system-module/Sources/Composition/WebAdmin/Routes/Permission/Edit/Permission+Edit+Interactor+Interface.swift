import FeatherWebAdmin
import SystemModule

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
