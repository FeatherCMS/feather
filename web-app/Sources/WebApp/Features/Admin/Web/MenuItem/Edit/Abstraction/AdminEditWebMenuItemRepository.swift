import Foundation

protocol AdminEditWebMenuItemRepository: Sendable {

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
