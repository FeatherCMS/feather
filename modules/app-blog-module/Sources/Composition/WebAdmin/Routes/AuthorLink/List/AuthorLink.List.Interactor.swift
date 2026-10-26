import BlogModule

extension AuthorLink.List {
    enum Interactor {}
}

extension AuthorLink.List.Interactor {
    protocol Interface: Sendable {
        func list(
            authorID: String,
            page: Int,
            search: String?
        ) async throws -> AuthorLink.List.Model
    }
}
