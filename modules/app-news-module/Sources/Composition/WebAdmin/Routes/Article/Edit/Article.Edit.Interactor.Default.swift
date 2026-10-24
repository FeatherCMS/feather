import NewsApplication
import NewsAdminAPI
import NewsModule

extension Article.Edit.Interactor {
    struct Default: Interface {
        let repository: any Article.Edit.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsArticleDetailSchema {
            try await repository.get(id: id)
        }

        func categories() async throws -> [Article.Form.CategoryOption] {
            try await repository.categories()
        }

        func update(
            id: String,
            input: Components.Schemas.NewsArticleCreateSchema
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
