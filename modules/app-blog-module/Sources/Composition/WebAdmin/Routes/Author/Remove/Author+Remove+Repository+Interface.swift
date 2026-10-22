import BlogModule

extension Author.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
