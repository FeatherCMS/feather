import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Role.List {
    enum Interactor {}
}

extension Role.List.Interactor {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> AdminListModel<
            Components.Schemas.UserRoleListItemSchema
        >
    }
}
