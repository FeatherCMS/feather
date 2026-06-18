import Foundation

struct AdminRemoveBlogAuthorDefaultInteractor:
    AdminRemoveBlogAuthorInteractor
{
    let repository: any AdminRemoveBlogAuthorRepository

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
