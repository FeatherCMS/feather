import FeatherAdmin
import Foundation

protocol AdminEditUserIdentityInteractor: Sendable {

    func load(
        id: String
    ) async throws -> AdminEditUserIdentityModel

    func loadRoleOptions() async throws
        -> [UserIdentityRoleOptionModel]

    func edit(
        id: String,
        input: AdminEditUserIdentityFormInput
    ) async throws
}
