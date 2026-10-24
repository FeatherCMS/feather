import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Add {
    enum Repository {}
}

extension Category.Add.Repository {
    protocol Interface: Sendable {
        func create(input: Components.Schemas.NewsCategoryCreateSchema)
            async throws
    }
}
