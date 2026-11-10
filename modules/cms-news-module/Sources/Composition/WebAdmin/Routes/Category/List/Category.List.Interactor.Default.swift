import NewsApplication
import NewsModule

extension Category.List.Interactor {
    struct Default: Interface {
        let repository: any Category.List.Repository.Interface

        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> NewsModule.Category.List.Model {
            try await repository.search(page: page, search: search, status: status)
        }
    }
}
