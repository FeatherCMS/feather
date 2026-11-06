import BlogModule

extension Author.List {
    enum Repository {}
}

extension Author.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> Author.List.Model
    }
}
