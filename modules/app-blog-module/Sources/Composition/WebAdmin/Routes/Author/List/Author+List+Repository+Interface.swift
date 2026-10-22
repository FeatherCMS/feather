import BlogModule

extension Author.List.Repository {
    protocol Interface: Sendable {
        func list(page: Int, search: String?) async throws -> Author.List.Model
    }
}
