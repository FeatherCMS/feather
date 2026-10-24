import UserAdminAPI
import UserModule

extension Identity.List {
    enum Repository {}
}

extension Identity.List.Repository {
    protocol Interface: Sendable {

        func search(
            page: Int,
            size: Int,
            search: String?,
            role: String?
        ) async throws
            -> UserAdminAPI.Components.Responses
            .UserIdentityQueryItemSearchSchemaSearchResponse

    }
}
