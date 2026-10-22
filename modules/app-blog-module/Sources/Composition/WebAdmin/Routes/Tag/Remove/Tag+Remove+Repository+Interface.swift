import BlogModule

extension Tag.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
