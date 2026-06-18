import Foundation

protocol AdminAddBlogAuthorLinkInteractor: Sendable {

    func execute(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
