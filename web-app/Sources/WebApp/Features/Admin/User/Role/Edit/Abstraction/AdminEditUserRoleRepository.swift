import Foundation

protocol AdminEditUserRoleRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel

    func update(
        id: String,
        payload: UserRoleFormPayloadModel
    ) async throws
}
