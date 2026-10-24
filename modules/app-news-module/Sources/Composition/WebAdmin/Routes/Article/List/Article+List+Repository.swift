import NewsApplication
import NewsModule

extension Article.List {
    enum Repository {}
}

extension Article.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Article.List.Model
    }
}
