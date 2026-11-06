import BlogModule

extension Author.Remove {
    enum Repository {}
}

extension Author.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
