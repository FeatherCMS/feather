import Foundation

protocol AdminEditSystemPermissionRepository: Sendable {

    func load(
        id: String
    ) async throws -> SystemPermissionDetailsModel

    func update(
        id: String,
        input: SystemPermissionFormInput
    ) async throws
}
