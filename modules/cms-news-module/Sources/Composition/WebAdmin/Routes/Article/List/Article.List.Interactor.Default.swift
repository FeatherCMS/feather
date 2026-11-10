import NewsApplication
import NewsModule

extension Article.List.Interactor {
    struct Default: Interface {
        let repository: any Article.List.Repository.Interface

        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> NewsModule.Article.List.Model {
            try await repository.search(page: page, search: search, status: status)
        }
    }
}
