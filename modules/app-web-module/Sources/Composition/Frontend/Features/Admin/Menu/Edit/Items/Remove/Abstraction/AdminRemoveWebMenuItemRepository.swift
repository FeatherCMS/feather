import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
