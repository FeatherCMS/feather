import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule

extension Variable.List {
    enum Presenter {}
}

extension Variable.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.SystemVariableListItemSchema
            >,
            permissions: Set<PermissionKey>,
            search: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Variable.List.Error
        ) async throws -> HTMLResponse

    }
}
