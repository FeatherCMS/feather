import NewsApplication
import NewsModule

extension Category.Detail.Interactor {
    struct Default: Interface {
        let repository: any Category.Detail.Repository.Interface

        func get(
            id: String
        ) async throws -> Category.Detail.Model {
            try await repository.get(id: id)
        }
    }
}
