import NewsApplication
import NewsAdminAPI
import NewsModule

extension Category.Detail {
    enum Interactor {}
}

extension Category.Detail.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema
    }
}
