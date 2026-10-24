import NewsApplication
import NewsAdminAPI
import NewsModule

extension Category.Edit.Interactor {
    struct Default: Interface {
        let repository: any Category.Edit.Repository.Interface

        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema {
            try await repository.get(id: id)
        }

        func update(
            id: String,
            input: Components.Schemas.NewsCategoryCreateSchema
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
