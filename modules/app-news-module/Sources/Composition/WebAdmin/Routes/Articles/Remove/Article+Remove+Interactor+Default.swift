import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Remove.Interactor {
    struct Default: Interface {
        let repository: any Article.Remove.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema {
            try await repository.get(id: id)
        }

        func remove(id: String) async throws {
            try await repository.remove(id: id)
        }
    }
}
