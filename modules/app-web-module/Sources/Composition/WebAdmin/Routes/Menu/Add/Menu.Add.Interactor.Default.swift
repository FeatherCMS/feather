import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.Add.Repository.Interface

        func execute(
            input: WebModule.Menu.Form.Input
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
