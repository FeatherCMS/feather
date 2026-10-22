import BlogModule

extension Tag.Edit {
    enum Interactor {}
}

extension Tag.Edit.Interactor {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Tag.Detail.Model
        func update(id: String, input: BlogTagFormInput) async throws
    }
}
