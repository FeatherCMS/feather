import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Remove.Interactor {
    struct Default: Interface {
        let repository: any Page.Remove.Repository.Interface

        func get(
            id: String
        ) async throws -> Page.Details.Model {
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
}
