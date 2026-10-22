import BlogModule

extension Tag.Remove.Interactor {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
