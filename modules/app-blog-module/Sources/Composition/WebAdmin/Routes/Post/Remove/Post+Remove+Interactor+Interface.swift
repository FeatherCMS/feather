import BlogModule

extension Post.Remove.Interactor {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
