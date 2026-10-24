import NewsAdminAPI
import NewsApplication
import NewsModule

extension Article.Remove {
    enum Interactor {}
}

extension Article.Remove.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema
        func remove(id: String) async throws
    }
}
