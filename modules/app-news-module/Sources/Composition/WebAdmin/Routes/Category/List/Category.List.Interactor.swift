import NewsApplication
import NewsModule

extension Category.List {
    enum Interactor {}
}

extension Category.List.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Category.List.Model
    }
}
