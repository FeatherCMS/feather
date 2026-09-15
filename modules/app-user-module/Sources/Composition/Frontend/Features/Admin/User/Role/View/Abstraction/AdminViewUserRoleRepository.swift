import FeatherAdmin
import Foundation

protocol AdminViewUserRoleRepository: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel
}
