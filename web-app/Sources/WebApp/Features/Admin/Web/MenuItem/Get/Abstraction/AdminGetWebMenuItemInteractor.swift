import Foundation

protocol AdminGetWebMenuItemInteractor: Sendable {

    func execute(
        entity: AdminGetWebMenuItemModel
    ) async throws -> WebMenuItemDetailsModel
}
