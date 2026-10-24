import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Detail.Interactor {
    struct Default: Interface {
        let repository: any Article.Detail.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema {
            try await repository.get(id: id)
        }
    }
}
