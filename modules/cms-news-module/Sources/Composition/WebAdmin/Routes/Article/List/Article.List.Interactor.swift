import NewsApplication
import NewsModule

extension Article.List {
    enum Interactor {}
}

extension Article.List.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> NewsModule.Article.List.Model
    }
}
