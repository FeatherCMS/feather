import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Edit {
    enum Repository {}
}

extension Article.Edit.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema
        func categories() async throws -> [Article.Form.CategoryOption]
        func update(
            id: String,
            input: Components.Schemas.NewsArticleCreateSchema
        ) async throws
    }
}
