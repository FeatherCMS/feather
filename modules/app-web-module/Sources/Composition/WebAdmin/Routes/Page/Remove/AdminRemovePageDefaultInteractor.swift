import FeatherWebAdmin
import OpenAPIRuntime

struct AdminRemovePageDefaultInteractor:
    AdminRemovePageInteractor
{
    let repository: any AdminRemovePageRepository

    func get(
        id: String
    ) async throws -> PageDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }

    func delete(ids: [String]) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
