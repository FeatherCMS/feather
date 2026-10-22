import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Add.Interactor {
    struct Default: Interface {
        let repository: any Menu.Add.Repository.Interface

        func execute(
            input: MenuFormInput
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
