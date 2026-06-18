import Foundation

protocol AdminGetUserRoleInteractor: Sendable {

    func execute(
        entity: AdminGetUserRoleModel
    ) async throws -> UserRoleDetailsModel
}
