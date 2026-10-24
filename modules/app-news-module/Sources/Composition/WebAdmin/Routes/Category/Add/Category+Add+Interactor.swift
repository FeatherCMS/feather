import NewsApplication
import NewsAdminAPI
import NewsModule

extension Category.Add {
    enum Interactor {}
}

extension Category.Add.Interactor {
    protocol Interface: Sendable {
        func create(input: Components.Schemas.NewsCategoryCreateSchema)
            async throws
    }
}
