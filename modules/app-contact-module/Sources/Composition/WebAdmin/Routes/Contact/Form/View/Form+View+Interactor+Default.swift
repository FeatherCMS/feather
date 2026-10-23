import ContactApplication
import ContactModule
import FeatherWebAdmin

extension ContactModule.Form.View.Interactor {
    struct Default: Interface {
        let repository: any ContactModule.Form.View.Repository.Interface

        func get(key: String) async throws -> AdminContactFormDetailsItem {
            try await repository.get(key: key)
        }
    }
}
