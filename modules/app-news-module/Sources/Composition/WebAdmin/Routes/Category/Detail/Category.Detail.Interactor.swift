import NewsApplication
import NewsModule

extension Category.Detail {
    enum Interactor {}
}

extension Category.Detail.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Category.Detail.Model
    }
}
