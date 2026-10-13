import FeatherAdmin
import UserAdminAPI

protocol AdminViewUserIdentityRepository: Sendable {

    func load(
        id: String
    ) async throws -> UserIdentityDetailsModel
}
