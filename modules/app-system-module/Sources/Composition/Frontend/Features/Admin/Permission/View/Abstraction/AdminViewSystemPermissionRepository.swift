import FeatherAdmin
import Foundation
import SystemAdminAPI

protocol AdminViewSystemPermissionRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel
}
