import BlogModule

extension Tag.Remove {
    enum Repository {}
}

extension Tag.Remove.Repository {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
