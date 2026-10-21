import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import UserAdminAPI
import UserModule

extension Role.List {
    enum Presenter {}
}

extension Role.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: AdminListModel<Components.Schemas.UserRoleQueryItemSchema>,
            permissions: Set<PermissionKey>,
            search: String?
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Role.List.Error) async throws
            -> HTMLResponse
    }
}
