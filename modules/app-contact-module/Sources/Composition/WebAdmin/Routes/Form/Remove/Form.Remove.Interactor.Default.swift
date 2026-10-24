import ContactApplication
import ContactModule

extension ContactModule.Form.Remove.Interactor {
    struct Default: Interface {
        let repository: any ContactModule.Form.Remove.Repository.Interface

        func remove(keys: [String]) async throws {
            try await repository.remove(keys: keys)
        }
    }
}
