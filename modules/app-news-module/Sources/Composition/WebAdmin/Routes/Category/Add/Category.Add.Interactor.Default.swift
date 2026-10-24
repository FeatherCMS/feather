import NewsApplication
import NewsAdminAPI
import NewsModule

extension Category.Add.Interactor {
    struct Default: Interface {
        let repository: any Category.Add.Repository.Interface

        func create(
            input: Components.Schemas.NewsCategoryCreateSchema
        ) async throws {
            try await repository.create(input: input)
        }
    }
}
