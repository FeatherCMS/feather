import FeatherAdmin
import OpenAPIRuntime

protocol AdminViewWebMenuItemRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel
}
