import ContactAdminAPI
import ContactApplication
import ContactModule

extension Form.Search.Interactor {
    struct Default: Interface {
        let repository: Form.Search.Repository.OpenAPI

        func search(
            page: Int,
            search: String
        ) async throws -> Form.Search.Model.Result {
            try await repository.search(page: page, search: search)
        }
    }
}
