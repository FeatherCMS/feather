import Foundation

protocol AdminEditBlogPostRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogPostDetailsModel

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws
}
