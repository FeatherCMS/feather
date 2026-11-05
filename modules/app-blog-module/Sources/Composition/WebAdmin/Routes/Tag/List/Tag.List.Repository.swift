import BlogModule

extension Tag.List {
    enum Repository {}
}

extension Tag.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> Tag.List.Model
    }
}
