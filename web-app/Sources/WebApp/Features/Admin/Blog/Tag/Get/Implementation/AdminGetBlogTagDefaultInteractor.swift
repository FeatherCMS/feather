import Foundation

struct AdminGetBlogTagDefaultInteractor: AdminGetBlogTagInteractor {
    let repository: any AdminGetBlogTagRepository

    func execute(
        entity: AdminGetBlogTagModel
    ) async throws -> BlogTagDetailsModel {
        try await repository.get(id: entity.id)
    }
}
