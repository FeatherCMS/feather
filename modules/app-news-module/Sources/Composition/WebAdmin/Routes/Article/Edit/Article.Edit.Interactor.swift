import NewsAdminAPI
import NewsApplication
import NewsModule

extension Article.Edit {
    enum Interactor {}
}

extension Article.Edit.Interactor {
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
