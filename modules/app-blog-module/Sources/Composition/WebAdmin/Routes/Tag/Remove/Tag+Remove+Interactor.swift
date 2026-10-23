import BlogModule

extension Tag.Remove {
    enum Interactor {}
}

extension Tag.Remove.Interactor {
    protocol Interface: Sendable {
        func delete(ids: [String]) async throws
    }
}
