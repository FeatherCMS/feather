import Foundation

protocol AdminAddBlogPostRepository: Sendable {

    func create(
        input: BlogPostFormInput
    ) async throws
}
