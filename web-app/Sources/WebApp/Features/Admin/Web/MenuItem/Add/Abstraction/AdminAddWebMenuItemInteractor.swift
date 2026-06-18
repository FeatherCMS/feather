import Foundation

protocol AdminAddWebMenuItemInteractor: Sendable {

    func execute(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws
}
