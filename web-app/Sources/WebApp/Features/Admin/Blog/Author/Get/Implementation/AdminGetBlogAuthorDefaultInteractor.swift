import Foundation

struct AdminGetBlogAuthorDefaultInteractor: AdminGetBlogAuthorInteractor {
    let repository: any AdminGetBlogAuthorRepository

    func execute(
        entity: AdminGetBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.get(id: entity.id)
    }
}
