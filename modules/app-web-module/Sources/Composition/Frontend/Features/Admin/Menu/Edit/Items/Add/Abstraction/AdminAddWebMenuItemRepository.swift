import FeatherAdmin
import OpenAPIRuntime

protocol AdminAddWebMenuItemRepository: Sendable {

    func create(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws
}
