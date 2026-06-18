import Foundation

protocol AdminEditBlogAuthorLinkInteractor: Sendable {

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
