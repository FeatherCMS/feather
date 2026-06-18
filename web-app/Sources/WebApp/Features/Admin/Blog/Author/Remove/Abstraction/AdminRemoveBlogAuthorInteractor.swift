import Foundation

protocol AdminRemoveBlogAuthorInteractor: Sendable {

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel

    func delete(
        id: String
    ) async throws
}
