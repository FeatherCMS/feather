import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove.Interactor {
    struct Default: Interface {
        let repository: any MenuItem.Remove.Repository.Interface

        func get(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model {
            try await repository.get(menuId: menuId, id: id)
        }

        func delete(
            menuId: String,
            ids: [String]
        ) async throws {
            for id in ids {
                try await repository.delete(menuId: menuId, id: id)
            }
        }
    }
}
