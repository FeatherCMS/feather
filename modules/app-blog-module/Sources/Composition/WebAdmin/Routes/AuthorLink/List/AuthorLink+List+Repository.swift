import BlogModule

extension AuthorLink.List {
    enum Repository {}
}

extension AuthorLink.List.Repository {
    protocol Interface: Sendable {
        func list(
            authorID: String,
            page: Int,
            search: String?
        ) async throws -> AuthorLink.List.Model
    }
}
