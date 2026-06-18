import Foundation

struct AdminAddWebMenuItemDefaultInteractor: AdminAddWebMenuItemInteractor {
    let repository: any AdminAddWebMenuItemRepository

    func execute(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws {
        try await repository.create(menuId: menuId, input: input)
    }
}
