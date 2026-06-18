import Foundation

protocol AdminEditUserRoleInteractor: Sendable {

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel

    func execute(
        entity: AdminEditUserRoleModel
    ) async throws
}
