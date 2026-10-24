import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Add.Interactor {
    struct Default: Interface {
        let repository: any Page.Add.Repository.Interface

        func execute(
            input: Page.Form.Input
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
