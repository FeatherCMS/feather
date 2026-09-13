import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserRoleRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws
        -> UserAdminAPI.Components.Responses
        .UserRoleListItemSearchSchemaSearchResponse

}
