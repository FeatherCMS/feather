import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminGetUserIdentityRepository: Sendable {

    func load(
        id: String
    ) async throws -> UserIdentityDetailsModel
}
