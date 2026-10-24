import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Edit.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> Menu.View.Model {
            try await repository.load(id: id)
        }

        func update(
            id: String,
            input: WebModule.Menu.Form.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
