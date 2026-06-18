import Foundation

protocol AdminRemoveUserRoleInteractor: Sendable {

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel

    func execute(
        entity: AdminRemoveUserRoleModel
    ) async throws
}
