import BlogModule

extension Author.List {
    enum Interactor {}
}

extension Author.List.Interactor {
    protocol Interface: Sendable {
        func list(page: Int, search: String?) async throws -> Author.List.Model
    }
}
