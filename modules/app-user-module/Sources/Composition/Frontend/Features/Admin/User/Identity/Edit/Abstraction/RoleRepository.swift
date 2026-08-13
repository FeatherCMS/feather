import FeatherAdmin
import Foundation

protocol AdminEditUserIdentityRoleRepository: Sendable {

    func list() async throws -> [AdminEditUserIdentityRoleOptionModel]
}
