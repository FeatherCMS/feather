import BlogModule

extension Post.List {
    enum Repository {}
}

extension Post.List.Repository {
    protocol Interface: Sendable {
        func search(page: Int, search: String?) async throws -> Post.List.Model
    }
}
