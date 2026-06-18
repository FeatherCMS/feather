import Foundation

protocol AdminRemoveUserRoleRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel

    func delete(
        id: String
    ) async throws
}
