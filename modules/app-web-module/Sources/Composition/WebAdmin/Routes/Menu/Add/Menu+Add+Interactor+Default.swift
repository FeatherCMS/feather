import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.Add.Interactor {
    struct Default: Interface {
        let repository: any WebDomain.Menu.Add.Repository.Interface

        func execute(
            input: MenuFormInput
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
