import NewsApplication
import NewsModule

extension Category.List {
    enum Interactor {}
}

extension Category.List.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> NewsModule.Category.List.Model
    }
}
