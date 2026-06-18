import Foundation

protocol AdminRemoveWebMenuInteractor: Sendable {

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel

    func delete(
        id: String
    ) async throws
}
