import Foundation

protocol AdminAddBlogAuthorInteractor: Sendable {

    func execute(
        input: BlogAuthorFormInput
    ) async throws
}
