import FeatherAdmin
import Foundation

protocol AdminEditUserIdentityInteractor: Sendable {

    func loadIdentity(
        id: String
    ) async throws -> AdminEditUserIdentityModel

    func loadRoleOptions() async throws
        -> [AdminEditUserIdentityRoleOptionModel]

    func update(
        entity: AdminEditUserIdentityModel
    ) async throws
}
