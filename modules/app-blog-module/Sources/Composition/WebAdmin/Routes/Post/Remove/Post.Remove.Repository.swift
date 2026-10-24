import BlogModule

extension Post.Remove {
    enum Repository {}
}

extension Post.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
