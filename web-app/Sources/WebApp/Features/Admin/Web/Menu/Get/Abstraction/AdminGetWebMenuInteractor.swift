import Foundation

protocol AdminGetWebMenuInteractor: Sendable {

    func execute(
        entity: AdminGetWebMenuModel
    ) async throws -> WebMenuDetailsModel
}
