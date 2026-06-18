import Foundation

protocol AdminGetWebMenuItemRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel
}
