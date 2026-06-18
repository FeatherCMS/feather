import Foundation

struct AdminGetBlogPostDefaultInteractor: AdminGetBlogPostInteractor {
    let repository: any AdminGetBlogPostRepository

    func execute(
        entity: AdminGetBlogPostModel
    ) async throws -> BlogPostDetailsModel {
        try await repository.get(id: entity.id)
    }
}
