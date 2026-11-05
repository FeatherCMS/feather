import NewsApplication
import NewsModule

extension Article.Detail {
    enum Interactor {}
}

extension Article.Detail.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Article.Detail.Model
    }
}
