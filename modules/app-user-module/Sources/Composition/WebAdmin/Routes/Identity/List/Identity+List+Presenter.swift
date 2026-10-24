import FeatherModuleKit
import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.List {
    enum Presenter {}
}

extension Identity.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: AdminListModel<
                Components.Schemas.UserIdentityQueryItemSchema
            >,
            permissions: Set<PermissionKey>,
            search: String?,
            role: String?
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Identity.List.Error) async throws
            -> HTMLResponse
    }
}
