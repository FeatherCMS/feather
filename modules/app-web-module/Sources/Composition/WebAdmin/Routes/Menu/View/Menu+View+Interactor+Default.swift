import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.View.Repository.Interface

        func execute(
            input: WebModule.Menu.View.Input
        ) async throws -> MenuDetailsModel {
            try await repository.get(id: input.id)
        }
    }
}
