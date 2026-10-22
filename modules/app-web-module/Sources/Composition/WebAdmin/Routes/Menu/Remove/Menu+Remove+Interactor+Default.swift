import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.Remove.Repository.Interface

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
}
