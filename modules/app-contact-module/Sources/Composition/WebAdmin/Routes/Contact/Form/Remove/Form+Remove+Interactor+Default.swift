import ContactApplication
import ContactModule

extension ContactModule.Form.Remove.Interactor {
    struct Default: Interface {
        let repository: ContactModule.Form.Remove.Repository.OpenAPI

        func remove(keys: [String]) async throws {
            try await repository.remove(keys: keys)
        }
    }
}
