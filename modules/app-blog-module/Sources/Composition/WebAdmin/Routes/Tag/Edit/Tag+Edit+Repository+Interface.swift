import BlogModule

extension Tag.Edit.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Tag.View.Model
        func update(id: String, input: Tag.Form.Input) async throws
    }
}
