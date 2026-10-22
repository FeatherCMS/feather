import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.Remove.Interactor {
    struct Default: Interface {
        let repository: any WebDomain.Menu.Remove.Repository.Interface

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
