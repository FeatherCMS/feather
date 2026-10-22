import BlogModule
import BlogWebShared

extension Post.Add {
    enum Interactor {}
}

extension Post.Add.Interactor {
    protocol Interface: Sendable {
        func loadOptions() async throws -> BlogPostAssociationOptionsModel
        func execute(input: BlogPostFormInput) async throws
    }
}
