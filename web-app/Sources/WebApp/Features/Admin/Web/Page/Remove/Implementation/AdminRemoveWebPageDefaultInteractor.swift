import Foundation

struct AdminRemoveWebPageDefaultInteractor:
    AdminRemoveWebPageInteractor
{
    let repository: any AdminRemoveWebPageRepository

    func get(
        id: String
    ) async throws -> WebPageDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
