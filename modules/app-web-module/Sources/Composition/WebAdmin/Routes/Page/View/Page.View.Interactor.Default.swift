import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.View.Interactor {
    struct Default: Interface {
        let repository: any Page.View.Repository.Interface

        func execute(
            entity: Page.View.Input
        ) async throws -> Page.Details.Model {
            try await repository.get(id: entity.id)
        }
    }
}
