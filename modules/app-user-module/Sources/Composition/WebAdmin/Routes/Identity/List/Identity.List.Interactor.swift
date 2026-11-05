import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Identity.List {
    enum Interactor {}
}

extension Identity.List.Interactor {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?,
            role: String?
        ) async throws -> AdminListModel<
            Components.Schemas.UserIdentityQueryItemSchema
        >
    }
}
