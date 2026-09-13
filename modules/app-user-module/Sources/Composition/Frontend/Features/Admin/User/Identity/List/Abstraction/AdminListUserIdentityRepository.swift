import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserIdentityRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> UserAdminAPI.Components.Responses
        .UserIdentityListItemSearchSchemaSearchResponse

}
