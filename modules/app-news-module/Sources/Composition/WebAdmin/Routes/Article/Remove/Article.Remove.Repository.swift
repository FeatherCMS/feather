import NewsApplication
import NewsModule

extension Article.Remove {
    enum Repository {}
}

extension Article.Remove.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Article.Detail.Model
        func remove(id: String) async throws
    }
}
