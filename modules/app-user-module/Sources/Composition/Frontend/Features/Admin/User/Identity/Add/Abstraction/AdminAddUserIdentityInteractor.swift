import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityInteractor: Sendable {

    func loadRoleOptions() async throws -> [UserIdentityRoleOptionModel]

    func add(
        input: AdminAddUserIdentityFormInput
    ) async throws
}
