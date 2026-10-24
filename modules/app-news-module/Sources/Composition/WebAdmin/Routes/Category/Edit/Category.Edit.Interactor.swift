import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Edit {
    enum Interactor {}
}

extension Category.Edit.Interactor {
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
