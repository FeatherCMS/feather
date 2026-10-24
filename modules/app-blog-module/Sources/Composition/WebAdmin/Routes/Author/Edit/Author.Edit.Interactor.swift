import BlogModule

extension Author.Edit {
    enum Interactor {}
}

extension Author.Edit.Interactor {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Author.View.Model
        func update(id: String, input: Author.Form.Input) async throws
    }
}
