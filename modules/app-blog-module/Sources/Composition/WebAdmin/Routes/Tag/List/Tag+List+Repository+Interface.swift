import BlogModule

extension Tag.List.Repository {
    protocol Interface: Sendable {
        func query(page: Int, search: String?) async throws -> Tag.List.Model
    }
}
