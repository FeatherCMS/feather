import BlogModule
import BlogWebShared

extension Post.Edit {
    enum Repository {}
}

extension Post.Edit.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> Post.View.Details.Model
        func update(id: String, input: BlogPostFormInput) async throws
    }
}
