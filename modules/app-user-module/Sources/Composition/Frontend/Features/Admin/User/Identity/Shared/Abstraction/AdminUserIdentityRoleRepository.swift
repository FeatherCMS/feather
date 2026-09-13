import FeatherAdmin
import Foundation

protocol AdminUserIdentityRoleRepository: Sendable {

    func list() async throws -> [UserIdentityRoleOptionModel]
}
