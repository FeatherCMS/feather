import NewsApplication
import NewsModule

extension Article.Detail.Interactor {
    struct Default: Interface {
        let repository: any Article.Detail.Repository.Interface

        func get(
            id: String
        ) async throws -> Article.Detail.Model {
            try await repository.get(id: id)
        }
    }
}
