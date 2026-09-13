import FeatherAdmin
import Foundation

protocol AdminGetUserRoleRepository: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel
}
