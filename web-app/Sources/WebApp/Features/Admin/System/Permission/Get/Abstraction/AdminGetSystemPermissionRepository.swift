import AdminOpenAPI
import Foundation

protocol AdminGetSystemPermissionRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel
}
