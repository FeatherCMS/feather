import Foundation

protocol AdminEditBlogAuthorInteractor: Sendable {

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel

    func update(
        id: String,
        input: BlogAuthorFormInput
    ) async throws
}
