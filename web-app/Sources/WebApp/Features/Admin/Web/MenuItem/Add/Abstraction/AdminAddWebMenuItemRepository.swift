import Foundation

protocol AdminAddWebMenuItemRepository: Sendable {

    func create(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws
}
