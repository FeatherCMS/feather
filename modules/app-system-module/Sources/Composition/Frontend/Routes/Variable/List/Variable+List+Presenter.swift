import FeatherAdmin
import FeatherModuleKit
import Hummingbird
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.List {
    enum Presenter {}
}

extension WebAdmin.System.Variable.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.SystemVariableListItemSchema
            >,
            permissions: Set<PermissionKey>,
            search: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Variable.List.Error
        ) async throws -> HTMLResponse

    }
}
