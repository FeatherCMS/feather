import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Add.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.Add.Repository.Interface

        func execute(
            input: MenuFormInput
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
