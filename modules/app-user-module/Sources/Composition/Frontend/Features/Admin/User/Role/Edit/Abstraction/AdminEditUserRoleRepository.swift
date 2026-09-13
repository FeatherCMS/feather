import FeatherAdmin
import Foundation

protocol AdminEditUserRoleRepository: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel

    func update(
        id: String,
        payload: UserRoleEditFormPayloadModel
    ) async throws
}
