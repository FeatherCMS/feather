import Foundation

protocol AdminEditUserAccountRoleRepository: Sendable {

    func list() async throws -> [AdminEditUserAccountRoleOptionModel]
}
