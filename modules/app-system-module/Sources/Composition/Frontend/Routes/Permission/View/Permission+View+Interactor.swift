import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.View {
    enum Interactor {}
}

extension WebAdmin.System.Permission.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: WebAdmin.System.Permission.View.Model
        ) async throws -> SystemPermissionDetailsModel
    }
}
