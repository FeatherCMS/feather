import Foundation

protocol AdminGetSystemPermissionInteractor: Sendable {

    func execute(
        entity: AdminGetSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel
}
