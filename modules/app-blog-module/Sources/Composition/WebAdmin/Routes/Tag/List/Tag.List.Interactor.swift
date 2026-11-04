import BlogModule

extension Tag.List {
    enum Interactor {}
}

extension Tag.List.Interactor {
    protocol Interface: Sendable {
        func execute(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> Tag.List.Model
    }
}
