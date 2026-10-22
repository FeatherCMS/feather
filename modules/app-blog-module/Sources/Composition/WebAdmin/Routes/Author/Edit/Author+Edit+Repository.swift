import BlogModule

extension Author.Edit {
    enum Repository {}
}

extension Author.Edit.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Author.Details.Model
        func update(id: String, input: BlogAuthorFormInput) async throws
    }
}
