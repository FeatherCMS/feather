import Foundation

protocol AdminEditBlogAuthorRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel

    func update(
        id: String,
        input: BlogAuthorFormInput
    ) async throws
}
