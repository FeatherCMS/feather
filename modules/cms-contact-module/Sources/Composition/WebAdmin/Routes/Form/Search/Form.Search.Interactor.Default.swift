import ContactAdminAPI
import ContactApplication
import ContactModule

extension Form.Search.Interactor {
    struct Default: Interface {
        let repository: any Form.Search.Repository.Interface

        func search(
            page: Int,
            search: String
        ) async throws -> Form.Search.Model.Result {
            try await repository.search(page: page, search: search)
        }
    }
}
