import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Remove.Interactor {
    struct Default: Interface {
        let repository: any Category.Remove.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema {
            try await repository.get(id: id)
        }

        func remove(id: String) async throws {
            try await repository.remove(id: id)
        }
    }
}
