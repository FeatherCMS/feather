import BlogModule
import BlogWebShared

extension Post.Edit {
    enum Interactor {}
}

extension Post.Edit.Interactor {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Post.View.Detail.Model
        func loadOptions() async throws -> BlogPostAssociationOptionsModel
        func update(id: String, input: BlogPostFormInput) async throws
    }
}
