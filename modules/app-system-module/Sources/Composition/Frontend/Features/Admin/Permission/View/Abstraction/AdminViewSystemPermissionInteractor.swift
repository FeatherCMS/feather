import FeatherAdmin
import Foundation

protocol AdminViewSystemPermissionInteractor: Sendable {

    func execute(
        entity: AdminViewSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel
}
