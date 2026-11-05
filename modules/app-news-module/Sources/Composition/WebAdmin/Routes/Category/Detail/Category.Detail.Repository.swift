import NewsApplication
import NewsModule

extension Category.Detail {
    enum Repository {}
}

extension Category.Detail.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Category.Detail.Model
    }
}
