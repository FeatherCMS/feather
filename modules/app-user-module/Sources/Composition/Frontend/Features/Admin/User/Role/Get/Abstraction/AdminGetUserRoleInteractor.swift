import FeatherAdmin
import Foundation

protocol AdminGetUserRoleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel
}
