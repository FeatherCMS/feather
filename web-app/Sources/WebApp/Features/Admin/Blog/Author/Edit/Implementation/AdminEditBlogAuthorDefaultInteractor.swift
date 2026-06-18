import Foundation

struct AdminEditBlogAuthorDefaultInteractor:
    AdminEditBlogAuthorInteractor
{
    let repository: any AdminEditBlogAuthorRepository

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: BlogAuthorFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
