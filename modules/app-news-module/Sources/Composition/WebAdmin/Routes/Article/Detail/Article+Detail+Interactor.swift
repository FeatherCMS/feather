import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Detail {
    enum Interactor {}
}

extension Article.Detail.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema
    }
}
