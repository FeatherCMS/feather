import BlogModule
import FeatherValidation

extension AuthorLink.Add {
    enum Interactor {}
}

extension AuthorLink.Add.Interactor {
    protocol Interface: Sendable {
        func execute(
            authorID: String,
            input: AuthorLink.Form.Input
        ) async throws
    }
}
