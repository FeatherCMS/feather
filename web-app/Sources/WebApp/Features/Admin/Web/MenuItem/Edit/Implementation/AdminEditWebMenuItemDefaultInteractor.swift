import Foundation

struct AdminEditWebMenuItemDefaultInteractor:
    AdminEditWebMenuItemInteractor
{
    let repository: any AdminEditWebMenuItemRepository

    func load(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel {
        try await repository.load(menuId: menuId, id: id)
    }

    func update(
        menuId: String,
        id: String,
        input: WebMenuItemFormInput
    ) async throws {
        try await repository.update(menuId: menuId, id: id, input: input)
    }
}
