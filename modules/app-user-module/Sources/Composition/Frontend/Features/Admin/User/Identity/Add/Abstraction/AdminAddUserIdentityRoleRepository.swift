import FeatherAdmin
import Foundation

protocol AdminAddUserIdentityRoleRepository: Sendable {

    func list() async throws -> [UserIdentityAddRoleOptionModel]
}

