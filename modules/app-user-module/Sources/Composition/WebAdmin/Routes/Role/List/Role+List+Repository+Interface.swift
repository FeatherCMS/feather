import FeatherWebAdmin
import UserAdminAPI
import UserModule

extension Role.List.Repository {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws
            -> UserAdminAPI.Components.Responses
            .UserRoleQueryItemSearchSchemaSearchResponse

    }
}
