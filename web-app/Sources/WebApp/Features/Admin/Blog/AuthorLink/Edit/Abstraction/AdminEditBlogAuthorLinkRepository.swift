import Foundation

protocol AdminEditBlogAuthorLinkRepository: Sendable {

    func load(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func update(
        menuId: String,
        id: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
