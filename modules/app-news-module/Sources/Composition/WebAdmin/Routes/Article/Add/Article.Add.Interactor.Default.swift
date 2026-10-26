import NewsApplication
import NewsModule

extension Article.Add.Interactor {
    struct Default: Interface {
        let repository: any Article.Add.Repository.Interface

        func categories() async throws -> [Article.Form.CategoryOption] {
            try await repository.categories()
        }

        func create(
            input: Article.Form.Input
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
