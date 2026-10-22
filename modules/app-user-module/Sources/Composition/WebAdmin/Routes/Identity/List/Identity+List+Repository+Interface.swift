import UserAdminAPI
import UserModule

extension Identity.List.Repository {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?,
            role: String?
        ) async throws
            -> UserAdminAPI.Components.Responses
            .UserIdentityQueryItemSearchSchemaSearchResponse

    }
}
