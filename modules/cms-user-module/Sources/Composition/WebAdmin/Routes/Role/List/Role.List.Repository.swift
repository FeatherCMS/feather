import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Role.List {
    enum Repository {}
}

extension Role.List.Repository {
    protocol Interface: Sendable {

        func search(
            page: Int,
            size: Int,
            search: String?
        ) async throws
            -> UserAdminAPI.Components.Responses
            .UserRoleQueryItemSearchSchemaSearchResponse

    }
}
