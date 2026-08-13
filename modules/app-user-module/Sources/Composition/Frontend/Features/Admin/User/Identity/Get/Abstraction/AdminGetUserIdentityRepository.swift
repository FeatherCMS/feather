import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminGetUserIdentityRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserIdentityDetailsModel
}
