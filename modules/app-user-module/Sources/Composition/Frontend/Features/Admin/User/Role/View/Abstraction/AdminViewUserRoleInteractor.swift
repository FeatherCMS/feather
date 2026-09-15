import FeatherAdmin
import Foundation

protocol AdminViewUserRoleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel
}
