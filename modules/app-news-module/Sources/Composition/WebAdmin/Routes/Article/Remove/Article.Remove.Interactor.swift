import NewsApplication
import NewsModule

extension Article.Remove {
    enum Interactor {}
}

extension Article.Remove.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Article.Detail.Model
        func remove(id: String) async throws
    }
}
