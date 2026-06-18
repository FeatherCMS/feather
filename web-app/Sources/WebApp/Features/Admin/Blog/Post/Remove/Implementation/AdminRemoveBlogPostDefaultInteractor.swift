import Foundation

struct AdminRemoveBlogPostDefaultInteractor:
    AdminRemoveBlogPostInteractor
{
    let repository: any AdminRemoveBlogPostRepository

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
