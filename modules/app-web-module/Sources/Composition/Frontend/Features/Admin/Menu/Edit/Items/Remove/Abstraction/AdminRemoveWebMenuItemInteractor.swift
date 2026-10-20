import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemInteractor: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws

    func delete(
        menuId: String,
        ids: [String]
    ) async throws
}
