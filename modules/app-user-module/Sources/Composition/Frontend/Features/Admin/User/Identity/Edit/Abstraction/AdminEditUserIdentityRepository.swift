import FeatherAdmin
import Foundation

protocol AdminEditUserIdentityRepository: Sendable {

    func get(
        id: String
    ) async throws -> AdminEditUserIdentityModel

    func update(
        id: String,
        payload: UserIdentityFormPayloadModel
    ) async throws
}
