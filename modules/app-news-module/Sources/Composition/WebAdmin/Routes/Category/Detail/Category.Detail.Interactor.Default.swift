import NewsApplication
import NewsAdminAPI
import NewsModule

extension Category.Detail.Interactor {
    struct Default: Interface {
        let repository: any Category.Detail.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema {
            try await repository.get(id: id)
        }
    }
}
