import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminEditWebMenuItemInteractor: Sendable {

    func loadPermissions() async throws -> [String]

    func load(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel

    func update(
        menuId: String,
        id: String,
        input: WebMenuItemFormInput
    ) async throws
}
