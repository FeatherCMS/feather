import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddMenuItemInteractor: Sendable {

    func loadPermissions() async throws -> [String]

    func execute(
        menuId: String,
        input: MenuItemFormInput
    ) async throws
}
