import NewsApplication
import NewsModule

extension Article.Edit.Interactor {
    struct Default: Interface {
        let repository: any Article.Edit.Repository.Interface

        func get(
            id: String
        ) async throws -> Article.Detail.Model {
            try await repository.get(id: id)
        }

        func categories() async throws -> [Article.Form.CategoryOption] {
            try await repository.categories()
        }

        func update(
            id: String,
            input: Article.Form.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
