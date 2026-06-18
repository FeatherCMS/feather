import Foundation

protocol AdminRemoveWebMenuItemInteractor: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
