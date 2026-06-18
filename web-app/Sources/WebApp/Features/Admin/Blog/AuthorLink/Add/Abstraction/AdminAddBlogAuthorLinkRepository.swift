import Foundation

protocol AdminAddBlogAuthorLinkRepository: Sendable {

    func create(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
