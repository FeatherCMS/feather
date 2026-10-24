import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Edit.Interactor {
    struct Default: Interface {
        let repository: any Page.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> Page.Edit.Model {
            try await repository.load(id: id)
        }

        func update(
            id: String,
            input: Page.Form.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
