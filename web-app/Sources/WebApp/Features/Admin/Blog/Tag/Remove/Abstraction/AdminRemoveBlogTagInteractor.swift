import Foundation

protocol AdminRemoveBlogTagInteractor: Sendable {

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel

    func delete(
        id: String
    ) async throws
}
