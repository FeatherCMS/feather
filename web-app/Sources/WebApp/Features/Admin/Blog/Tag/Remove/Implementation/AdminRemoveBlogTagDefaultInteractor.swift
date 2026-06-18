import Foundation

struct AdminRemoveBlogTagDefaultInteractor:
    AdminRemoveBlogTagInteractor
{
    let repository: any AdminRemoveBlogTagRepository

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
