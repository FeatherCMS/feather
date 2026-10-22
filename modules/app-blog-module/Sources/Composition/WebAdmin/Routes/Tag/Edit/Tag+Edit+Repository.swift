import BlogModule

extension Tag.Edit {
    enum Repository {}
}

extension Tag.Edit.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Tag.Details.Model
        func update(id: String, input: BlogTagFormInput) async throws
    }
}
