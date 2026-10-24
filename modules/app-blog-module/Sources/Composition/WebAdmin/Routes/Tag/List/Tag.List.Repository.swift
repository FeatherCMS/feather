import BlogModule

extension Tag.List {
    enum Repository {}
}

extension Tag.List.Repository {
    protocol Interface: Sendable {
        func search(page: Int, search: String?) async throws -> Tag.List.Model
    }
}
