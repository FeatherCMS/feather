import FeatherAdmin
import OpenAPIRuntime

protocol AdminViewWebMenuItemInteractor: Sendable {

    func execute(
        entity: AdminViewWebMenuItemModel
    ) async throws -> WebMenuItemDetailsModel
}
