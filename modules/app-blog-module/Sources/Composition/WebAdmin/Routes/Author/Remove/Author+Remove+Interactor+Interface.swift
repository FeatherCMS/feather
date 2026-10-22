import BlogModule

extension Author.Remove.Interactor {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
