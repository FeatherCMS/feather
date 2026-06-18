import Foundation

protocol AdminRemoveBlogAuthorRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel

    func delete(
        id: String
    ) async throws
}
