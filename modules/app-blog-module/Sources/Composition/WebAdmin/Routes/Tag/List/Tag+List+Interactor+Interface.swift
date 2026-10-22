import BlogModule

extension Tag.List.Interactor {
    protocol Interface: Sendable {
        func execute(page: Int, search: String?) async throws -> Tag.List.Model
    }
}
