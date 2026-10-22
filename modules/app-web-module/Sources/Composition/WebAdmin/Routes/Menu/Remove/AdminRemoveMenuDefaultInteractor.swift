import FeatherWebAdmin
import OpenAPIRuntime

struct AdminRemoveMenuDefaultInteractor:
    AdminRemoveMenuInteractor
{
    let repository: any AdminRemoveMenuRepository

    func get(
        id: String
    ) async throws -> MenuDetailsModel {
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
