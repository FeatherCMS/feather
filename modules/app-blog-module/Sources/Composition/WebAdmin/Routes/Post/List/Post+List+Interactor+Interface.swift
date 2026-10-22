import BlogModule

extension Post.List.Interactor {
    protocol Interface: Sendable {
        func list(page: Int, search: String?) async throws -> Post.List.Model
    }
}
