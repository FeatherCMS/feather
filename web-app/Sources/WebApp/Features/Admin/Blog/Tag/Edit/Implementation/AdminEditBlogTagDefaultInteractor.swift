import Foundation

struct AdminEditBlogTagDefaultInteractor:
    AdminEditBlogTagInteractor
{
    let repository: any AdminEditBlogTagRepository

    func load(
        id: String
    ) async throws -> BlogTagDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: BlogTagFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
