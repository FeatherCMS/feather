import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.View.Interactor {
    struct Default: Interface {
        let repository: any MenuItem.View.Repository.Interface

        func execute(
            input: MenuItem.View.Input
        ) async throws -> MenuItem.View.Model {
            try await repository.get(menuId: input.menuId, id: input.id)
        }
    }
}
