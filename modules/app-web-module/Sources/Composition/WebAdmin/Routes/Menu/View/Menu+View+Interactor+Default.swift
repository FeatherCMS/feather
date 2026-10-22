import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.View.Interactor {
    struct Default: Interface {
        let repository: any WebDomain.Menu.View.Repository.Interface

        func execute(
            input: WebDomain.Menu.View.Input
        ) async throws -> MenuDetailsModel {
            try await repository.get(id: input.id)
        }
    }
}
