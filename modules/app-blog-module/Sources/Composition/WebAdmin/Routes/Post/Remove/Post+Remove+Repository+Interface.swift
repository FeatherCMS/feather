import BlogModule

extension Post.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
