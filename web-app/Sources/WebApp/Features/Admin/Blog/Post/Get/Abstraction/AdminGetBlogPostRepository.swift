import Foundation

protocol AdminGetBlogPostRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel
}
