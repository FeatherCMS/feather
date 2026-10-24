import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Remove {
    enum Repository {}
}

extension Category.Remove.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Components.Schemas.NewsCategoryDetailSchema
        func remove(id: String) async throws
    }
}
