import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminAddMenuItemRepository: Sendable {

    func create(
        menuId: String,
        input: MenuItemFormInput
    ) async throws
}
