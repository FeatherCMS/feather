import BlogModule
import FeatherValidation

extension AuthorLink.Add.Repository {
    protocol Interface: Sendable {
        func create(
            authorID: String,
            input: AuthorLink.Form.Input
        ) async throws
    }
}
