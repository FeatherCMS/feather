import FeatherAdmin
import Foundation

protocol AdminEditSystemPermissionInteractor: Sendable {

    func load(
        id: String
    ) async throws -> SystemPermissionDetailsModel

    func update(
        id: String,
        input: SystemPermissionEditFormInput
    ) async throws
}
