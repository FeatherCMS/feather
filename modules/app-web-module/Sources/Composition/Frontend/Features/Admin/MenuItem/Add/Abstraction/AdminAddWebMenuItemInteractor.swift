import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebMenuItemInteractor: Sendable {

    func loadPermissions(
    ) async throws -> [String]

    func execute(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws
}
