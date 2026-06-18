import Foundation

protocol AdminGetUserRoleRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel
}
