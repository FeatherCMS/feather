import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewMenuItemInteractor: Sendable {

    func execute(
        entity: AdminViewMenuItemModel
    ) async throws -> MenuItemDetailsModel
}
