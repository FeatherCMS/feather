import FeatherWebAdmin
import SystemModule

extension Permission.View {
    enum Interactor {}
}

extension Permission.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Permission.View.Model
        ) async throws -> SystemPermissionDetailsModel
    }
}
