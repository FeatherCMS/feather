import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Detail {
    enum Repository {}
}

extension Article.Detail.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema
    }
}
