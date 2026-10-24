import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Edit {
    enum Repository {}
}

extension Category.Edit.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema
        func update(
            id: String,
            input: Components.Schemas.NewsCategoryCreateSchema
        ) async throws
    }
}
