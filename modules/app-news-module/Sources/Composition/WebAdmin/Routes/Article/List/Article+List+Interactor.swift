import NewsApplication
import NewsModule

extension Article.List {
    enum Interactor {}
}

extension Article.List.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Article.List.Model
    }
}
