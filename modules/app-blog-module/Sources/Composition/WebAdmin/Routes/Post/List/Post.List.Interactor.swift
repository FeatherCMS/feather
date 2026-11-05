import BlogModule

extension Post.List {
    enum Interactor {}
}

extension Post.List.Interactor {
    protocol Interface: Sendable {
        func list(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> Post.List.Model
    }
}
