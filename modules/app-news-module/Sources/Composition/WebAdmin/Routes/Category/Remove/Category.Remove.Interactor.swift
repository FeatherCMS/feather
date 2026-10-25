import NewsApplication
import NewsModule

extension Category.Remove {
    enum Interactor {}
}

extension Category.Remove.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Category.Detail.Model
        func remove(id: String) async throws
    }
}
