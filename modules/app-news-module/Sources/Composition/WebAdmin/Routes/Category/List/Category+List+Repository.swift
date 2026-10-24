import NewsApplication
import NewsModule

extension Category.List {
    enum Repository {}
}

extension Category.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Category.List.Model
    }
}
