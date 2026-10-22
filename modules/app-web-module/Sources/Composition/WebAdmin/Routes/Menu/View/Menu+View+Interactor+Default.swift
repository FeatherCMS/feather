import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.View.Interactor {
    struct Default: Interface {
        let repository: any Menu.View.Repository.Interface

        func execute(
            input: Menu.View.Input
        ) async throws -> MenuDetailsModel {
            try await repository.get(id: input.id)
        }
    }
}
