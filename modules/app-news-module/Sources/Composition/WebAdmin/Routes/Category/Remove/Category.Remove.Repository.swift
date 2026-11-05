import NewsApplication
import NewsModule

extension Category.Remove {
    enum Repository {}
}

extension Category.Remove.Repository {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Category.Detail.Model
        func remove(id: String) async throws
    }
}
