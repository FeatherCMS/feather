import Foundation

protocol AdminGetBlogPostInteractor: Sendable {

    func execute(
        entity: AdminGetBlogPostModel
    ) async throws -> BlogPostDetailsModel
}
