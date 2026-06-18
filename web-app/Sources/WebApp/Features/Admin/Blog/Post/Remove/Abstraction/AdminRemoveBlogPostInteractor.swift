import Foundation

protocol AdminRemoveBlogPostInteractor: Sendable {

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel

    func delete(
        id: String
    ) async throws
}
