import FeatherAdmin
import Foundation
import SystemAdminAPI

protocol AdminGetSystemPermissionRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel
}
