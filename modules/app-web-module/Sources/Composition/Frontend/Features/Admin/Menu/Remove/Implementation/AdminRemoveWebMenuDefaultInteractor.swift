import FeatherAdmin
import OpenAPIRuntime

struct AdminRemoveWebMenuDefaultInteractor:
    AdminRemoveWebMenuInteractor
{
    let repository: any AdminRemoveWebMenuRepository

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel {
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
