import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityInteractor: Sendable {

    func loadRoleOptions() async throws -> [UserIdentityAddRoleOptionModel]

    func add(
        input: AdminAddUserIdentityFormInput
    ) async throws
}
