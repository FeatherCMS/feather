import NewsApplication
import NewsModule

extension Article.List.Interactor {
    struct Default: Interface {
        let repository: any Article.List.Repository.Interface

        func search(
            page: Int,
            search: String?
        ) async throws -> Article.List.Model {
            try await repository.search(page: page, search: search)
        }
    }
}
